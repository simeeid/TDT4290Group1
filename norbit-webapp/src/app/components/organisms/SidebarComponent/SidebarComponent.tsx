
import {useState} from 'react';
import './SidebarComponent.css'

interface SidebarProps {

}

export const SidebarComponent: React.FC<SidebarProps> = ({ ...props }) => {
    const [sidebarActive, setSidebarActive] = useState(false);
    const [devices, setDevices] = useState([] as Array<string>);

    const deviceHtml = [];

    for (let i = 0; i < devices.length; ++i) {
        let device = devices[i];

        deviceHtml.push(<div className="device-list-item">
            <h3>Device name here</h3>
        </div>);
    }

    return (
        <div>
            <button className="hamburger-button" onClick={() => {
                setSidebarActive(true);
            }}>≡</button>


            <div className={"sidebar " + (sidebarActive ? "" : "hidden")}>
                <div className="right">
                    <button className="close-button" onClick={() => {
                        setSidebarActive(false);
                    }}>x</button>
                </div>
                <div>
                    <h2>Connect device</h2>
                    <form onSubmit={(ev) => {
                        ev.preventDefault();
                        
                        let idField = document.getElementById("device-id") as HTMLInputElement;

                        let id = idField.value;
                        console.log(id);
                        // TODO: handle device registration
                    }}>
                        <label>Enter device ID</label>
                        <input id="device-id" name="device-id" placeholder="ABCD1234" />

                        <button type="submit">Connect now!</button>
                    </form>

                    <hr />
                    <h2>Device list</h2>

                    { devices.length == 0 ? <p>No devices connected :(</p> : deviceHtml }
                </div>

            </div>
        </div>
    );
};
