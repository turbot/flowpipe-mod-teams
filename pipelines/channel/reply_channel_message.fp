pipeline "reply_channel_message" {
  title       = "Reply Channel Message"
  description = "Send a new reply to a chat message in a specified channel."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
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
    description = "The reply message to send."
  }

  param "message_id" {
    type        = string
    description = local.message_id_param_description
  }

  step "http" "reply_channel_message" {
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/channels/${param.channel_id}/messages/${param.message_id}/replies"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${credential.teams[param.cred].access_token}"
    }

    request_body = jsonencode({
      body = {
        contentType = "html",
        content     = param.message
      }
    })
  }

  output "message" {
    description = "Channel message details."
    value       = step.http.reply_channel_message.response_body
  }
}
