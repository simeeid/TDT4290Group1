import './globals.css'
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import { HeaderComponent } from './components/HeaderComponent/HeaderComponent';
import { Providers } from '../../redux/provider';

import React from 'react';

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Norbit IoT simulator',
  description: 'Preview an IoT dashboard using your smartphone. Explore real-time data visualization and device management with Norbit IoT simulator',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {

  return (
    <html lang="en">

      <body className={inter.className}>
        <Providers>
          <HeaderComponent useSidebar={true}/>
          {children}
        </Providers>
      </body>
    </html>
  )
}
