import Head from 'next/head';
import styles from '../styles/Home.module.css';
import Dashboard from 'components/dashboard/Dashboard';
import dynamic from 'next/dynamic';
import LeafletMap from '@/Map/Map';


import { useEffect, useState } from 'react';

const DynamicLeafletMap = dynamic(
  () => import('components/Map/Map'),
  {
    loading: () => <p>Loading map...</p>,
    ssr: false
  }
);

export default function Home() {
  
  return (
    <div className={styles.container}>
      <Head>
        <title>Norbit IoT Simulator</title>
        <meta name="description" content="Preview an IoT dashboard using your smartphone. Explore real-time data visualization and device management with Norbit IoT Simulator" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        <Dashboard />

      <DynamicLeafletMap latitude={63} longitude={10} />




      </main>

      <footer className={styles.footer}></footer>
    </div>
  );
}
