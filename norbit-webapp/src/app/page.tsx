import Dashboard from './components/dashboard/Dashboard'
export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-between p-24">
      <h1 className="text-4xl font-bold">Welcome to our Home</h1>
      <>
        <Dashboard/>
      </>
    </main>
  )
}
