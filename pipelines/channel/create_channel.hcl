// usage: flowpipe pipeline run create_channel --pipeline-arg team_id="TEAM_ID" --pipeline-arg channel_name="test" --pipeline-arg channel_description="test"
pipeline "create_channel" {
  title       = "Create Channel"
  description = "Create a new channel in a team."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access token to use for the request."
  }

  param "team_id" {
    type        = string
    description = "The unique identifier of the team."
  }

  param "channel_name" {
    type        = string
    description = "Channel name as it will appear to the user in Microsoft Teams."
  }

  param "channel_description" {
    type        = string
    optional    = true
    description = "Optional textual description for the channel."
  }

  step "http" "create_channel" {
    title  = "Create Channel"
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/channels"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }

    request_body = jsonencode({
      displayName = param.channel_name,
      description = param.channel_description
    })
  }

  output "channel" {
    value       = step.http.create_channel.response_body
    description = "The new channel object."
  }
}
