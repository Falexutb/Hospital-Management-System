import React, { useState, useEffect } from 'react';

function Billing() {
    const [bills, setBills] = useState([]);

    useEffect(() => {
        fetch('/api/billing')
            .then(response => response.json())
            .then(data => setBills(data));
    }, []);

    return (
        <div>
            <h2>Billing</h2>
            <ul>
                {bills.map(bill => (
                    <li key={bill.id}>
                        Patient ID: {bill.patientId}, Amount: ${bill.amount.toFixed(2)}
                    </li>
                ))}
            </ul>
        </div>
    );
}

export default Billing;
