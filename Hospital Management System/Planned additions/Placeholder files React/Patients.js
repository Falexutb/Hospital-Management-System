import React, { useState, useEffect } from 'react';

function Patients() {
    const [patients, setPatients] = useState([]);

    useEffect(() => {
        fetch('/api/patients')
            .then(response => response.json())
            .then(data => setPatients(data));
    }, []);

    return (
        <div>
            <h2>Patients</h2>
            <ul>
                {patients.map(patient => (
                    <li key={patient.id}>{patient.name}</li>
                ))}
            </ul>
        </div>
    );
}

export default Patients;
