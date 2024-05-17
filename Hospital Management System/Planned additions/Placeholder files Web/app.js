document.addEventListener('DOMContentLoaded', () => {
    const root = document.getElementById('root');
    root.innerHTML = `
        <header>
            <h1>Healthcare Management System</h1>
        </header>
        <div class="container">
            <button id="patientsBtn">Manage Patients</button>
            <button id="appointmentsBtn">Manage Appointments</button>
            <button id="billingBtn">Manage Billing</button>
            <button id="adminBtn">Admin</button>
        </div>
    `;

    document.getElementById('patientsBtn').addEventListener('click', () => {
        // Load Patients Management Module
        console.log('Patients button clicked');
    });

    document.getElementById('appointmentsBtn').addEventListener('click', () => {
        // Load Appointments Management Module
        console.log('Appointments button clicked');
    });

    document.getElementById('billingBtn').addEventListener('click', () => {
        // Load Billing Management Module
        console.log('Billing button clicked');
    });

    document.getElementById('adminBtn').addEventListener('click', () => {
        // Load Admin Module
        console.log('Admin button clicked');
    });
});
