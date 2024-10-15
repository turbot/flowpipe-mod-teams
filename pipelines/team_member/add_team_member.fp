pipeline "add_team_member" {
  title       = "Add Team Member"
  description = "Add a new conversation member to a team."

  param "conn" {
    type        = connection.teams
    description = local.conn_param_description
    default     = connection.teams.default
  }

  param "team_id" {
    type        = string
    description = local.team_id_param_description
  }

  param "user_id" {
    type        = string
    description = local.user_id_param_description
  }

  param "roles" {
    type        = list(string)
    default     = ["member"] # or "owner" or other applicable roles
    description = "The roles for the user."
  }

  step "http" "add_team_member" {
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/members"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.conn.access_token}"
    }

    request_body = jsonencode({
      "@odata.type"     = "#microsoft.graph.aadUserConversationMember",
      "user@odata.bind" = "https://graph.microsoft.com/v1.0/users('${param.user_id}')",
      "roles"           = param.roles
    })
  }
}
