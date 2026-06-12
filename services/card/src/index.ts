import express from 'express'

const app = express()
const PORT = process.env.PORT ?? 3002

app.use(express.json())

app.get('/health', (_req, res) => {
  res.json({ status: 'ok', service: 'card-svc' })
})

app.listen(PORT, () => {
  console.log(`card-svc listening on port ${PORT}`)
})
