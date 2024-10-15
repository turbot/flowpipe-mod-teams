pipeline "get_channel" {
  title       = "Get Channel"
  description = "Retrieve the properties and relationships of a channel."

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

  step "http" "get_channel" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/channels/${param.channel_id}"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.conn.access_token}"
    }
  }

  output "channel" {
    description = "The channel object."
    value       = step.http.get_channel.response_body
  }
}
