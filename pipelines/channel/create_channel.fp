pipeline "create_channel" {
  title       = "Create Channel"
  description = "Create a new channel in a team."

  param "conn" {
    type        = connection.microsoft_teams
    description = local.conn_param_description
    default     = connection.microsoft_teams.default
  }

  param "team_id" {
    type        = string
    description = local.team_id_param_description
  }

  param "channel_name" {
    type        = string
    description = local.channel_name_param_description
  }

  param "channel_description" {
    type        = string
    description = local.channel_description_param_description
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
      Authorization = "Bearer ${param.conn.access_token}"
    }

    request_body = jsonencode({
      displayName    = param.channel_name
      description    = param.channel_description
      membershipType = param.membership_type
    })
  }

  output "channel" {
    description = "The created channel."
    value       = step.http.create_channel.response_body
  }
}
