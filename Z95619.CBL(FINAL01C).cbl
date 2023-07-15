       IDENTIFICATION DIVISION.
       PROGRAM-ID. FINAL01C.
       AUTHOR. Tolga Kayis.
      *-----------------------------------------------------------------
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT OUTPUT-FILE   ASSIGN TO OUTPFILE
                                STATUS ST-OUTPUT-FILE.
           SELECT INPUT-FILE    ASSIGN TO INPFILE
                                STATUS ST-INPUT-FILE.
           SELECT INVALID-FILE  ASSIGN TO INVFILE
                                STATUS ST-INVALID-FILE.
      *This is where we declare input and output files.
      *INVFILE contains the invalid processes.
      *My INPUT file is the processes and keys that I have to match with
      *Also their variables to hold their status information. e.g. 00,97
      *-----------------------------------------------------------------
       DATA DIVISION.
       FILE SECTION.
       FD  OUTPUT-FILE RECORDING MODE F.
       01  OUT-REC.
           03 OREC-PROCESS-TYPE    PIC X(01).
           03 FILLER               PIC X(01) VALUE SPACES.
           03 OREC-ID              PIC 9(05).
           03 FILLER               PIC X(01) VALUE SPACES.
           03 OREC-CURRENCY        PIC 9(03).
           03 FILLER               PIC X(02) VALUE SPACES.
           03 OREC-RETURN-CODE     PIC 9(02).
           03 FILLER               PIC X(02) VALUE SPACES.
           03 OREC-DATA.
              05 OREC-EXPLANATION  PIC X(30).
              05 OREC-FROM-FNAME   PIC X(15).
              05 OREC-FROM-LNAME   PIC X(15).
              05 OREC-TO-FNAME     PIC X(15).
              05 OREC-TO-LNAME     PIC X(15).
      *
       FD  INVALID-FILE RECORDING MODE F.
       01  INV-REC.
           03 INVREC-PROCTP        PIC X(01).
           03 FILLER               PIC X(02) VALUE SPACES.
           03 INVREC-ID            PIC 9(05).
           03 FILLER               PIC X(02) VALUE SPACES.
           03 INVREC-CURRENCY      PIC 9(03).
           03 FILLER               PIC X(11) VALUE SPACES.
      *
       FD  INPUT-FILE RECORDING MODE F.
       01  IN-REC.
           03 IREC-PROCESS-TYPE    PIC X(01).
           03 IREC-ID              PIC X(05).
           03 IREC-CURRENCY        PIC X(03).

      *--------------------------------------
       WORKING-STORAGE SECTION.
       01  WS-WORKSHOP.
           03 WS-PBEGIDX           PIC X(08) VALUE 'PBEGIDX'.
           03 ST-INPUT-FILE        PIC 9(02).
              88 INPFILE-EOF                 VALUE 10.
              88 INPFILE-SUCCESS             VALUE 00 97.
           03 ST-OUTPUT-FILE       PIC 9(02).
              88 OUTPFILE-SUCCESS            VALUE 00 97.
           03 ST-INVALID-FILE      PIC 9(02).
              88 INVFILE-SUCCESS             VALUE 00 97.
           03 WS-PROCESS-TYPE      PIC 9(01).
              88 WS-PROCESS-TYPE-VALID VALUE 1 THRU 9.
      *--------------------------------------
       01  HEADER-1.
           03 FILLER         PIC X(23) VALUE 'FINAL ASSIGNMENT'.
           03 FILLER         PIC X(19) VALUE SPACES.
           03 FILLER         PIC X(19) VALUE 'Author: TOLGA KAYIS'.
           03 FILLER         PIC X(19) VALUE SPACES.
      *
       01  HEADER-2.
           03 FILLER         PIC X(05) VALUE 'Year '.
           03 HDR-YR         PIC 9(04).
           03 FILLER         PIC X(02) VALUE SPACES.
           03 FILLER         PIC X(06) VALUE 'Month '.
           03 HDR-MO         PIC X(02).
           03 FILLER         PIC X(02) VALUE SPACES.
           03 FILLER         PIC X(04) VALUE 'Day '.
           03 HDR-DAY        PIC X(02).
           03 FILLER         PIC X(56) VALUE SPACES.
      *
       01  HEADER-3.
           03 FILLER         PIC X(11) VALUE 'PROCTYP-KEY'.
           03 FILLER         PIC X(02) VALUE SPACES.
           03 FILLER         PIC X(02) VALUE 'RC'.
           03 FILLER         PIC X(02) VALUE SPACES.
           03 FILLER         PIC X(07) VALUE 'Outcome'.
           03 FILLER         PIC X(23) VALUE SPACES.
           03 FILLER         PIC X(23) VALUE 'From First and Lastname'.
           03 FILLER         PIC X(07) VALUE SPACES.
           03 FILLER         PIC X(21) VALUE 'To First and Lastname'.
           03 FILLER         PIC X(09) VALUE SPACES.
      *
       01  HEADER-4.
           03 FILLER         PIC X(11) VALUE '-----------'.
           03 FILLER         PIC X(02) VALUE SPACES.
           03 FILLER         PIC X(02) VALUE '--'.
           03 FILLER         PIC X(02) VALUE SPACES.
           03 FILLER         PIC X(24) VALUE '------------------------'.
           03 FILLER         PIC X(06) VALUE SPACES.
           03 FILLER         PIC X(24) VALUE '------------------------'.
           03 FILLER         PIC X(06) VALUE SPACES.
           03 FILLER         PIC X(24) VALUE '------------------------'.
           03 FILLER         PIC X(06) VALUE SPACES.
      *
       01  HEADER-5.
           03 INV-HEADER     PIC X(24) VALUE 'INVALID PROCESS TYPE-KEY'.
           03 INV-LINE       PIC X(13) VALUE '-------------'.
      *
       01 WS-CURRENT-DATE-DATA.
           03 WS-CURRENT-DATE.
              05 WS-CURRENT-YEAR         PIC 9(04).
              05 WS-CURRENT-MONTH        PIC 9(02).
              05 WS-CURRENT-DAY          PIC 9(02).
      *My quality of life fillers and the supporting variables
      *--------------------------------------
       01 WS-SUB-AREA.
           03 WS-SUB-FUNCTION      PIC 9(01).
              88 WS-FUNC-OPEN                VALUE 1.
              88 WS-FUNC-READ                VALUE 2.
              88 WS-FUNC-UPDATE              VALUE 3.
              88 WS-FUNC-WRITE               VALUE 4.
              88 WS-FUNC-DELETE              VALUE 5.
              88 WS-FUNC-CLOSE               VALUE 9.
           03 WS-SUB-ID            PIC 9(05).
           03 WS-SUB-CUR           PIC 9(03).
           03 WS-SUB-RC            PIC 9(02).
           03 WS-SUBDATA.
              05 WS-EXPLANATION    PIC X(30).
              05 WS-FROM-FNAME     PIC X(15).
              05 WS-FROM-LNAME     PIC X(15).
              05 WS-TO-FNAME       PIC X(15).
              05 WS-TO-LNAME       PIC X(15).
      *Subprogram linkage section
      *-----------------------------------------------------------------
       PROCEDURE DIVISION.
       0000-MAIN.
           PERFORM H100-OPEN-FILES
           PERFORM H150-WRITE-HEADERS
           PERFORM H200-PROCESS UNTIL INPFILE-EOF
           PERFORM H999-PREPARE-EXIT.
       0000-END. EXIT.
      *
       H100-OPEN-FILES.
           OPEN INPUT INPUT-FILE
           IF NOT INPFILE-SUCCESS
              DISPLAY 'INPFILE DID NOT OPEN PROPERLY: ' ST-INPUT-FILE
              MOVE ST-INPUT-FILE TO RETURN-CODE
              PERFORM H999-PREPARE-EXIT
           END-IF
           OPEN OUTPUT OUTPUT-FILE
           IF NOT OUTPFILE-SUCCESS
              DISPLAY 'OUTPFILE DID NOT OPEN PROPERLY: ' ST-OUTPUT-FILE
              MOVE ST-OUTPUT-FILE TO RETURN-CODE
              PERFORM H999-PREPARE-EXIT
           END-IF
           OPEN OUTPUT INVALID-FILE.
           IF NOT INVFILE-SUCCESS
              DISPLAY 'INVFILE DID NOT OPEN PROPERLY: ' ST-INVALID-FILE
              MOVE ST-INVALID-FILE TO RETURN-CODE
              PERFORM H999-PREPARE-EXIT
           END-IF
           READ INPUT-FILE.
           SET WS-FUNC-OPEN TO TRUE
           CALL WS-PBEGIDX USING WS-SUB-AREA.
       H100-END. EXIT.
      *
       H150-WRITE-HEADERS.
           MOVE FUNCTION CURRENT-DATE TO WS-CURRENT-DATE-DATA.
           MOVE WS-CURRENT-YEAR  TO HDR-YR.
           MOVE WS-CURRENT-MONTH TO HDR-MO.
           MOVE WS-CURRENT-DAY   TO HDR-DAY.
           WRITE OUT-REC FROM HEADER-1.
           WRITE OUT-REC FROM HEADER-2.
           MOVE SPACES TO OUT-REC.
           WRITE OUT-REC AFTER ADVANCING 1 LINES.
           WRITE OUT-REC FROM HEADER-3.
           WRITE OUT-REC FROM HEADER-4.
           MOVE SPACES TO OUT-REC.
           WRITE INV-REC FROM HEADER-5.
           WRITE INV-REC FROM INV-LINE.
       H150-END. EXIT.
      *
       H200-PROCESS.
           MOVE SPACES TO WS-SUB-AREA
           IF IREC-PROCESS-TYPE = 'R'
              MOVE 2 TO WS-PROCESS-TYPE
           ELSE IF IREC-PROCESS-TYPE = 'U'
              MOVE 3 TO WS-PROCESS-TYPE
           ELSE IF IREC-PROCESS-TYPE = 'W'
              MOVE 4 TO WS-PROCESS-TYPE
           ELSE IF IREC-PROCESS-TYPE = 'D'
              MOVE 5 TO WS-PROCESS-TYPE
           ELSE
              MOVE 0 TO WS-PROCESS-TYPE
           END-IF.
           IF WS-PROCESS-TYPE-VALID
              EVALUATE WS-PROCESS-TYPE
                 WHEN 2
                    SET WS-FUNC-READ TO TRUE
                 WHEN 3
                    SET WS-FUNC-UPDATE TO TRUE
                 WHEN 4
                    SET WS-FUNC-WRITE TO TRUE
                 WHEN 5
                    SET WS-FUNC-DELETE TO TRUE
              END-EVALUATE
              MOVE IREC-ID       TO WS-SUB-ID
              MOVE IREC-CURRENCY TO WS-SUB-CUR
              CALL WS-PBEGIDX USING WS-SUB-AREA
              PERFORM H300-WRITE-OUT
           ELSE
              MOVE SPACES TO INV-REC
              MOVE IREC-PROCESS-TYPE TO INVREC-PROCTP
              MOVE IREC-ID TO INVREC-ID
              MOVE IREC-CURRENCY TO INVREC-CURRENCY
              WRITE INV-REC
           END-IF.
           READ INPUT-FILE.
       H200-END. EXIT.
      *
       H300-WRITE-OUT.
           MOVE SPACES TO OUT-REC
           MOVE IREC-PROCESS-TYPE TO OREC-PROCESS-TYPE
           MOVE WS-SUB-ID         TO OREC-ID
           MOVE WS-SUB-CUR        TO OREC-CURRENCY
           MOVE WS-SUB-RC         TO OREC-RETURN-CODE
           MOVE WS-SUBDATA        TO OREC-DATA
           WRITE OUT-REC.
       H300-END. EXIT.
      *
       H999-PREPARE-EXIT.
           CLOSE OUTPUT-FILE
           CLOSE INPUT-FILE
           SET WS-FUNC-CLOSE TO TRUE
           CALL WS-PBEGIDX USING WS-SUB-AREA
           STOP RUN.
       H999-END. EXIT.
      *-----------------------------------------------------------------
