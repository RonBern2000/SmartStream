import express from 'express'

const app = express()
const PORT = process.env.PORT ?? 3001

app.use(express.json())

app.get('/health', (_req, res) => {
  res.json({ status: 'ok', service: 'auth-svc' })
})

app.listen(PORT, () => {
  console.log(`auth-svc listening on port ${PORT}`)
})
