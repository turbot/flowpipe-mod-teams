// usage: flowpipe pipeline run create_channel --pipeline-arg team_id="9b68a1x9-ab01-5678-1234-956f2846aab4" --pipeline-arg channel_name="random" --pipeline-arg channel_description="test"
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
    default     = var.team_id
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

  param "membership_type" {
    type        = string
    default     = "standard"
    description = "The type of the channel. Can be set during creation and can't be changed. The possible values are: standard, private, unknownFutureValue, shared. The default value is standard."
  }

  step "http" "create_channel" {
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/channels"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }

    request_body = jsonencode({
      displayName    = param.channel_name
      description    = param.channel_description
      membershipType = param.membership_type
    })
  }

  output "channel" {
    value       = step.http.create_channel.response_body
    description = "Channel details."
  }

  output "channel_id" {
    value       = step.http.create_channel.response_body.id
    description = "Channel details."
  }

  output "status_code" {
    value = step.http.create_channel.status_code
  }
}
