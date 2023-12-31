//FINAL01J JOB ' ',CLASS=A,MSGLEVEL=(1,1),
//          MSGCLASS=X,NOTIFY=Z95619
//DELET100 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE Z95619.QSAM.PCS
  DELETE Z95619.QSAM.QQ
  DELETE Z95619.QSAM.WW
//SORT0200 EXEC PGM=SORT
//SYSOUT   DD SYSOUT=*
//SORTIN   DD *
12803949A N N IE       EDISON         19901219
14302840TROY           BARNES         19891204
11704978GEORGE         CARLIN         19370512
19601949ABED           NADIR          19890324
15801840M E H M E T    AYDIN          19740918
13567949ROBERT         OPPENHEIMER    19040322
18738978D E NI S       VILLENEUVE     19671003
14325840STEVE          CARELL         19620816
10032840R UF U S       SEWELL         19671029
10042978CARY-HIROYUKI  TAGAWA         19500927
10046949HARRISON       FORD           19420713
10095840T O M          CRUISE         19620703
10045949JENNIFER       LAWRENCE       19900815
10070978CHRISTOPHER    NOLAN          19700730
10054444Y U N US       TEMUR          19960101
10459840I D R I S      ELBA           19720906
15078965MADS           MIKKELSEN      19651122
15687940CHRISTIAN      BALE           19740130
15969480A NT HON Y     HOPKINS        19371231
10209788MARGOT         ROBBIE         19900702
//SORTOUT DD DSN=Z95619.QSAM.QQ,
//           DISP=(NEW,CATLG,DELETE),
//           SPACE=(TRK,(5,5),RLSE),
//           DCB=(RECFM=FB,LRECL=60)
//SYSIN    DD *
  SORT FIELDS=(1,7,CH,A)
  OUTREC FIELDS=(1,38,39,8,Y4T,TOJUL=Y4T,15C'0')
//*
//SORT0300 EXEC PGM=SORT
//SYSOUT   DD SYSOUT=*
//SORTIN   DD DSN=Z95619.QSAM.QQ,DISP=SHR
//SORTOUT  DD DSN=Z95619.QSAM.WW,
//            DISP=(NEW,CATLG,DELETE),
//            SPACE=(TRK,(5,5),RLSE),
//            DCB=(RECFM=FB,LRECL=47)
//SYSIN     DD *
  SORT FIELDS=COPY
  OUTREC FIELDS=(1,5,ZD,TO=PD,LENGTH=3,
                 6,3,ZD,TO=BI,LENGTH=2,
                 9,30,
                 39,7,ZD,TO=PD,LENGTH=4,
                 46,15,ZD,TO=PD,LENGTH=8)
//DELET400 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN DD *
  DELETE Z95619.VSAM.II CLUSTER PURGE
  IF LASTCC LE 08 THEN SET MAXCC = 00
    DEF CL ( NAME(Z95619.VSAM.II)     -
             FREESPACE( 20 20 )       -
             SHR( 2,3 )               -
             KEYS(5 0)                -
             INDEXED SPEED            -
             RECSZ(47 47)             -
             TRK (10 10)              -
             VOLUME(VPWRKB)           -
             LOG(NONE)                -
             UNIQUE )                 -
    DATA ( NAME(Z95619.VSAM.II.DATA)) -
    INDEX ( NAME(Z95619.VSAM.II.INDEX))
//REPRO500 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//INN001 DD DSN=Z95619.QSAM.WW,DISP=SHR
//OUT001 DD DSN=Z95619.VSAM.II,DISP=SHR
//SYSIN DD *
  REPRO INFILE(INN001) OUTFILE(OUT001)
//SORT0600 EXEC PGM=SORT
//SYSOUT   DD SYSOUT=*
//SORTIN   DD *
R19601949
R13567949
R34343434
H53456578
W42424242
W14325840
U15801840
U18738978
U12803949
U13548964
D14302840
D12345678
R10046949
J32432423
E43543534
U10032840
U10095840
R10042978
U10005840
W10095840
D10045949
D43567768
U10054444
D54767687
P10045940
R11704978
W10045949
Q54386546
W54390570
R10070978
U10459840
U15078965
U15969480
W98743949
E87435789
W10009788
//SORTOUT DD DSN=Z95619.QSAM.PCS,
//           DISP=(NEW,CATLG,DELETE),
//           SPACE=(TRK,(5,5),RLSE),
//           DCB=(RECFM=FB,LRECL=9)
//SYSIN    DD *
  SORT FIELDS=COPY
