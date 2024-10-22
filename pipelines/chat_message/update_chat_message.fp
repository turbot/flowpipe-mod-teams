pipeline "update_chat_message" {
  title       = "Update Chat Message"
  description = "Update a chat message."

  param "conn" {
    type        = connection.teams
    description = local.conn_param_description
    default     = connection.teams.default
  }

  param "chat_id" {
    type        = string
    description = local.chat_id_param_description
  }

  param "message" {
    type        = string
    description = "The updated message to send."
  }

  param "message_id" {
    type        = string
    description = local.message_id_param_description
  }

  step "http" "update_chat_message" {
    method = "patch"
    url    = "https://graph.microsoft.com/v1.0/chats/${param.chat_id}/messages/${param.message_id}"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.conn.access_token}"
    }

    request_body = jsonencode({
      body = {
        content = param.message
      }
    })
  }
}
