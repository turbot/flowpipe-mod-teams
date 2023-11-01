// usage: flowpipe pipeline run send_chat_message --pipeline-arg chat_id="19:4paze140-abcd-40kb-9c2d-e4b4379ee6c1_944a8e14-1h3t-48c6-bob9-6e93612f6c2b@unq.gbl.spaces" --pipeline-arg message="Hello There"
pipeline "send_chat_message" {
  title       = "Send Chat Message"
  description = "Send a new chat message in the specified chat."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access token to use for the request."
  }

  param "chat_id" {
    type        = string
    description = "The chat's unique identifier."
  }

  param "message" {
    type        = string
    description = "The message to send."
  }

  step "http" "send_chat_message" {
    title  = "Send Chat Message"
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/chats/${param.chat_id}/messages"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }

    request_body = jsonencode({
      body = {
        content = param.message
      }
    })
  }

  output "message" {
    value       = step.http.send_chat_message.response_body
    description = "Chat message details."
  }
}
