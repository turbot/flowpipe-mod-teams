pipeline "list_channels" {
  title       = "List Channels"
  description = "Retrieve the list of channels in this team."

  tags = {
    recommended = "true"
  }

  param "conn" {
    type        = connection.teams
    description = local.conn_param_description
    default     = connection.teams.default
  }

  param "team_id" {
    type        = string
    description = local.team_id_param_description
  }

  step "http" "list_channels" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/channels"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.conn.access_token}"
    }
  }

  output "channels" {
    description = "List of channels."
    value       = step.http.list_channels.response_body
  }
}
