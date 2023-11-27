pipeline "list_channels" {
  title       = "List Channels"
  description = "Retrieve the list of channels in this team."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
  }

  param "team_id" {
    type        = string
    description = local.team_id_param_description
    default     = var.team_id
  }

  step "http" "list_channels" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/channels"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }
  }

  output "channels" {
    value       = step.http.list_channels.response_body
    description = "List of channels."
  }
}
