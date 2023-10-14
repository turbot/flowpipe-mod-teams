// usage: flowpipe pipeline run send_channel_message --pipeline-arg team_id="TEAM_ID" --pipeline-arg channel_id="CHANNEL_ID" --pipeline-arg message="MESSAGE"
pipeline "send_channel_message" {
  title       = "Send Channel Message"
  description = "Send a new chat message in the specified channel."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access token to use for the request."
  }

  param "team_id" {
    type        = string
    description = "The unique identifier of the team."
  }

  param "channel_id" {
    type        = string
    description = "The unique identifier for the channel."
  }

  param "message" {
    type        = string
    description = "The message to send."
  }

  step "http" "send_channel_message" {
    title  = "Send Channel Message"
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/channels/${param.channel_id}/messages"

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
    value       = step.http.send_channel_message.response_body
    description = "The new channel message object."
  }
}
