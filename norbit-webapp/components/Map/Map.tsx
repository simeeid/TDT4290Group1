import { Map } from 'leaflet';
import React, { useEffect, useRef } from 'react';

// Deferred import for Leaflet
let L: { map: (arg0: never) => { (): any; new(): any; setView: { (arg0: number[], arg1: number): Map | null; new(): any; }; }; tileLayer: (arg0: string, arg1: { attribution: string; }) => { (): any; new(): any; addTo: { (arg0: Map | null): void; new(): any; }; }; marker: (arg0: number[]) => { (): any; new(): any; addTo: { (arg0: Map | null): void; new(): any; }; }; };
if (typeof window !== 'undefined') {
  L = require('leaflet');
}

interface Props {
  latitude: number;
  longitude: number;
}

const LeafletMap: React.FC<Props> = ({ latitude, longitude }) => {
  const mapRef = useRef(null);
  const mapInstance = useRef<L.Map | null>(null);  // Hold the instance of the map

  useEffect(() => {
    if (!mapRef.current) return;
    if (mapInstance.current) return;  // Return if map is already initialized

    // Create the map instance
    mapInstance.current = L.map(mapRef.current).setView([latitude, longitude], 13);

    // Add tiles to the map
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(mapInstance.current);

    // Add a marker
    L.marker([latitude, longitude]).addTo(mapInstance.current);

    // Cleanup
    return () => {
      if (mapInstance.current) {
        mapInstance.current.remove();
        mapInstance.current = null;
      }
    };
  }, [latitude, longitude]);

  return <div id="map" ref={mapRef} style={{ width: '100%', height: '400px' }} />;
};

export default LeafletMap;

