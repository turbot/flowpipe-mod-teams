pipeline "update_channel" {
  title       = "Update Channel"
  description = "Update the properties of the specified channel."

  param "conn" {
    type        = connection.microsoft_teams
    description = local.conn_param_description
    default     = connection.microsoft_teams.default
  }

  param "team_id" {
    type        = string
    description = local.team_id_param_description
  }

  param "channel_id" {
    type        = string
    description = local.channel_id_param_description
  }

  param "channel_name" {
    type        = string
    description = local.channel_name_param_description
    optional    = true

  }

  param "channel_description" {
    type        = string
    description = local.channel_description_param_description
    optional    = true
  }

  step "http" "update_channel" {
    method = "patch"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/channels/${param.channel_id}"

    request_headers = {
      "Content-Type" = "application/json"
      Authorization  = "Bearer ${param.conn.access_token}"
    }

    request_body = jsonencode(merge(
      param.channel_name != null ? { displayName = param.channel_name } : {},
      param.channel_description != null ? { description = param.channel_description } : {}
    ))
  }
}
