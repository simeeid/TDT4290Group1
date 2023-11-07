import Head from "next/head";
import styles from "@styles/Home.module.css";
import Dashboard from "@/Dashboard/Dashboard";
import { Auth } from "aws-amplify";
import { useEffect } from "react";
import { useDispatch, useSelector } from "react-redux";
import { RootState } from "redux/store";
import { userSignedIn, setUserName } from "@redux/slices/amplifySlice";
import {HeaderComponent} from "@/HeaderComponent/HeaderComponent";

export default function Home() {
  const dispatch = useDispatch();
  const isAuthenticated = useSelector((state: RootState) => state.amplify.isAuthenticated);
  const mock = useSelector((state: RootState) => state.amplify.isMock);

  useEffect(() => {
    checkUserAuthentication();
  });

  const checkUserAuthentication = async () => {
    if (mock) {
      return;
    }
    try {
      const session = await Auth.currentSession();
      if (session) {
        dispatch(userSignedIn());
        dispatch(setUserName(session.getIdToken().payload["cognito:username"]));
      }
    } catch (error) {
      console.log("User is not authenticated");
    }
  };

  const handleSignIn = () => {
    if (mock) {
      dispatch(userSignedIn());
      dispatch(setUserName("ILikeTrains"));
      return;
    }
    Auth.federatedSignIn();
  };

  return (
    <div className={styles.container}>
      <Head>
        <title>Norbit IoT Simulator</title>
        <meta
          name="description"
          content="Preview an IoT dashboard using your smartphone. Explore real-time data visualization and device management with Norbit IoT Simulator"
        />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <HeaderComponent useSidebar={isAuthenticated} />
      <main className={styles.main}>
        {isAuthenticated ? (
          <Dashboard />
        ) : (
          <button id="signin" name="sign-in" className="green" onClick={handleSignIn}>
            Sign In
          </button>
        )}
      </main>

      <footer className={styles.footer}></footer>
    </div>
  );
}
