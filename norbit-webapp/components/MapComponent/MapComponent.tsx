import React, { useEffect, useRef, useState } from "react";
import { TamplifyInstance } from "@/Dashboard/Dashboard";
import { useSubscribeToTopics } from "utils/useSubscribeToTopic";
import { MapData } from "./types";
import { LatLngTuple } from "leaflet";
import { MapContainer, useMap, Marker, TileLayer } from "react-leaflet";

let L: typeof import("leaflet") | null;
if (typeof window !== "undefined") {
  L = require("leaflet");
}

/**
 * Mini wrapper-component for centering the map when the location changes. It makes
 * sense for this particular map, as the data is primarily meant to follow the datapoint.
 */
const Recenter = ({ lat, lng }: { lat: number; lng: number }) => {
  const map = useMap();
  useEffect(() => {
    map.setView([lat, lng]);
  }, [lat, lng, map]);
  return null;
};

export const MapComponent: React.FC<{
  amplifyInstance: TamplifyInstance | null;
  topic: string;
}> = ({ amplifyInstance, topic }) => {
  const mapRef = useRef(null);
  const [payload, setPayload] = useState<any>(null);
  const [mapData, setMapData] = useState<MapData>({ latitude: 0, longitude: 0 });

  useEffect(() => {
    if (!payload) return;
    setMapData(payload.payload);
  }, [mapData, payload]);

  useSubscribeToTopics(topic, amplifyInstance, setPayload);

  let currPosition: LatLngTuple = [mapData.latitude, mapData.longitude];

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
        {typeof window !== undefined && L != null && (
          <Marker
            position={currPosition}
            icon={L.icon({ iconUrl: "pngegg.png", iconSize: [25, 25], iconAnchor: [12, 12] })}
          />
        )}
        <Recenter lat={mapData.latitude} lng={mapData.longitude} />
      </MapContainer>
    </div>
  );
};
