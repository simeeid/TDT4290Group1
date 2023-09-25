import './globals.css'
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import {HeaderComponent} from './components/HeaderComponent/HeaderComponent';
import {Device} from './DeviceManager';
import { Providers } from '../../redux/provider';

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: '',
  description: '',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  let devices = [] as Array<Device>;

  return (
    <html lang="en">

      <body className={inter.className}>
        <Providers>
          <HeaderComponent devices={devices} useSidebar={true}/>
          {children}
        </Providers>
      </body>
    </html>
  )
}
