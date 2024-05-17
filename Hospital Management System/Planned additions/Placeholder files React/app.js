import React from 'react';
import { BrowserRouter as Router, Route, Switch, Link } from 'react-router-dom';
import Patients from './Patients';
import Appointments from './Appointments';
import Billing from './Billing';
import Admin from './Admin';

function App() {
    return (
        <Router>
            <div>
                <header>
                    <h1>Healthcare Management System</h1>
                    <nav>
                        <ul>
                            <li><Link to="/patients">Manage Patients</Link></li>
                            <li><Link to="/appointments">Manage Appointments</Link></li>
                            <li><Link to="/billing">Manage Billing</Link></li>
                            <li><Link to="/admin">Admin</Link></li>
                        </ul>
                    </nav>
                </header>
                <div className="container">
                    <Switch>
                        <Route path="/patients" component={Patients} />
                        <Route path="/appointments" component={Appointments} />
                        <Route path="/billing" component={Billing} />
                        <Route path="/admin" component={Admin} />
                    </Switch>
                </div>
            </div>
        </Router>
    );
}

export default App;
