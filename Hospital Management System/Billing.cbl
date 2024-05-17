      ******************************************************************
      * Author:
      * Date:
      * Purpose: Billing and Payments Management
      * Tectonics: cobc
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. BILLING.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT BILLING-FILE ASSIGN TO "/data\billing.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TEMP-FILE ASSIGN TO "/data\temp.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  BILLING-FILE.
       01  BILLING-RECORD.
           05  BILLING-ID            PIC 9(8).
           05  PATIENT-ID            PIC 9(8).
           05  AMOUNT                PIC 9(8)V99.
           05  BILLING-DATE          PIC X(10).

       FD  TEMP-FILE.
       01  TEMP-BILLING-RECORD.
           05  TEMP-BILLING-ID       PIC 9(8).
           05  TEMP-PATIENT-ID       PIC 9(8).
           05  TEMP-AMOUNT           PIC 9(8)V99.
           05  TEMP-BILLING-DATE     PIC X(10).

       WORKING-STORAGE SECTION.
       77  WS-EOF                   PIC X VALUE "N".
       77  USER-CHOICE              PIC 9.
       77  WS-BILLING-ID            PIC 9(8).
       77  WS-PATIENT-ID            PIC 9(8).
       77  WS-AMOUNT                PIC 9(8)V99.
       77  WS-BILLING-DATE          PIC X(10).
       77  WS-TOTAL-AMOUNT          PIC 9(12)V99 VALUE 0.
       77  WS-RECORD-COUNT          PIC 9(8) VALUE 0.

       PROCEDURE DIVISION.
       0000-MAIN-PROCEDURE.
           PERFORM UNTIL WS-EOF = "Y"
               DISPLAY "Billing and Payments Management"
               DISPLAY "1. Create Billing Record"
               DISPLAY "2. Read Billing Records"
               DISPLAY "3. Update Billing Record"
               DISPLAY "4. Delete Billing Record"
               DISPLAY "5. Generate Report"
               DISPLAY "6. Exit"
               ACCEPT USER-CHOICE
               EVALUATE USER-CHOICE
                   WHEN 1
                       PERFORM CREATE-BILLING-RECORD
                   WHEN 2
                       PERFORM READ-BILLING-RECORDS
                   WHEN 3
                       PERFORM UPDATE-BILLING-RECORD
                   WHEN 4
                       PERFORM DELETE-BILLING-RECORD
                   WHEN 5
                       PERFORM GENERATE-REPORT
                   WHEN 6
                       MOVE "Y" TO WS-EOF
                   WHEN OTHER
                       DISPLAY "Invalid choice"
               END-EVALUATE
           END-PERFORM
           STOP RUN.

       CREATE-BILLING-RECORD.
           OPEN OUTPUT BILLING-FILE
           DISPLAY "Enter Billing ID: "
           ACCEPT WS-BILLING-ID
           DISPLAY "Enter Patient ID: "
           ACCEPT WS-PATIENT-ID
           DISPLAY "Enter Amount: "
           ACCEPT WS-AMOUNT
           DISPLAY "Enter Billing Date (YYYY-MM-DD): "
           ACCEPT WS-BILLING-DATE
           MOVE WS-BILLING-ID TO BILLING-ID
           MOVE WS-PATIENT-ID TO PATIENT-ID
           MOVE WS-AMOUNT TO AMOUNT
           MOVE WS-BILLING-DATE TO BILLING-DATE
           WRITE BILLING-RECORD
           CLOSE BILLING-FILE
           DISPLAY "Billing Record Created Successfully"
           .

       READ-BILLING-RECORDS.
           OPEN INPUT BILLING-FILE
           PERFORM UNTIL WS-EOF = "Y"
               READ BILLING-FILE INTO BILLING-RECORD
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       DISPLAY "Billing ID: " BILLING-ID
                       DISPLAY "Patient ID: " PATIENT-ID
                       DISPLAY "Amount: " AMOUNT
                       DISPLAY "Billing Date: " BILLING-DATE
               END-READ
           END-PERFORM
           CLOSE BILLING-FILE
           MOVE "N" TO WS-EOF
           .

       UPDATE-BILLING-RECORD.
           OPEN I-O BILLING-FILE
           DISPLAY "Enter Billing ID to Update: "
           ACCEPT WS-BILLING-ID
           PERFORM UNTIL WS-EOF = "Y"
               READ BILLING-FILE INTO BILLING-RECORD
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       IF BILLING-ID = WS-BILLING-ID
                           DISPLAY "Enter New Patient ID: "
                           ACCEPT WS-PATIENT-ID
                           DISPLAY "Enter New Amount: "
                           ACCEPT WS-AMOUNT
                           DISPLAY "Enter New Billing Date - "
                                   "(YYYY-MM-DD):"
                           ACCEPT WS-BILLING-DATE
                           MOVE WS-PATIENT-ID TO PATIENT-ID
                           MOVE WS-AMOUNT TO AMOUNT
                           MOVE WS-BILLING-DATE TO BILLING-DATE
                           REWRITE BILLING-RECORD
                           DISPLAY "Billing Record Updated Successfully"
                           MOVE "Y" TO WS-EOF
                       END-IF
               END-READ
           END-PERFORM
           CLOSE BILLING-FILE
           MOVE "N" TO WS-EOF
           .

       DELETE-BILLING-RECORD.
           OPEN I-O BILLING-FILE
           OPEN OUTPUT TEMP-FILE
           DISPLAY "Enter Billing ID to Delete: "
           ACCEPT WS-BILLING-ID
           PERFORM UNTIL WS-EOF = "Y"
               READ BILLING-FILE INTO BILLING-RECORD
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       IF BILLING-ID NOT = WS-BILLING-ID
                           MOVE BILLING-RECORD TO TEMP-BILLING-RECORD
                           WRITE TEMP-BILLING-RECORD
                       END-IF
               END-READ
           END-PERFORM
           CLOSE BILLING-FILE
           CLOSE TEMP-FILE

           OPEN INPUT TEMP-FILE
           OPEN OUTPUT BILLING-FILE
           MOVE "N" TO WS-EOF
           PERFORM UNTIL WS-EOF = "Y"
               READ TEMP-FILE INTO TEMP-BILLING-RECORD
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       MOVE TEMP-BILLING-RECORD TO BILLING-RECORD
                       WRITE BILLING-RECORD
               END-READ
           END-PERFORM
           CLOSE TEMP-FILE
           CLOSE BILLING-FILE
           DISPLAY "Billing Record Deleted Successfully"
           MOVE "N" TO WS-EOF
           .

       GENERATE-REPORT.
           OPEN INPUT BILLING-FILE
           MOVE 0 TO WS-TOTAL-AMOUNT
           MOVE 0 TO WS-RECORD-COUNT
           PERFORM UNTIL WS-EOF = "Y"
               READ BILLING-FILE INTO BILLING-RECORD
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       ADD 1 TO WS-RECORD-COUNT
                       ADD AMOUNT TO WS-TOTAL-AMOUNT
               END-READ
           END-PERFORM
           CLOSE BILLING-FILE
           MOVE "N" TO WS-EOF
           DISPLAY "Total Number of Billing Records: " WS-RECORD-COUNT
           DISPLAY "Total Billing Amount: " WS-TOTAL-AMOUNT
           .
       END PROGRAM BILLING.
