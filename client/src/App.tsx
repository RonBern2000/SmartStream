const MODES = ['control', 'overlay'] as const
type Mode = (typeof MODES)[number]

function getMode(): Mode {
  const param = new URLSearchParams(window.location.search).get('mode')
  return MODES.includes(param as Mode) ? (param as Mode) : 'control'
}

export default function App() {
  const mode = getMode()

  if (mode === 'overlay') {
    return <div className="fixed inset-0 bg-transparent" id="overlay-root" />
  }

  return (
    <div className="min-h-screen bg-gray-900 text-white flex items-center justify-center">
      <h1 className="text-3xl font-bold">SmartStream — Control Panel</h1>
    </div>
  )
}
