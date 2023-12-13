pipeline "delete_channel_message" {
  title       = "Delete Channel Message"
  description = "Delete a single chat message in a channel."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "team_id" {
    type        = string
    description = local.team_id_param_description
  }

  param "channel_id" {
    type        = string
    description = local.channel_id_param_description
  }

  param "message_id" {
    type        = string
    description = local.message_id_param_description
  }

  step "http" "delete_channel_message" {
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/channels/${param.channel_id}/messages/${param.message_id}/softDelete"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${credential.teams[param.cred].access_token}"
    }
  }
}
