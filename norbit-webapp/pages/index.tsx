import Head from 'next/head';
import styles from '../styles/Home.module.css';
import Dashboard from 'components/dashboard/Dashboard';


import { Amplify, Auth } from 'aws-amplify';
import { amplifyConfig } from 'amplify-config';
import { AWSIoTProvider } from '@aws-amplify/pubsub/lib/Providers';
import { useState } from 'react';
import { TLightIntensityData } from 'components/LightIntensityComponent/types';
import { useSubscribeToTopics } from 'utils/useSubscribeToTopic';
import {useEffect}  from 'react';

export default function Home() {

  Amplify.configure(amplifyConfig);
  const handleSignIn = async () => {
    await Auth.federatedSignIn();
    
    Amplify.addPluggable(new AWSIoTProvider({
        aws_pubsub_region: process.env.NEXT_PUBLIC_REGION,
        aws_pubsub_endpoint: `wss://${process.env.NEXT_PUBLIC_MQTT_ID}/mqtt`,
    }));

    Auth.currentCredentials().then((info) => {
      console.log(info.identityId);
    });

};

  return (
    <div className={styles.container}>
      <Head>
        <title>Norbit IoT Simulator</title>
        <meta name="description" content="Preview an IoT dashboard using your smartphone. Explore real-time data visualization and device management with Norbit IoT Simulator" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        <button onClick={handleSignIn}>Sign In

        </button>




      </main>

      <footer className={styles.footer}></footer>
    </div>
  );
}
