// Note: any style additions must be copied to tests/cypress/support/component.tsx
// to allow components to render properly.
import '@styles/globals.css';
import '@styles/HeaderComponent.css';
import '@styles/SidebarComponent.css';

import { AppProps } from 'next/app';
import { Providers } from 'redux/provider';
import RootLayout from 'components/RootLayout/RootLayout';



function MyApp({ Component, pageProps }: AppProps) {
  
  return <Providers> <RootLayout><Component {...pageProps} /> </RootLayout></Providers>
}

export default MyApp;
