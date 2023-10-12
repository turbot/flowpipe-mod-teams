// usage: flowpipe pipeline run create_channel --pipeline-arg team_id="TEAM_ID" --pipeline-arg channel_name="test" --pipeline-arg channel_description="test"
pipeline "create_channel" {
  title       = "Create a new channel"
  description = "Create a new channel within an existing team."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access access_token to use for the request."
  }

  param "team_id" {
    type        = string
    description = "The ID of the team"
  }

  param "channel_name" {
    type        = string
    description = "The name of the channel"
  }

  param "channel_description" {
    type        = string
    default     = ""
    description = "The description of the channel"
  }

  step "http" "create_channel" {
    title  = "Creates a new channel within an existing team"
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
    value       = jsondecode(step.http.create_channel.response_body)
    description = "The created channel."
  }
}
