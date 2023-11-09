pipeline "get_channel" {
  title       = "Get Channel"
  description = "Get the properties of a specific channel in the team."

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

  step "http" "get_channel" {
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/channels/${param.channel_id}"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }
  }

  output "channel" {
    value       = step.http.get_channel.response_body
    description = "Channel details."
  }
}
