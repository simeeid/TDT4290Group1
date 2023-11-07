// Note: any style additions must be copied to tests/cypress/support/component.tsx
// to allow components to render properly.
import "@styles/globals.css";
import "@styles/HeaderComponent.css";
import "@styles/SidebarComponent.css";

import { AppProps } from "next/app";
import { Providers } from "redux/provider";
import RootLayout from "components/RootLayout/RootLayout";
import AmplifyInitializer from "components/AmplifyInitializer/AmplifyInitializer";

function MyApp({ Component, pageProps }: AppProps) {
  return (
    <Providers>
      <AmplifyInitializer>
        <RootLayout>
          <Component {...pageProps} />
        </RootLayout>
      </AmplifyInitializer>
    </Providers>
  );
}

export default MyApp;
