       IDENTIFICATION DIVISION.
       PROGRAM-ID. PBEGIDX.
       AUTHOR. TOLGA KAYIS.
      *-----------------------------------------------------------------
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INDEX-FILE    ASSIGN TO IDXFILE
                                ORGANIZATION IS INDEXED
                                ACCESS RANDOM
                                RECORD KEY IDX-KEY
                                STATUS ST-INDEX-FILE.
      *My INDEX file is the VSAM.II. (All the data I need to compare)
      *-----------------------------------------------------------------
       DATA DIVISION.
       FILE SECTION.
       FD  INDEX-FILE.
       01  IDX-REC.
           03 IDX-KEY.
              05 IDX-ID              PIC S9(05) COMP-3.
              05 IDX-CURRENCY        PIC S9(03) COMP.
           03 IDX-FNAME              PIC X(15).
           03 IDX-LNAME              PIC X(15).
           03 IDX-BDAY               PIC S9(07) COMP-3.
           03 IDX-BALANCE            PIC S9(15) COMP-3.
      *----------------------------------------
       WORKING-STORAGE SECTION.
       01  WS-WORKSHOP.
           03 ST-INDEX-FILE          PIC 9(02).
              88 IDXFILE-SUCCESS               VALUE 00 97.
           03 COUNTER-VARIABLES.
              05 X-INC               PIC 9(02).
              05 Y-INC               PIC 9(02).
           03 NEW-REC.
              05 NEW-FNAME           PIC X(15).
              05 NEW-LNAME           PIC X(15).
      *----------------------------------------
       LINKAGE SECTION.
       01  WS-SUB-AREA.
           03 WS-SUB-FUNCTION        PIC 9(01).
              88 WS-FUNC-OPEN                  VALUE 1.
              88 WS-FUNC-READ                  VALUE 2.
              88 WS-FUNC-UPDATE                VALUE 3.
              88 WS-FUNC-WRITE                 VALUE 4.
              88 WS-FUNC-DELETE                VALUE 5.
              88 WS-FUNC-CLOSE                 VALUE 9.
           03 WS-SUB-ID              PIC 9(05).
           03 WS-SUB-CUR             PIC 9(03).
           03 WS-SUB-RC              PIC 9(02).
           03 WS-SUBDATA.
              05 WS-EXPLANATION      PIC X(30).
              05 WS-FROM-FNAME       PIC X(15).
              05 WS-FROM-LNAME       PIC X(15).
              05 WS-TO-FNAME         PIC X(15).
              05 WS-TO-LNAME         PIC X(15).
      *-----------------------------------------------------------------
       PROCEDURE DIVISION USING WS-SUB-AREA.
       0000-MAIN.
           EVALUATE TRUE
              WHEN WS-FUNC-OPEN
                 PERFORM H100-OPEN-FILE
                 GOBACK
              WHEN WS-FUNC-CLOSE
                 PERFORM H999-PREPARE-EXIT
              WHEN OTHER
                 PERFORM H200-READ-FILE
                 GOBACK
           END-EVALUATE.
       0000-END. EXIT.
      *
       H100-OPEN-FILE.
           OPEN I-O INDEX-FILE
           IF NOT IDXFILE-SUCCESS
              DISPLAY 'IDXFILE DID NOT OPEN PROPERLY: ' ST-INDEX-FILE
              MOVE ST-INDEX-FILE TO RETURN-CODE
              PERFORM H999-PREPARE-EXIT
           END-IF.
       H100-END. EXIT.
      *
       H200-READ-FILE.
           MOVE WS-SUB-ID TO IDX-ID
           MOVE WS-SUB-CUR TO IDX-CURRENCY
           READ INDEX-FILE KEY IS IDX-KEY
           INVALID KEY PERFORM H300-INVALID-KEY
           NOT INVALID KEY PERFORM H250-VALID-KEY.
       H200-END. EXIT.
      *
       H250-VALID-KEY.
           IF WS-SUB-FUNCTION = 2
              PERFORM H400-READ
           ELSE IF WS-SUB-FUNCTION = 3
              PERFORM H500-UPDATE-NAMES
           ELSE IF WS-SUB-FUNCTION = 4
              PERFORM H700-WRITE
           ELSE IF WS-SUB-FUNCTION = 5
              PERFORM H800-DELETE
           END-IF.
       H150-END. EXIT.
      *
       H300-INVALID-KEY.
           IF WS-SUB-FUNCTION = 2
              PERFORM H400-READ
           ELSE IF WS-SUB-FUNCTION = 3
              PERFORM H500-UPDATE-NAMES
           ELSE IF WS-SUB-FUNCTION = 4
              PERFORM H700-WRITE
           ELSE IF WS-SUB-FUNCTION = 5
              PERFORM H800-DELETE
           END-IF.
       H300-END. EXIT.
      *
       H400-READ.
           MOVE SPACES TO WS-SUBDATA
           IF ST-INDEX-FILE NOT = 0
              STRING 'RECORD NOT FOUND'
                    DELIMITED BY SIZE INTO WS-EXPLANATION
              END-STRING
              MOVE ST-INDEX-FILE TO WS-SUB-RC
           ELSE
              STRING 'READ SUCCESSFUL'
                 DELIMITED BY SIZE INTO WS-EXPLANATION
              END-STRING
              MOVE IDX-FNAME TO WS-FROM-FNAME
              MOVE IDX-LNAME TO WS-FROM-LNAME
              MOVE ST-INDEX-FILE TO WS-SUB-RC
           END-IF.
       H400-END. EXIT.
      *
       H500-UPDATE-NAMES.
           MOVE SPACES TO WS-SUBDATA
           IF ST-INDEX-FILE NOT = 0
              STRING 'RECORD NOT FOUND'
                 DELIMITED BY SIZE INTO WS-EXPLANATION
              END-STRING
              MOVE ST-INDEX-FILE TO WS-SUB-RC
           ELSE
              MOVE SPACES TO NEW-REC
              MOVE IDX-FNAME TO WS-FROM-FNAME
              MOVE IDX-LNAME TO WS-FROM-LNAME
              MOVE IDX-LNAME TO NEW-LNAME
              MOVE 01 TO X-INC
              MOVE 01 TO Y-INC
              PERFORM VARYING X-INC FROM 1 BY 1
                 UNTIL X-INC > LENGTH OF WS-FROM-FNAME
                 IF WS-FROM-FNAME(X-INC:1) = SPACE
                    CONTINUE
                 ELSE
                    MOVE WS-FROM-FNAME(X-INC:1) TO NEW-FNAME(Y-INC:1)
                    ADD 1 TO Y-INC
                 END-IF
              END-PERFORM
              INSPECT NEW-LNAME REPLACING ALL 'E' BY 'I'
              INSPECT NEW-LNAME REPLACING ALL 'A' BY 'E'
              STRING 'RECORD UPDATED'
                 DELIMITED BY SIZE INTO WS-EXPLANATION
              END-STRING
              MOVE ST-INDEX-FILE TO WS-SUB-RC
              MOVE NEW-FNAME TO WS-TO-FNAME
              MOVE NEW-FNAME TO IDX-FNAME
              MOVE NEW-LNAME TO WS-TO-LNAME
              MOVE NEW-LNAME TO IDX-LNAME
              REWRITE IDX-REC END-REWRITE
           END-IF.
       H500-END. EXIT.
      *
      *
       H700-WRITE.
           MOVE SPACES TO WS-SUBDATA
           IF ST-INDEX-FILE NOT = 0
              STRING 'NEW RECORD WRITTEN'
                 DELIMITED BY SIZE INTO WS-EXPLANATION
              END-STRING
              MOVE 'TOLGA' TO IDX-FNAME
              MOVE 'TOLGA' TO WS-TO-FNAME
              MOVE 'KAYIS' TO IDX-LNAME
              MOVE 'KAYIS' TO WS-TO-LNAME
              MOVE 00      TO WS-SUB-RC
              WRITE IDX-REC END-WRITE
           ELSE
              STRING 'WRITE UNSUCCESSFUL RECFND'
                 DELIMITED BY SIZE INTO WS-EXPLANATION
              END-STRING
              MOVE 22 TO WS-SUB-RC
           END-IF.
       H700-END. EXIT.
      *
       H800-DELETE.
           MOVE SPACES TO WS-SUBDATA
           IF ST-INDEX-FILE NOT = 0
              STRING 'DELETE UNSUCCESSFUL RECNOTFND'
                 DELIMITED BY SIZE INTO WS-EXPLANATION
              END-STRING
              MOVE ST-INDEX-FILE TO WS-SUB-RC
           ELSE
              STRING 'DELETE SUCCESSFUL'
                 DELIMITED BY SIZE INTO WS-EXPLANATION
              END-STRING
              MOVE IDX-FNAME     TO WS-FROM-FNAME
              MOVE IDX-LNAME     TO WS-FROM-LNAME
              MOVE ST-INDEX-FILE TO WS-SUB-RC
              DELETE INDEX-FILE
           END-IF.
       H800-END. EXIT.
      *
       H999-PREPARE-EXIT.
           CLOSE INDEX-FILE
           GOBACK.
       H999-END. EXIT.
      *-----------------------------------------------------------------
