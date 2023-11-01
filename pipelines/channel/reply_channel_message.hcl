// usage: flowpipe pipeline run reply_channel_message --pipeline-arg team_id="9b68a1x9-ab01-5678-1234-956f2846aab4" --pipeline-arg channel_id="19:561fbdbbfca848a484f0a6f00ce9dbbd@thread.tacv2" --pipeline-arg message="Hello World" --pipeline-arg message_id="1698737048972"
pipeline "reply_channel_message" {
  title       = "Reply Channel Message"
  description = "Send a new reply to a message in a specified channel."

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
    description = "The reply message to send."
  }

  param "message_id" {
    type        = string
    description = "The unique identifier for the message."
  }

  step "http" "reply_channel_message" {
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/channels/${param.channel_id}/messages/${param.message_id}/replies"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }

    request_body = jsonencode({
      body = {
        contentType =  "html",
        content = param.message
      }
    })
  }

  output "message" {
    value       = step.http.reply_channel_message.response_body
    description = "Channel message details."
  }
}
