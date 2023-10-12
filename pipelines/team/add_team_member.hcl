// usage: flowpipe pipeline run add_team_member --pipeline-arg team_id="TEAM_ID" --pipeline-arg user_id="USER_ID" --pipeline-arg roles="['owner']"
pipeline "add_team_member" {
  title       = "Add a team member"
  description = "Add a member to an existing team."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access access_token to use for the request."
  }

  param "team_id" {
    type    = string
    default = "fa3dfaa9-6658-43fa-be18-298b8df03d2f"
  }

  param "user_id" {
    type    = string
    default = "944a8e14-7a6f-48c6-8805-6e93612f6c2b"
  }

  param "roles" {
    type        = list(string)
    default     = ["member"] // or "owner" or other applicable roles
    description = "The roles to assign to the user."
  }

  step "http" "add_team_member" {
    title  = "Adds a member to an exisiting team"
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/members"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }

    request_body = jsonencode({
      "user@odata.bind" : "https://graph.microsoft.com/v1.0/users('${param.user_id}')"
      roles = param.roles,
    })
  }
}
