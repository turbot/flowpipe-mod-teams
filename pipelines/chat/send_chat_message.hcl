pipeline "send_chat_message" {
  title       = "Send Chat Message"
  description = "Send a new chat message in the specified chat."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
  }

  param "chat_id" {
    type        = string
    description = "The chat's unique identifier."
  }

  param "message" {
    type        = string
    description = "The message to send."
  }

  param "message_content_type" {
    type        = string
    description = "The type of the content. Possible values are text and html."
    default     = "text"
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
        content     = param.message
        contentType = param.message_content_type
      }
    })
  }

  output "message" {
    value       = step.http.send_chat_message.response_body
    description = "Chat message details."
  }
}