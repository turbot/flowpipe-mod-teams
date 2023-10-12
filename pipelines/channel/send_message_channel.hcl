// usage: flowpipe pipeline run send_message_channel --pipeline-arg team_id="TEAM_ID" --pipeline-arg channel_id="CHANNEL_ID" --pipeline-arg message="MESSAGE"
pipeline "send_message_channel" {
  title       = "Send Message to Channel"
  description = "Send a message to a channel."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access_token to use for the request."
  }

  param "team_id" {
    type        = string
    description = "The ID of the team."
  }

  param "channel_id" {
    type        = string
    description = "The ID of the channel."
  }

  param "message" {
    type        = string
    description = "The message to send."
  }

  step "http" "send_message_channel" {
    title  = "Sends Message"
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
    value       = step.http.send_message_channel.response_body
    description = "The sent message."
  }
}
