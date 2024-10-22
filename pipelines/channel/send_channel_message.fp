pipeline "send_channel_message" {
  title       = "Send Channel Message"
  description = "Send a new chat message in the specified channel."

  tags = {
    recommended = "true"
  }

  param "conn" {
    type        = connection.teams
    description = local.conn_param_description
    default     = connection.teams.default
  }

  param "team_id" {
    type        = string
    description = local.team_id_param_description
  }

  param "channel_id" {
    type        = string
    description = local.channel_id_param_description
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

  step "http" "send_channel_message" {
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/channels/${param.channel_id}/messages"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.conn.access_token}"
    }

    request_body = jsonencode({
      body = {
        content     = param.message
        contentType = param.message_content_type
      }
    })
  }

  output "message" {
    description = "Channel message details."
    value       = step.http.send_channel_message.response_body
  }
}
