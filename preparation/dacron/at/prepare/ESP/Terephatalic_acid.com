%mem=2gb
%NProcShared=2
#n B3LYP/6-31G(d) Opt Pop=ESP scf=(direct,tight)

 Terphatalic_acid

0 1
O  
C   1 B1
O   2 B2 1 A2
C   2 B3 1 A3 3 D3
C   4 B4 2 A4 1 D4
C   5 B5 4 A5 2 D5
C   6 B6 5 A6 4 D6
C   7 B7 6 A7 5 D7
C   4 B8 2 A8 1 D8
C   7 B9 6 A9 5 D9
O   10 B10 7 A10 6 D10
O   10 B11 7 A11 6 D11
H   5 B12 4 A12 2 D12
H   6 B13 5 A13 4 D13
H   8 B14 7 A14 6 D14
H   9 B15 4 A15 2 D15
H   1 B16 2 A16 3 D16
H   12 B17 10 A17 7 D17
Variables:
B1        1.34454
B2        1.21644
A2      121.39275
B3        1.48325
A3      112.71432
D3      180.02562
B4        1.39714
A4      118.44324
D4      179.97438
B5        1.39891
A5      120.07506
D5      180.02562
B6        1.40558
A6      121.01884
D6        0.02562
B7        1.40226
A7      118.63000
D7        0.02562
B8        1.39987
A8      122.18601
D8        0.02562
B9        1.49592
A9      116.76161
D9      179.97438
B10        1.22137
A10      121.84710
D10      359.97438
B11        1.34719
A11      116.72278
D11      179.97438
B12        1.08897
A12      120.44064
D12        0.02562
B13        1.09029
A13      118.80768
D13      179.97438
B14        1.08362
A14      122.87574
D14      179.97438
B15        1.08855
A15      120.32025
D15      359.97438
B16        0.98088
A16      103.76723
D16      359.97438
B17        0.96906
A17      118.10710
D17      359.97438
