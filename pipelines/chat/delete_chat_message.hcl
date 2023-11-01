// usage: flowpipe pipeline run delete_chat_message --pipeline-arg chat_id="19:4paze140-abcd-40kb-9c2d-e4b4379ee6c1_944a8e14-1h3t-48c6-bob9-6e93612f6c2b@unq.gbl.spaces" --pipeline-arg user_id="94ka8y13-4b6j-abcd-bob9-6e93612f6c2b" --pipeline-arg message_id="1698751207618"
pipeline "delete_chat_message" {
  title       = "Delete Chat Message"
  description = "Soft delete a single chat message or a chat message reply in a channel."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access token to use for the request."
  }

  param "user_id" {
    type        = string
    description = "The unique identifier for the user."
  }

  param "chat_id" {
    type        = string
    description = "The unique identifier for the chat."
  }

  param "message_id" {
    type        = string
    description = "The unique identifier for the message."
  }

  step "http" "delete_chat_message" {
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/users/${param.user_id}/chats/${param.chat_id}/messages/${param.message_id}/softDelete"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }
  }
}
