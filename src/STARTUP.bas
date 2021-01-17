10 PRINT CHR$(4) "BLOAD DUMPROM"
20 PRINT "Laser 128 ROM Dumper Tool"
30 PRINT
40 PRINT "For new model, make sure slot 5 and 7"
50 PRINT "are set to INTERNAL!"
60 PRINT
70 PRINT "Choose model:"
80 PRINT " (1) Old model, black on silver badge"
90 PRINT " (2) New model, LASER in red"
100 PRINT " (Q) Quit"
110 PRINT
120 PRINT "Enter choice: ";
130 GET C$
140 IF C$ = "1" THEN PRINT C$: PRINT: GOTO 1000
150 IF C$ = "2" THEN PRINT C$: PRINT: GOTO 2000
160 IF C$ = "Q" OR C$ = "q" THEN PRINT C$: PRINT: END
170 GOTO 130
1000 PRINT "Make sure switch is set to PARALLEL"
1010 PRINT "and press any key: ";
1020 GET C$
1030 PRINT: PRINT
1040 PRINT "Dumping $0000-$1FFF"
1050 CALL 16384+12
1060 PRINT CHR$(4) "BSAVE ROM0000,A$2000,L$2000"
1070 PRINT "Dumping $2000-$3FFF"
1080 CALL 16384+15
1090 PRINT CHR$(4) "BSAVE ROM2000,A$2000,L$2000"
1100 PRINT "Dumping $4000-$5FFF"
1110 CALL 16384+18
1120 PRINT
1130 PRINT "Make sure switch is set to SERIAL"
1140 PRINT "and press any key: ";
1150 GET C$
1160 PRINT: PRINT
1170 CALL 16384+21
1180 PRINT CHR$(4) "BSAVE ROM4000,A$2000,L$2000"
1190 PRINT "Dumping $6000-$7FFF"
1200 CALL 16384+24
1210 PRINT CHR$(4) "BSAVE ROM6000,A$2000,L$2000"
1220 END
2000 PRINT "Make sure switch is set to PARALLEL"
2010 PRINT "and press any key: ";
2020 GET C$
2030 PRINT: PRINT
2040 PRINT "Dumping $0000-$1FFF"
2050 CALL 16384
2060 PRINT CHR$(4) "BSAVE ROM0000,A$2000,L$2000"
2070 PRINT "Dumping $2000-$3FFF"
2080 CALL 16384+3
2090 PRINT CHR$(4) "BSAVE ROM2000,A$2000,L$2000"
2100 PRINT "Dumping $4000-$5FFF"
2110 CALL 16384+6
2120 PRINT CHR$(4) "BSAVE ROM4000,A$2000,L$2000"
2130 PRINT "Dumping $6000-$7FFF"
2140 CALL 16384+9
2150 PRINT CHR$(4) "BSAVE ROM6000,A$2000,L$2000"
2160 END
