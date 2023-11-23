pipeline "add_team_member" {
  title       = "Add Team Member"
  description = "Add a new conversation member to a team."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
  }

  param "team_id" {
    type        = string
    description = local.team_id_param_description
  }

  param "user_id" {
    type        = string
    description = "The unique identifier for the user."
  }

  param "roles" {
    type        = list(string)
    default     = ["member"] // or "owner" or other applicable roles
    description = "The roles for the user."
  }

  step "http" "add_team_member" {
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/members"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }

    request_body = jsonencode({
      "@odata.type"     = "#microsoft.graph.aadUserConversationMember",
      "user@odata.bind" = "https://graph.microsoft.com/v1.0/users('${param.user_id}')",
      "roles"           = param.roles
    })
  }
}
