#! /bin/bash -e
#
# sc.sh
# Copyright (C) 2016 Jakub Krajniak <jkrajniak@gmail.com>
#
# Distributed under terms of the GNU GPLv3 license.
#

# Number of CPUs in the environment
if [ "X$PBS_NODEFILE}" != "X" ]; then
    NPROC=$(cat $PBS_NODEFILE | wc -l)
else
    NPROC=1
fi

if [ "X$1" != "X" ]; then
    source ./$1
fi

# COMMANDS
if [ "X$MDRUN" = "X" ]; then
    MDRUN="mdrun_mpi"
fi

if [ "X$GROMPP" = "X" ]; then
    GROMPP="grompp_mpi"
fi

case "X$MPIEXEC" in
    X) MPIEXEC="mpirun -n";;
    XX) MPIEXEC="";;
esac

WORKDIR=${PBS_O_WORKDIR}
if [ "X${PBS_O_WORKDIR}" = "X" ]; then
    WORKDIR="."
fi

if [ "X$DEFORM_TPL" = "X" ]; then
    DEFORM_TPL="grompp_deform.tpl"
fi

if [ "X$DATA_TPL" = "X" ]; then
    DATA_TPL="grompp.mdp"
fi

LOG_FILE="${WORKDIR}/output_${PBS_JOBID}.log"

function logg() {
  LOG_FILE="${WORKDIR}/output_${PBS_JOBID}.log"
  echo ">>> `date`: $1 <<<" | tee -a $LOG_FILE
}

if [ "X$DIRECTION" = "X" ]; then
    echo "Direction not defined in source file!"
    exit 128
fi

case $DIRECTION in
    X|x) compress="0.0 4.5e-5 4.5e-5 0.0 0.0 0.0"; Lx=1;;
    Y|y) compress="4.5e-5 0.0 4.5e-5 0.0 0.0 0.0"; Lx=2;;
    Z|z) compress="4.5e-5 4.5e-5 0.0 0.0 0.0 0.0"; Lx=3;;
esac

logg "`date`"
logg "Running tensile strain experiment, NPROC=$NPROC, DIRECTION=$DIRECTION"

if [ "X$PREFIX" != "X" ]; then
    PREFIX="${PREFIX}_"
fi

# First run for pull_0.00
ZERO_DIR="${PREFIX}pull_000"

echo $ZERO_DIR

if [ -d "$ZERO_DIR" ] && [ -f "${ZERO_DIR}/done" ]; then
    logg "Dir pull_0.00 exists"
else
    if [ -d "${ZERO_DIR}" ]; then
        logg "Dir ${ZERO_DIR} exists but it is not marked as done, remove it"
        rm -rvf ${ZERO_DIR} &>> $LOG_FILE
    fi
    logg "Step ${ZERO_DIR}"
    mkdir ${ZERO_DIR}
    for f in $FIRST_STEP_FILES; do
        cp -v $f ${ZERO_DIR}/ &>> $LOG_FILE
    done

    cp -v $DATA_TPL ${ZERO_DIR} &>> $LOG_FILE

    logg "File copied"
    cd ${ZERO_DIR}

    sed -i "s/^compressibility.*/compressibility = ${compress}  ; dir=$DIRECTION/g" $DATA_TPL

    $GROMPP
    [ "$?" != "0" ] && exit $?
    echo $MPIEXEC $NPROC $MDRUN
    $MPIEXEC $NPROC $MDRUN
    [ "$?" != "0" ] && exit $?

    touch "done"
    cd ..
fi

# Gets the current value of Lz of the box from pull_0.00/confout.gro

Lz="`tail -n1 $ZERO_DIR/confout.gro  | tr -s ' ' | sed -s 's/^[ \t]*//' | cut -f${Lx} -d' '`"

logg "Initial box z-size: $Lz"

# Now run rest of the stress-strain pulling
last_step=${ZERO_DIR}
last_strain=0.0

STEP=0

for s in $STRAIN_STEPS; do
    logg $s

    STEP=$((STEP + 1))

    NEW_STEP_DIR="${PREFIX}pull_"$(awk "BEGIN { printf \"%03d\", $STEP }")
    logg $NEW_STEP_DIR

    if [ -d "$NEW_STEP_DIR" ]; then
        if [ -f "$NEW_STEP_DIR/done" ]; then
            echo "Skip step $s" &>> $LOG_FILE
            last_step=$NEW_STEP_DIR
            last_strain=$s
            continue
        else
            logg "Step $s not finished, clean up and run again"
            rm -rvf $NEW_STEP_DIR &>> $LOG_FILE
        fi
    fi
    mkdir "$NEW_STEP_DIR"
    cp -v ${last_step}/confout.gro ${NEW_STEP_DIR}/conf.gro  &>> $LOG_FILE


    for sf in $STEP_FILES; do
        cp -v $sf ${NEW_STEP_DIR}/ &>> $LOG_FILE
    done

    cp -v ${DEFORM_TPL} ${NEW_STEP_DIR}/ &>> $LOG_FILE
    cp -v ${DATA_TPL} ${NEW_STEP_DIR}/ &>> $LOG_FILE

    cd "${NEW_STEP_DIR}"


    # First run the deformation
    if [ ! -f "done_deform" ]; then
        logg "=============== DEFORMATION $s ============"

        # Prepare deformation file from the template
        Lz="`tail -n1 conf.gro  | tr -s ' ' | sed -s 's/^[ \t]*//' | cut -f${Lx} -d' '`"
        ds=$(awk "BEGIN { print ($s-$last_strain)}")

        echo "# strain d_strain" > strain
        echo "$s $ds" >> strain

        LzFinal=$(awk "BEGIN { print ($Lz + ${ds}*${Lz})}")

        logg "Deformation by $ds from $Lz to ${LzFinal}"

        ../make_deform.sh $ds $Lz $DEFORM_TPL $DIRECTION

        [ "$?" != "0" ] && exit $?

        $GROMPP -f grompp_deform.mdp &>> $LOG_FILE
        $MPIEXEC $NPROC $MDRUN -c confout_deform.gro &>> $LOG_FILE
        [ "$?" != "0" ] && exit $?
        touch done_deform
    else
        logg "Skip deformation $s, done_deform exists"
    fi

    logg "============== Collect data $s =============="

    sed -i "s/^compressibility.*/compressibility = ${compress}  ; dir=$DIRECTION/g" ${DATA_TPL}

    # Now run NPT to collect data
    $GROMPP -f ${DATA_TPL} -c confout_deform.gro &>> $LOG_FILE
    $MPIEXEC $NPROC $MDRUN &>> $LOG_FILE
    [ "$?" != "0" ] && exit $?

    touch "done"

    last_step=$NEW_STEP_DIR
    last_strain=$s
    cd ..
    logg "================ Finished step $s ================="
done

touch "done"
