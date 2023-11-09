pipeline "send_channel_message" {
  title       = "Send Channel Message"
  description = "Send a new chat message in the specified channel."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
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

  step "http" "send_channel_message" {
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/channels/${param.channel_id}/messages"

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
    value       = step.http.send_channel_message.response_body
    description = "Channel message details."
  }
}
