pipeline "delete_chat_message" {
  title       = "Delete Chat Message"
  description = "Delete a single chat message in a chat."

  param "conn" {
    type        = connection.teams
    description = local.conn_param_description
    default     = connection.teams.default
  }

  param "user_id" {
    type        = string
    description = local.user_id_param_description
  }

  param "chat_id" {
    type        = string
    description = local.chat_id_param_description
  }

  param "message_id" {
    type        = string
    description = local.message_id_param_description
  }

  step "http" "delete_chat_message" {
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/users/${param.user_id}/chats/${param.chat_id}/messages/${param.message_id}/softDelete"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.conn.access_token}"
    }
  }
}
