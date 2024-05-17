import React, { useState, useEffect } from 'react';

function Appointments() {
    const [appointments, setAppointments] = useState([]);

    useEffect(() => {
        fetch('/api/appointments')
            .then(response => response.json())
            .then(data => setAppointments(data));
    }, []);

    return (
        <div>
            <h2>Appointments</h2>
            <ul>
                {appointments.map(appointment => (
                    <li key={appointment.id}>
                        Patient ID: {appointment.patientId}, Date: {appointment.date}, Time: {appointment.time}
                    </li>
                ))}
            </ul>
        </div>
    );
}

export default Appointments;
