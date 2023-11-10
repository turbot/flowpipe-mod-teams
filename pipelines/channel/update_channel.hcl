pipeline "update_channel" {
  title       = "Update Channel"
  description = "Update the properties of the specified channel."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
  }

  param "team_id" {
    type        = string
    description = local.team_id_param_description
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

  step "http" "update_channel" {
    method = "patch"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/channels/${param.channel_id}"

    request_headers = {
      "Content-Type"  = "application/json"
      "Authorization" = "Bearer ${param.access_token}"
    }

    request_body = jsonencode(merge(
      param.channel_name != null ? { displayName = param.channel_name } : {},
      param.channel_description != null ? { description = param.channel_description } : {}
    ))
  }
}
