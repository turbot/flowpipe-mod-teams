// usage: flowpipe pipeline run update_channel --pipeline-arg channel_id="19:561fbdbbfca848a484f0a6f00ce9dbbd@thread.tacv2" --pipeline-arg channel_description="All Hands Channel" --pipeline-arg channel_name="all-hands"
pipeline "update_channel" {
  title       = "Update Channel"
  description = "Update the properties of the specified channel."

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

  param "channel_name" {
    type        = string
    optional    = true
    description = "Channel name as it will appear to the user in Microsoft Teams."
  }

  param "channel_description" {
    type        = string
    optional    = true
    description = "Optional textual description for the channel."
  }

  step "pipeline" "get_channel" {
    pipeline = pipeline.get_channel
    args = {
      access_token = param.access_token
      team_id      = param.team_id
      channel_id   = param.channel_id
    }
  }

  step "http" "update_channel" {
    depends_on = [step.pipeline.get_channel]
    method     = "patch"
    url        = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/channels/${param.channel_id}"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }

    request_body = jsonencode({
      displayName = coalesce(param.channel_name, step.pipeline.get_channel.channel.displayName),
      description = coalesce(param.channel_description, step.pipeline.get_channel.channel.description)
    })
  }

  output "status_code" {
    value = step.http.update_channel.status_code
  }
}
