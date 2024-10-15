pipeline "update_channel_message" {
  title       = "Update Channel Message"
  description = "Update a chat message in a channel."

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

  param "message" {
    type        = string
    description = "The updated message to send."
  }

  param "message_id" {
    type        = string
    description = local.message_id_param_description
  }

  step "http" "update_channel_message" {
    method = "patch"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/channels/${param.channel_id}/messages/${param.message_id}"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.conn.access_token}"
    }

    request_body = jsonencode({
      body = {
        content = param.message
      }
    })
  }
}
