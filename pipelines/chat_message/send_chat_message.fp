pipeline "send_chat_message" {
  title       = "Send Chat Message"
  description = "Send a new chat message in the specified chat."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "chat_id" {
    type        = string
    description = local.chat_id_param_description
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
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/chats/${param.chat_id}/messages"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${credential.teams[param.cred].access_token}"
    }

    request_body = jsonencode({
      body = {
        content     = param.message
        contentType = param.message_content_type
      }
    })
  }

  output "message" {
    description = "A new chat message object."
    value       = step.http.send_chat_message.response_body
  }
}
