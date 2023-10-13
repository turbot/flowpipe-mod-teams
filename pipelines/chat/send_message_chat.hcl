// usage: flowpipe pipeline run send_message_chat --pipeline-arg chat_id="CHAT_ID" --pipeline-arg message="MESSAGE"
pipeline "send_message_chat" {
  title       = "Send Message to Chat"
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

  step "http" "send_message_chat" {
    title  = "Send Message to Chat"
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/chats/${param.chat_id}/messages"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }

    request_body = jsonencode({
      body = {
        content = "${param.message}"
      }
    })
  }

  output "message" {
    value       = step.http.send_message_chat.response_body
    description = "The new chat message object."
  }
}
