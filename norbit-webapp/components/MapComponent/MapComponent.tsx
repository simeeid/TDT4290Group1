import React, { useEffect, useRef, useState } from 'react';
import { TamplifyInstance } from '@/dashboard/Dashboard';
import { useSubscribeToTopics } from 'utils/useSubscribeToTopic';
import { MapData } from './types';
import dynamic from 'next/dynamic';
import {LatLngTuple} from 'leaflet';


let L: typeof import('leaflet') | null;
if (typeof window !== 'undefined') {
  L = require('leaflet');
}

export const MapContainer = dynamic(
  () => import("react-leaflet").then((m) => m.MapContainer),
  { ssr: false }
);
export const Marker = dynamic(
  () => import("react-leaflet").then((m) => m.Marker),
  { ssr: false }
);
export const TileLayer = dynamic(
  () => import("react-leaflet").then((m) => m.TileLayer),
  { ssr: false }
);

export const MapComponent: React.FC<{ amplifyInstance: TamplifyInstance | null, topic: string }> = ({ amplifyInstance, topic }) => {

  const mapRef = useRef(null);
  const [payload, setPayload] = useState<any>(null); 
  const [mapData, setMapData] = useState<MapData>({ latitude: 0, longitude: 0 });

  useEffect(() => {
    if (!payload) return;
    setMapData(payload.payload)

  }, [payload]);  

  useSubscribeToTopics(topic,amplifyInstance,setPayload);

  let currPosition: LatLngTuple = [ mapData.latitude, mapData.longitude ];
  return (
    <div className="sensorContainer" id="location-container">
      <h2>Location</h2>
      <MapContainer
        center={currPosition}
        zoom={13}
        scrollWheelZoom={false}
        ref={mapRef}
        style={{
          height: "300px",
        }}
      >
        <TileLayer
          attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
          url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
        />
        { typeof window !== undefined && L != null && <Marker
          position={currPosition}
          icon={L.icon({iconUrl: "pngegg.png", iconSize: [25, 25], iconAnchor: [12, 12]})} 
        />}
      </MapContainer>
    </div>
  )
};


