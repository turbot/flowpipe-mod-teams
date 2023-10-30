// usage: flowpipe pipeline run create_channel --pipeline-arg team_id="9b68a1x9-ab01-5678-1234-956f2846aab4" --pipeline-arg channel_id="19:561fbdbbfca848a484f0a6f00ce9dbbd@thread.tacv2"
pipeline "delete_channel" {
  title       = "Delete Channel"
  description = "Delete the channel from team."

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
    description = "The unique identifier of the channel."
  }

  step "http" "delete_channel" {
    method = "delete"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/channels/${param.channel_id}"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }
  }

  output "status_code" {
    value = step.http.delete_channel.status_code
  }
}
