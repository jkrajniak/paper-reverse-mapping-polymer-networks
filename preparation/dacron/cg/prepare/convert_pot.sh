#!/bin/bash

csg_call --options settings.xml --ia-type non-bonded --ia-name A-A convert_potential gromacs $1 new_table_A_A
