// usage: flowpipe pipeline run send_channel_message --pipeline-arg team_id="9b68a1x9-ab01-5678-1234-956f2846aab4" --pipeline-arg channel_id="19:561fbdbbfca848a484f0a6f00ce9dbbd@thread.tacv2" --pipeline-arg message="Hello World"
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
    default     = var.team_id
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
