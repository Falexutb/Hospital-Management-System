       IDENTIFICATION DIVISION.
       PROGRAM-ID. APPOINTMENTS.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT APPOINTMENT-FILE ASSIGN TO "/data\appoint.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TEMP-FILE ASSIGN TO "/data\temp.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  APPOINTMENT-FILE.
       01  APPOINTMENT-RECORD.
           05  APPOINTMENT-ID        PIC 9(8).
           05  PATIENT-ID            PIC 9(8).
           05  DOCTOR-ID             PIC 9(8).
           05  APPT-DATE             PIC X(10).
           05  APPT-TIME             PIC X(5).

       FD  TEMP-FILE.
       01  TEMP-APPOINTMENT-RECORD.
           05  TEMP-APPOINTMENT-ID   PIC 9(8).
           05  TEMP-PATIENT-ID       PIC 9(8).
           05  TEMP-DOCTOR-ID        PIC 9(8).
           05  TEMP-APPT-DATE        PIC X(10).
           05  TEMP-APPT-TIME        PIC X(5).

       WORKING-STORAGE SECTION.
       77  WS-EOF                   PIC X VALUE "N".
       77  USER-CHOICE              PIC 9.
       77  WS-APPOINTMENT-ID        PIC 9(8).
       77  WS-PATIENT-ID            PIC 9(8).
       77  WS-DOCTOR-ID             PIC 9(8).
       77  WS-APPT-DATE             PIC X(10).
       77  WS-APPT-TIME             PIC X(5).
       77  WS-CONFLICT-FLAG         PIC X VALUE "N".

       PROCEDURE DIVISION.
       0000-MAIN-PROCEDURE.
           PERFORM UNTIL WS-EOF = "Y"
               DISPLAY "Appointment Scheduling Management"
               DISPLAY "1. Create Appointment"
               DISPLAY "2. Read Appointments"
               DISPLAY "3. Update Appointment"
               DISPLAY "4. Delete Appointment"
               DISPLAY "5. Generate Report"
               DISPLAY "6. Exit"
               ACCEPT USER-CHOICE
               EVALUATE USER-CHOICE
                   WHEN 1
                       PERFORM CREATE-APPOINTMENT
                   WHEN 2
                       PERFORM READ-APPOINTMENTS
                   WHEN 3
                       PERFORM UPDATE-APPOINTMENT
                   WHEN 4
                       PERFORM DELETE-APPOINTMENT
                   WHEN 5
                       PERFORM GENERATE-REPORT
                   WHEN 6
                       MOVE "Y" TO WS-EOF
                   WHEN OTHER
                       DISPLAY "Invalid choice"
               END-EVALUATE
           END-PERFORM
           STOP RUN.

       CREATE-APPOINTMENT.
           DISPLAY "Enter Appointment ID: "
           ACCEPT WS-APPOINTMENT-ID
           DISPLAY "Enter Patient ID: "
           ACCEPT WS-PATIENT-ID
           DISPLAY "Enter Doctor ID: "
           ACCEPT WS-DOCTOR-ID
           DISPLAY "Enter Appointment Date (YYYY-MM-DD): "
           ACCEPT WS-APPT-DATE
           DISPLAY "Enter Appointment Time (HH:MM): "
           ACCEPT WS-APPT-TIME
           PERFORM CHECK-CONFLICT
           IF WS-CONFLICT-FLAG = "N"
               OPEN OUTPUT APPOINTMENT-FILE
               MOVE WS-APPOINTMENT-ID TO APPOINTMENT-ID
               MOVE WS-PATIENT-ID TO PATIENT-ID
               MOVE WS-DOCTOR-ID TO DOCTOR-ID
               MOVE WS-APPT-DATE TO APPT-DATE
               MOVE WS-APPT-TIME TO APPT-TIME
               WRITE APPOINTMENT-RECORD
               CLOSE APPOINTMENT-FILE
               DISPLAY "Appointment Created Successfully"
           ELSE
               DISPLAY "Conflict detected: Appointment already"
               DISPLAY "exists for this doctor at the specified time."
           END-IF
           .

       CHECK-CONFLICT.
           OPEN INPUT APPOINTMENT-FILE
           MOVE "N" TO WS-EOF
           MOVE "N" TO WS-CONFLICT-FLAG
           PERFORM UNTIL WS-EOF = "Y"
               READ APPOINTMENT-FILE INTO APPOINTMENT-RECORD
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       IF DOCTOR-ID = WS-DOCTOR-ID AND
                          APPT-DATE = WS-APPT-DATE AND
                          APPT-TIME = WS-APPT-TIME
                           MOVE "Y" TO WS-CONFLICT-FLAG
                           MOVE "Y" TO WS-EOF
                       END-IF
               END-READ
           END-PERFORM
           CLOSE APPOINTMENT-FILE
           .

       READ-APPOINTMENTS.
           OPEN INPUT APPOINTMENT-FILE
           PERFORM UNTIL WS-EOF = "Y"
               READ APPOINTMENT-FILE INTO APPOINTMENT-RECORD
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       DISPLAY "Appointment ID: " APPOINTMENT-ID
                       DISPLAY "Patient ID: " PATIENT-ID
                       DISPLAY "Doctor ID: " DOCTOR-ID
                       DISPLAY "Date: " APPT-DATE
                       DISPLAY "Time: " APPT-TIME
               END-READ
           END-PERFORM
           CLOSE APPOINTMENT-FILE
           MOVE "N" TO WS-EOF
           .

       UPDATE-APPOINTMENT.
           OPEN I-O APPOINTMENT-FILE
           DISPLAY "Enter Appointment ID to Update: "
           ACCEPT WS-APPOINTMENT-ID
           PERFORM UNTIL WS-EOF = "Y"
               READ APPOINTMENT-FILE INTO APPOINTMENT-RECORD
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       IF APPOINTMENT-ID = WS-APPOINTMENT-ID
                           DISPLAY "Enter New Patient ID: "
                           ACCEPT WS-PATIENT-ID
                           DISPLAY "Enter New Doctor ID: "
                           ACCEPT WS-DOCTOR-ID
                           DISPLAY "Enter New Appointment Date - "
                                   "(YYYY-MM-DD):"
                           ACCEPT WS-APPT-DATE
                           DISPLAY "Enter New Appointment Time - "
                                   "(HH:MM):"
                           ACCEPT WS-APPT-TIME
                           MOVE WS-PATIENT-ID TO PATIENT-ID
                           MOVE WS-DOCTOR-ID TO DOCTOR-ID
                           MOVE WS-APPT-DATE TO APPT-DATE
                           MOVE WS-APPT-TIME TO APPT-TIME
                           REWRITE APPOINTMENT-RECORD
                           DISPLAY "Appointment Updated Successfully"
                           MOVE "Y" TO WS-EOF
                       END-IF
               END-READ
           END-PERFORM
           CLOSE APPOINTMENT-FILE
           MOVE "N" TO WS-EOF
           .

       DELETE-APPOINTMENT.
           OPEN I-O APPOINTMENT-FILE
           OPEN OUTPUT TEMP-FILE
           DISPLAY "Enter Appointment ID to Delete: "
           ACCEPT WS-APPOINTMENT-ID
           PERFORM UNTIL WS-EOF = "Y"
               READ APPOINTMENT-FILE INTO APPOINTMENT-RECORD
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       IF APPOINTMENT-ID NOT = WS-APPOINTMENT-ID
                           MOVE APPOINTMENT-RECORD TO
                           TEMP-APPOINTMENT-RECORD
                           WRITE TEMP-APPOINTMENT-RECORD
                       END-IF
               END-READ
           END-PERFORM
           CLOSE APPOINTMENT-FILE
           CLOSE TEMP-FILE

           OPEN INPUT TEMP-FILE
           OPEN OUTPUT APPOINTMENT-FILE
           MOVE "N" TO WS-EOF
           PERFORM UNTIL WS-EOF = "Y"
               READ TEMP-FILE INTO TEMP-APPOINTMENT-RECORD
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       MOVE TEMP-APPOINTMENT-RECORD TO
                       APPOINTMENT-RECORD
                       WRITE APPOINTMENT-RECORD
               END-READ
           END-PERFORM
           CLOSE TEMP-FILE
           CLOSE APPOINTMENT-FILE
           DISPLAY "Appointment Deleted Successfully"
           MOVE "N" TO WS-EOF
           .

       GENERATE-REPORT.
           OPEN INPUT APPOINTMENT-FILE
           DISPLAY "Generating Report..."
           PERFORM UNTIL WS-EOF = "Y"
               READ APPOINTMENT-FILE INTO APPOINTMENT-RECORD
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       DISPLAY "----------------------------------"
                       DISPLAY "Appointment ID: " APPOINTMENT-ID
                       DISPLAY "Patient ID: " PATIENT-ID
                       DISPLAY "Doctor ID: " DOCTOR-ID
                       DISPLAY "Date: " APPT-DATE
                       DISPLAY "Time: " APPT-TIME
                       DISPLAY "----------------------------------"
               END-READ
           END-PERFORM
           CLOSE APPOINTMENT-FILE
           MOVE "N" TO WS-EOF
           DISPLAY "Report Generation Complete."
           .
       END PROGRAM APPOINTMENTS.
