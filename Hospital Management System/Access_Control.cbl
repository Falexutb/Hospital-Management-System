       IDENTIFICATION DIVISION.
       PROGRAM-ID. ACCESS-CONTROL.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT USER-FILE ASSIGN TO "/data\users.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TEMP-FILE ASSIGN TO "/data\temp.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  USER-FILE.
       01  USER-RECORD.
           05  USER-ID              PIC 9(8).
           05  USERNAME             PIC X(20).
           05  ROLE                 PIC X(3).
           05  PASSWORD             PIC X(20).

       FD  TEMP-FILE.
       01  TEMP-USER-RECORD.
           05  TEMP-USER-ID         PIC 9(8).
           05  TEMP-USERNAME        PIC X(20).
           05  TEMP-ROLE            PIC X(3).
           05  TEMP-PASSWORD        PIC X(20).

       WORKING-STORAGE SECTION.
       77  WS-EOF                   PIC X VALUE "N".
       77  USER-CHOICE              PIC 9.
       77  WS-USER-ID               PIC 9(8).
       77  WS-USERNAME              PIC X(20).
       77  WS-ROLE                  PIC X(3).
       77  WS-PASSWORD              PIC X(20).

       PROCEDURE DIVISION.
       0000-MAIN-PROCEDURE.
           PERFORM UNTIL WS-EOF = "Y"
               DISPLAY "Access Control Management"
               DISPLAY "1. Create User"
               DISPLAY "2. Read Users"
               DISPLAY "3. Update User"
               DISPLAY "4. Delete User"
               DISPLAY "5. Exit"
               ACCEPT USER-CHOICE
               EVALUATE USER-CHOICE
                   WHEN 1
                       PERFORM CREATE-USER
                   WHEN 2
                       PERFORM READ-USERS
                   WHEN 3
                       PERFORM UPDATE-USER
                   WHEN 4
                       PERFORM DELETE-USER
                   WHEN 5
                       MOVE "Y" TO WS-EOF
                   WHEN OTHER
                       DISPLAY "Invalid choice"
               END-EVALUATE
           END-PERFORM
           STOP RUN.

       CREATE-USER.
           OPEN OUTPUT USER-FILE
           DISPLAY "Enter User ID: "
           ACCEPT WS-USER-ID
           DISPLAY "Enter Username: "
           ACCEPT WS-USERNAME
           DISPLAY "Enter Role (Adm, Dr, Nrs): "
           ACCEPT WS-ROLE
           DISPLAY "Enter Password: "
           ACCEPT WS-PASSWORD
           MOVE WS-USER-ID TO USER-ID
           MOVE WS-USERNAME TO USERNAME
           MOVE WS-ROLE TO ROLE
           MOVE WS-PASSWORD TO PASSWORD
           WRITE USER-RECORD
           CLOSE USER-FILE
           DISPLAY "User Created Successfully"
           .

       READ-USERS.
           OPEN INPUT USER-FILE
           PERFORM UNTIL WS-EOF = "Y"
               READ USER-FILE INTO USER-RECORD
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       DISPLAY "User ID: " USER-ID
                       DISPLAY "Username: " USERNAME
                       DISPLAY "Role: " ROLE
                       DISPLAY "Password: " PASSWORD
               END-READ
           END-PERFORM
           CLOSE USER-FILE
           MOVE "N" TO WS-EOF
           .

       UPDATE-USER.
           OPEN I-O USER-FILE
           DISPLAY "Enter User ID to Update: "
           ACCEPT WS-USER-ID
           PERFORM UNTIL WS-EOF = "Y"
               READ USER-FILE INTO USER-RECORD
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       IF USER-ID = WS-USER-ID
                           DISPLAY "Enter New Username: "
                           ACCEPT WS-USERNAME
                           DISPLAY "Enter New Role (Adm, Dr, Nrs): "
                           ACCEPT WS-ROLE
                           DISPLAY "Enter New Password: "
                           ACCEPT WS-PASSWORD
                           MOVE WS-USERNAME TO USERNAME
                           MOVE WS-ROLE TO ROLE
                           MOVE WS-PASSWORD TO PASSWORD
                           REWRITE USER-RECORD
                           DISPLAY "User Updated Successfully"
                           MOVE "Y" TO WS-EOF
                       END-IF
               END-READ
           END-PERFORM
           CLOSE USER-FILE
           MOVE "N" TO WS-EOF
           .

       DELETE-USER.
           OPEN I-O USER-FILE
           OPEN OUTPUT TEMP-FILE
           DISPLAY "Enter User ID to Delete: "
           ACCEPT WS-USER-ID
           PERFORM UNTIL WS-EOF = "Y"
               READ USER-FILE INTO USER-RECORD
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       IF USER-ID NOT = WS-USER-ID
                           MOVE USER-RECORD TO TEMP-USER-RECORD
                           WRITE TEMP-USER-RECORD
                       END-IF
               END-READ
           END-PERFORM
           CLOSE USER-FILE
           CLOSE TEMP-FILE

           OPEN INPUT TEMP-FILE
           OPEN OUTPUT USER-FILE
           PERFORM UNTIL WS-EOF = "Y"
               READ TEMP-FILE INTO TEMP-USER-RECORD
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       MOVE TEMP-USER-RECORD TO USER-RECORD
                       WRITE USER-RECORD
               END-READ
           END-PERFORM
           CLOSE TEMP-FILE
           CLOSE USER-FILE
           DISPLAY "User Deleted Successfully"
           MOVE "N" TO WS-EOF
           .

       END PROGRAM ACCESS-CONTROL.
