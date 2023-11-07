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
import { useDispatch, useSelector } from 'react-redux';
import { RootState } from 'redux/store';
import { userSignedIn, setUserName } from '@redux/slices/amplifySlices';

export default function Home() {
  const dispatch = useDispatch();
  const isAuthenticated = useSelector((state: RootState) => state.amplify.isAuthenticated);

  useEffect(() => {
    checkUserAuthentication();
  });


  const checkUserAuthentication = async () => {
    try {
      const session = await Auth.currentSession();
      if (session) {
        dispatch(userSignedIn());
        dispatch(setUserName(session.getIdToken().payload['cognito:username']));
      
      }
    } catch (error) {
      console.log("User is not authenticated");
    }
  };

  const handleSignIn = () => {
    Auth.federatedSignIn();
  };


  return (
    <div className={styles.container}>
      <Head>
        <title>Norbit IoT Simulator</title>
        <meta name="description" content="Preview an IoT dashboard using your smartphone. Explore real-time data visualization and device management with Norbit IoT Simulator" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        {isAuthenticated ? (
          <Dashboard />
        ) : (
          <button className='signin-button' onClick={handleSignIn}>Sign In</button>
        )}
      </main>


      <footer className={styles.footer}></footer>
    </div>
  );
}
