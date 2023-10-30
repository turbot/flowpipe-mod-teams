// usage: flowpipe pipeline run list_channels --pipeline-arg team_id="9b68a1x9-ab01-5678-1234-956f2846aab4"
pipeline "list_channels" {
  title       = "List Channels"
  description = "List the channels in a team."

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

  step "http" "list_channels" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/channels"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }
  }

  output "channels" {
    value       = step.http.list_channels.response_body
    description = "Channel details."
  }

  output "status_code" {
    value = step.http.list_channels.status_code
  }
}
