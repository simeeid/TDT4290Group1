import { Map } from 'leaflet';
import React, { useEffect, useRef, useState } from 'react';
import { TamplifyInstance } from '@/dashboard/Dashboard';
import { useSubscribeToTopics } from 'utils/useSubscribeToTopic';
import { set } from 'cypress/types/lodash';
import { MapData } from './types';


// Deferred import for Leaflet
let L: typeof import('leaflet');
if (typeof window !== 'undefined') {
  L = require('leaflet');
}


const LeafletMap: React.FC<{ amplifyInstance: TamplifyInstance | null }> = ({ amplifyInstance }) => {
  const mapRef = useRef(null);
  const mapInstance = useRef<L.Map | null>(null); 
  const [payload, setPayload] = useState<any>(null); 
  const [mapData, setMapData] = useState<MapData>({ latitude: 63, longitude: 10 });
  console.log(mapData);

  useEffect(() => {
    if (!payload) return;
    setMapData(payload.payload)

  }, [payload]);  
  useEffect(() => {
    if (!mapRef.current) return;
    if (mapInstance.current) return;  // Return if map is already initialized

    // Create the map instance
    mapInstance.current = L.map(mapRef.current).setView([mapData.latitude,mapData.longitude], 13);


    // Add a marker
    L.marker([mapData.latitude,mapData.longitude]).addTo(mapInstance.current);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(mapInstance.current);

    // Cleanup
    return () => {
      if (mapInstance.current) {
        mapInstance.current.remove();
        mapInstance.current = null;
      }
    };
  }, [mapData]);

  useSubscribeToTopics('location/topic',amplifyInstance,setPayload);

  return <div id="map" ref={mapRef} style={{ width: '100%', height: '400px' }} />;
};

export default LeafletMap;

