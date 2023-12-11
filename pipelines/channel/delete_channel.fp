pipeline "delete_channel" {
  title       = "Delete Channel"
  description = "Delete the channel."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
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
      Authorization = "Bearer ${credential.teams[param.cred].access_token}"
    }
  }
}
