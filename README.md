# Hospital Management System (HMS) - COBOL

Welcome to the Hospital Management System (HMS) project! This system is developed in COBOL and designed to handle patient records, appointment scheduling, billing, and more within a healthcare setting. Below you will find detailed information on the system's architecture, features, and how to get started.

## Table of Contents
- [Overview](#overview)
- [System Architecture](#system-architecture)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Modules](#modules)
- [Future Plans](#future-plans)
- [Contributing](#contributing)
- [License](#license)

## Overview
The HMS project involves creating a comprehensive healthcare management system using COBOL, which is ideal for data processing tasks. This system will manage patient records, schedule appointments, process billing, and ensure secure access control. A web application front end will be developed for improved user interaction and accessibility.

## System Architecture
The system is built on a multi-layer architecture to separate concerns and ensure maintainability. Here is an overview of the architecture:

### User Interface Layer
- **Desktop Text Interface**: A text-based interface for managing patients, appointments, billing, and administrative tasks.
- **(Planned) Web Application Front End**: HTML, CSS, JavaScript, and a modern framework like React or Angular for a dynamic and responsive user interface.

### Application Logic Layer
- **Patient Records Management**: CRUD operations, data validation, and reporting.
- **Appointment Scheduling**: Scheduling logic, conflict resolution, and reporting.
- **Billing and Payments**: Invoice generation, financial record keeping, and reporting.
- **Access Control**: Authentication and authorization management.

### Data Access Layer
- **File-Based Access Modules**: Initial interface with the file system.
- **(Planned) MSSQL Access Modules**: Prepare for future scalability with MSSQL.

### Database Layer
- **Current State**: File-based storage.
- **(Planned) Future State**: Transition to MSSQL with tables and stored procedures.

### External Systems Integration
- **(Planned) Payment Gateway**: Placeholder for future integration with a payment gateway.

## Features
- **Patient Records Management**: Store, update, and retrieve patient records including personal details and medical history.
- **Appointment Scheduling**: Manage scheduling between patients and healthcare providers, handling times, dates, and availability.
- **Billing and Payments**: Generate invoices, process payments, and maintain financial records.
- **Access Control**: Manage authentication and authorization with different access levels for various user roles.
- **Web Application Front End**: Provide a web-based interface for easier interaction.

## Installation
To install and set up the HMS system, follow these steps:

1. **Clone the Repository**:
    ```bash
    git clone https://github.com/falexutb/hospital-management-system.git
    cd hospital-management-system
    ```

2. **Set Up COBOL Environment**:
   - Install [OpenCobolIDE](https://www.opencobolide.com/) and [GnuCOBOL](https://www.gnu.org/software/gnucobol/).

3. **Configure Database**:
   - Initially, configure file-based storage.
   - For future MSSQL integration, set up an MSSQL server and update configuration files accordingly.

4. **Run the Application**:
   - Use OpenCobolIDE to open and run the COBOL source files.

## Usage
### Desktop Text Interface
1. **Launch the Application**:
   Open the COBOL application in OpenCobolIDE and run it.
2. **Main Menu**:
   Navigate through options for managing patients, appointments, billing, and admin tasks.

### (Planned) Web Application
1. **Launch the Web Application**:
   Run the web server and open the web application in a browser.
2. **Main Menu**:
   Use the web interface to manage patients, appointments, billing, and admin tasks.

## Modules
### Patient Records Management
- Functions for creating, retrieving, updating, and deleting patient records.

### Appointment Scheduling
- Functions to add, view, and manage appointments, ensuring no conflicts.

### Billing and Payments
- Functions to generate invoices and handle payments.

### Access Control
- Functions to manage login and access rights based on user roles.

### Web Application Development
- **HTML/CSS/JavaScript**: Develop basic web pages and styles.
- **RESTful APIs**: Create APIs for communication between the web front end and the COBOL backend.
- **Front-End Framework**: Use React or Angular for a dynamic user interface.

## Future Plans
- **MSSQL Integration**: Transition from file-based storage to MSSQL.
- **Payment Gateway Integration**: Add support for payment processing.
- **Scalability Enhancements**: Design the system for easy scalability.

## Planned Additions
In the folder "Planned Additions," there are placeholder files for the planned enhancements to the application. These include future integration points for MSSQL access modules, payment gateway, and more.

## Contributing
We welcome contributions to improve the Hospital Management System. Please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Make your changes and commit them (`git commit -m 'Add new feature'`).
4. Push to the branch (`git push origin feature-branch`).
5. Create a Pull Request.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

We hope this README provides a comprehensive guide to the HMS project. If you have any questions or need further assistance, feel free to open an issue or contact us directly. Thank you for using the Hospital Management System!
