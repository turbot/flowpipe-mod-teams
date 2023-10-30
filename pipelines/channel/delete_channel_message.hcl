// usage: flowpipe pipeline run delete_channel_message --pipeline-arg team_id="9b68a1x9-ab01-5678-1234-956f2846aab4" --pipeline-arg channel_id="19:561fbdbbfca848a484f0a6f00ce9dbbd@thread.tacv2" --pipeline-arg message_id="1698686169897"
pipeline "delete_channel_message" {
  title       = "Delete Channel Message"
  description = "Soft delete a single chatMessage in a channel."

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

  param "message_id" {
    type        = string
    description = "The unique identifier for the message."
  }

  step "http" "delete_channel_message" {
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/channels/${param.channel_id}/messages/${param.message_id}/softDelete"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }
  }

  output "raw_output" {
    value       = step.http.delete_channel_message
    description = "Channel message details."
  }
}
