import Dashboard from './components/dashboard/Dashboard'

export default function Home() {
  return (
    <main className="flex flex-col items-center justify-between">
      <h1 className="center-text">Welcome to our Home</h1>
      <>
        <Dashboard/>
      </>
    </main>
  )
}
