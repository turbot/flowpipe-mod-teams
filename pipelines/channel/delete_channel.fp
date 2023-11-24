pipeline "delete_channel" {
  title       = "Delete Channel"
  description = "Delete the channel."

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

  param "channel_id" {
    type        = string
    description = local.channel_id_param_description
  }

  step "http" "delete_channel" {
    method = "delete"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/channels/${param.channel_id}"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }
  }
}
