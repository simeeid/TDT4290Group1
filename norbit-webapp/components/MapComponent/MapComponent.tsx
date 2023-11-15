import React, { useEffect, useRef, useState } from "react";
import { useSubscribeToTopics } from "utils/useSubscribeToTopic";
import { MapData, TLocationData } from "./types";
import { LatLngTuple } from "leaflet";
import { MapContainer, useMap, Marker, TileLayer } from "react-leaflet";
import { SensorProps } from "@/types";
import { PerformanceComponent } from "@/PerformanceComponent/PerformanceComponent";

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

export const MapComponent: React.FC<SensorProps> = ({ amplifyInstance, topic }) => {
  const mapRef = useRef(null);
  const [payload, setPayload] = useState<TLocationData | null>(null);
  const [mapData, setMapData] = useState<MapData>({ latitude: 0, longitude: 0 });
  const [isPaused, setIsPaused] = useState(false);
  const [pauseCache, setPauseCache] = useState<MapData | null>(null);

  useEffect(() => {
    if (!payload) return;
    if (isPaused) {
      setPauseCache(payload.payload);
      return;
    }
    setMapData(payload.payload);
  }, [mapData, payload, isPaused, pauseCache]);

  useEffect(() => {
    if (pauseCache != null && !isPaused) {
      setMapData(pauseCache);
      setPauseCache(null);
    }
  }, [isPaused, pauseCache, mapData]);

  const togglePause = () => {
    setIsPaused(!isPaused);
  };

  useSubscribeToTopics(topic, amplifyInstance, setPayload);

  let currPosition: LatLngTuple = [mapData.latitude, mapData.longitude];

  return (
    <div className="sensorContainer" id="location-container">
      <div className="chart-wrapper">
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
        <button className="light" onClick={togglePause}>
          {isPaused ? "Resume" : "Pause"}
        </button>
      </div>
      <PerformanceComponent data={payload} pauseOverride={isPaused} />
    </div>
  );
};
