// usage: flowpipe pipeline run send_message_chat --pipeline-arg chat_id="CHAT_ID" --pipeline-arg message="MESSAGE"
pipeline "send_message_chat" {
  description = "Send a message to a chat."

  param "token" {
    type        = string
    default     = var.token
    description = "The access token to use for the request."
  }

  param "chat_id" {
    type        = string
    description = "The chat id to send the message to."
  }

  param "message" {
    type        = string
    description = "The message to send."
  }

  step "http" "send_message_chat" {
    title  = "Sends message to a chat"
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/chats/${param.chat_id}/messages"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      body = {
        content = "${param.message}"
      }
    })
  }

  output "id" {
    value       = jsondecode(step.http.send_message_chat.response_body).id
    description = "The id of the message that was sent."
  }
  output "response_body" {
    value = step.http.send_message_chat.response_body
  }
  output "response_headers" {
    value = step.http.send_message_chat.response_headers
  }
  output "status_code" {
    value = step.http.send_message_chat.status_code
  }
}
