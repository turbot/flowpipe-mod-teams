pipeline "create_channel" {
  title       = "Create Channel"
  description = "Create a new channel in a team."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
  }

  param "team_id" {
    type        = string
    description = local.team_id_param_description
  }

  param "channel_name" {
    type        = string
    description = "Channel name as it will appear to the user in Microsoft Teams."
  }

  param "channel_description" {
    type        = string
    description = "Optional textual description for the channel."
    optional    = true
  }

  param "membership_type" {
    type        = string
    description = "The type of the channel. Can be set during creation and can't be changed. The possible values are: standard, private, unknownFutureValue, shared. The default value is standard."
    default     = "standard"
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
}
