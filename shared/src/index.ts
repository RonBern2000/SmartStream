export interface Card {
  id: string
  name: string
  setId: string
  setName: string
  rarity: string
  imageUrl: string
  marketPrice: number | null
}

export interface User {
  id: number
  email: string
  streamerName: string
  overlayKey: string
  createdAt: string
}

export interface Session {
  id: number
  userId: number
  setName: string
  startedAt: string
  endedAt: string | null
  packCount: number
}

export interface Pull {
  id: number
  sessionId: number
  cardId: string
  cardName: string
  setId: string
  rarity: string
  marketPrice: number | null
  pulledAt: string
}

export type PullEvent = {
  type: 'new_pull'
  payload: Pull & { card: Card }
}

export type ApiResponse<T> = { data: T; error?: never } | { data?: never; error: string }
