import Head from 'next/head';
import styles from '../styles/Home.module.css';
import Dashboard from 'components/dashboard/Dashboard';
import { Amplify, PubSub } from 'aws-amplify';
import { AWSIoTProvider } from '@aws-amplify/pubsub/lib/Providers';
import { useEffect, useState } from 'react';

export default function Home() {
  const [receivedMessage, setReceivedMessage] = useState<string>('');

  const config = {
    identityPoolId: process.env.NEXT_PUBLIC_IDENTITY_POOL_ID,
    region: process.env.NEXT_PUBLIC_REGION,
    userPoolId: process.env.NEXT_PUBLIC_USER_POOL_ID,
    userPoolWebClientId: process.env.NEXT_PUBLIC_USER_POOL_WEB_CLIENT_ID,
  };

  Amplify.configure(config);
  Amplify.addPluggable(
    new AWSIoTProvider({
      aws_pubsub_region: process.env.NEXT_PUBLIC_REGION,
      aws_pubsub_endpoint: `wss://${process.env.NEXT_PUBLIC_MQTT_ID}/mqtt`,
    })
  );

  useEffect(() => {
    // Start subscription
    const subscription = Amplify.PubSub.subscribe('main/topic').subscribe({
      next: (data: any) => {
        console.log('Message received', data.value.message);
        setReceivedMessage(data.value.message);
      },
      error: (error: { message: string | string[] }) => {
        console.error('Subscription error:', error);
        if (error.message.includes('Connection failed')) {
          console.error('Connection failed.');
        }
      },
      close: () => console.log('Done'),
    });

    // Cleanup subscription on component unmount
    return () => {
      if (subscription) {
        subscription.unsubscribe();
      }
    };
  }, []); 
  
  return (
    <div className={styles.container}>
      <Head>
        <title>Create Next App</title>
        <meta name="description" content="Generated by create next app" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>


        {receivedMessage && (
          <div>
            <h2>Received Message:</h2>
            <p>{receivedMessage}</p>
          </div>
        )}
        <Dashboard />

      </main>

      <footer className={styles.footer}></footer>
    </div>
  );
}
