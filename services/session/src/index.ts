import express from 'express'

const app = express()
const PORT = process.env.PORT ?? 3003

app.use(express.json())

app.get('/health', (_req, res) => {
  res.json({ status: 'ok', service: 'session-svc' })
})

app.listen(PORT, () => {
  console.log(`session-svc listening on port ${PORT}`)
})
