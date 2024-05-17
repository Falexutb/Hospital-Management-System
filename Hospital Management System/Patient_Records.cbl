       IDENTIFICATION DIVISION.
       PROGRAM-ID. PATIENT-RECORDS.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PATIENT-FILE ASSIGN TO "/data\patients.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TEMP-FILE ASSIGN TO "/data\temp.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  PATIENT-FILE.
       01  PATIENT-RECORD.
           05  PATIENT-ID           PIC 9(8).
           05  FIRST-NAME           PIC X(20).
           05  LAST-NAME            PIC X(30).
           05  STREET               PIC X(50).
           05  CITY                 PIC X(20).
           05  PHONE-NUMBER         PIC 9(10).
           05  COND                 PIC X(100).

       FD  TEMP-FILE.
       01  TEMP-RECORD.
           05  TEMP-PATIENT-ID      PIC 9(8).
           05  TEMP-FIRST-NAME      PIC X(20).
           05  TEMP-LAST-NAME       PIC X(30).
           05  TEMP-STREET          PIC X(50).
           05  TEMP-CITY            PIC X(20).
           05  TEMP-PHONE-NUMBER    PIC 9(10).
           05  TEMP-COND            PIC X(100).

       WORKING-STORAGE SECTION.
       77  WS-EOF                   PIC X VALUE "N".
       77  USER-CHOICE              PIC 9.
       77  WS-PATIENT-ID            PIC 9(8).
       77  WS-FIRST-NAME            PIC X(20).
       77  WS-LAST-NAME             PIC X(30).
       77  WS-STREET                PIC X(50).
       77  WS-CITY                  PIC X(20).
       77  WS-PHONE-NUMBER          PIC 9(10).
       77  WS-COND                  PIC X(100).
       77  WS-VALID                 PIC X VALUE "N".

       PROCEDURE DIVISION.
       0000-MAIN-PROCEDURE.
           PERFORM UNTIL WS-EOF = "Y"
               DISPLAY "Patient Records Management"
               DISPLAY "1. Create Record"
               DISPLAY "2. Read Records"
               DISPLAY "3. Update Record"
               DISPLAY "4. Delete Record"
               DISPLAY "5. Generate Report"
               DISPLAY "6. Exit"
               ACCEPT USER-CHOICE
               EVALUATE USER-CHOICE
                   WHEN 1
                       PERFORM CREATE-RECORD
                   WHEN 2
                       PERFORM READ-RECORDS
                   WHEN 3
                       PERFORM UPDATE-RECORD
                   WHEN 4
                       PERFORM DELETE-RECORD
                   WHEN 5
                       PERFORM GENERATE-REPORT
                   WHEN 6
                       MOVE "Y" TO WS-EOF
                   WHEN OTHER
                       DISPLAY "Invalid choice"
               END-EVALUATE
           END-PERFORM
           STOP RUN.

       CREATE-RECORD.
           OPEN OUTPUT PATIENT-FILE
           PERFORM GET-INPUT
           PERFORM VALIDATE-DATA
           IF WS-VALID = "Y"
               MOVE WS-PATIENT-ID TO PATIENT-ID
               MOVE WS-FIRST-NAME TO FIRST-NAME
               MOVE WS-LAST-NAME TO LAST-NAME
               MOVE WS-STREET TO STREET
               MOVE WS-CITY TO CITY
               MOVE WS-PHONE-NUMBER TO PHONE-NUMBER
               MOVE WS-COND TO COND
               WRITE PATIENT-RECORD
               DISPLAY "Record Created Successfully"
           ELSE
               DISPLAY "Record Creation Failed. Invalid data."
           END-IF
           CLOSE PATIENT-FILE
           .

       READ-RECORDS.
           OPEN INPUT PATIENT-FILE
           PERFORM UNTIL WS-EOF = "Y"
               READ PATIENT-FILE INTO PATIENT-RECORD
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       DISPLAY "ID: " PATIENT-ID
                       DISPLAY "Name: " FIRST-NAME " " LAST-NAME
                       DISPLAY "Address: " STREET ", " CITY
                       DISPLAY "Phone: " PHONE-NUMBER
                       DISPLAY "Conditions: " COND
               END-READ
           END-PERFORM
           CLOSE PATIENT-FILE
           MOVE "N" TO WS-EOF
           .

       UPDATE-RECORD.
           OPEN I-O PATIENT-FILE
           DISPLAY "Enter Patient ID to Update: "
           ACCEPT WS-PATIENT-ID
           PERFORM UNTIL WS-EOF = "Y"
               READ PATIENT-FILE INTO PATIENT-RECORD
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       IF PATIENT-ID = WS-PATIENT-ID
                           PERFORM GET-INPUT
                           PERFORM VALIDATE-DATA
                           IF WS-VALID = "Y"
                               MOVE WS-FIRST-NAME TO FIRST-NAME
                               MOVE WS-LAST-NAME TO LAST-NAME
                               MOVE WS-STREET TO STREET
                               MOVE WS-CITY TO CITY
                               MOVE WS-PHONE-NUMBER TO PHONE-NUMBER
                               MOVE WS-COND TO COND
                               REWRITE PATIENT-RECORD
                               DISPLAY "Record Updated Successfully"
                           ELSE
                               DISPLAY "Record Update Failed. - "
                                       "Invalid data."
                           END-IF
                           MOVE "Y" TO WS-EOF
                       END-IF
               END-READ
           END-PERFORM
           CLOSE PATIENT-FILE
           MOVE "N" TO WS-EOF
           .

       DELETE-RECORD.
           OPEN I-O PATIENT-FILE
           OPEN OUTPUT TEMP-FILE
           DISPLAY "Enter Patient ID to Delete: "
           ACCEPT WS-PATIENT-ID
           PERFORM UNTIL WS-EOF = "Y"
               READ PATIENT-FILE INTO PATIENT-RECORD
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       IF PATIENT-ID NOT = WS-PATIENT-ID
                           MOVE PATIENT-RECORD TO TEMP-RECORD
                           WRITE TEMP-RECORD
                       END-IF
               END-READ
           END-PERFORM
           CLOSE PATIENT-FILE
           CLOSE TEMP-FILE

           OPEN INPUT TEMP-FILE
           OPEN OUTPUT PATIENT-FILE
           MOVE "N" TO WS-EOF
           PERFORM UNTIL WS-EOF = "Y"
               READ TEMP-FILE INTO TEMP-RECORD
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       MOVE TEMP-RECORD TO PATIENT-RECORD
                       WRITE PATIENT-RECORD
               END-READ
           END-PERFORM
           CLOSE TEMP-FILE
           CLOSE PATIENT-FILE
           DISPLAY "Record Deleted Successfully"
           MOVE "N" TO WS-EOF
           .

       GET-INPUT.
           DISPLAY "Enter Patient ID: "
           ACCEPT WS-PATIENT-ID
           DISPLAY "Enter First Name: "
           ACCEPT WS-FIRST-NAME
           DISPLAY "Enter Last Name: "
           ACCEPT WS-LAST-NAME
           DISPLAY "Enter Street: "
           ACCEPT WS-STREET
           DISPLAY "Enter City: "
           ACCEPT WS-CITY
           DISPLAY "Enter Phone Number: "
           ACCEPT WS-PHONE-NUMBER
           DISPLAY "Enter Conditions: "
           ACCEPT WS-COND
           .

       VALIDATE-DATA.
           MOVE "Y" TO WS-VALID
           IF WS-PATIENT-ID IS NUMERIC AND WS-PATIENT-ID NOT = 0
               CONTINUE
           ELSE
               MOVE "N" TO WS-VALID
           END-IF
           IF WS-FIRST-NAME IS ALPHABETIC
               CONTINUE
           ELSE
               MOVE "N" TO WS-VALID
           END-IF
           IF WS-LAST-NAME IS ALPHABETIC
               CONTINUE
           ELSE
               MOVE "N" TO WS-VALID
           END-IF
           IF WS-PHONE-NUMBER IS NUMERIC
               IF LENGTH OF WS-PHONE-NUMBER = 10
                   CONTINUE
               ELSE
                   MOVE "N" TO WS-VALID
               END-IF
           ELSE
               MOVE "N" TO WS-VALID
           END-IF
           .

       GENERATE-REPORT.
           OPEN INPUT PATIENT-FILE
           DISPLAY "Patient Records Report"
           DISPLAY "======================="
           PERFORM UNTIL WS-EOF = "Y"
               READ PATIENT-FILE INTO PATIENT-RECORD
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       DISPLAY "ID: " PATIENT-ID
                       DISPLAY "Name: " FIRST-NAME " " LAST-NAME
                       DISPLAY "Address: " STREET ", " CITY
                       DISPLAY "Phone: " PHONE-NUMBER
                       DISPLAY "Conditions: " COND
                       DISPLAY "-----------------------"
               END-READ
           END-PERFORM
           CLOSE PATIENT-FILE
           MOVE "N" TO WS-EOF
           .
