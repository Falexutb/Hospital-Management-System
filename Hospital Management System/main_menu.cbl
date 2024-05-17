      ******************************************************************
      * Author:
      * Date:
      * Purpose: Main Menu for Health Care System
      * Tectonics: cobc
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN-MENU.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-370.
       OBJECT-COMPUTER. IBM-370.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77  WS-EOF                   PIC X VALUE "N".
       77  USER-CHOICE              PIC 9.

       PROCEDURE DIVISION.
       0000-MAIN-PROCEDURE.
           PERFORM UNTIL WS-EOF = "Y"
               DISPLAY "Health Care System Main Menu"
               DISPLAY "1. Patient Records Management"
               DISPLAY "2. Appointment Scheduling"
               DISPLAY "3. Billing and Payments"
               DISPLAY "4. Access Control"
               DISPLAY "5. Exit"
               ACCEPT USER-CHOICE
               EVALUATE USER-CHOICE
                   WHEN 1
                       CALL 'SYSTEM' USING 'patient_records.exe'
                   WHEN 2
                       CALL 'SYSTEM' USING 'appointments.exe'
                   WHEN 3
                       CALL 'SYSTEM' USING 'billing.exe'
                   WHEN 4
                       CALL 'SYSTEM' USING 'access_control.exe'
                   WHEN 5
                       MOVE "Y" TO WS-EOF
                   WHEN OTHER
                       DISPLAY "Invalid choice"
               END-EVALUATE
           END-PERFORM
           STOP RUN.
