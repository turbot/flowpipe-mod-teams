// usage: flowpipe pipeline run add_team_member --pipeline-arg team_id="TEAM_ID" --pipeline-arg user_id="USER_ID" --pipeline-arg roles="['owner']"
pipeline "add_team_member" {
  title       = "Add Member to Team"
  description = "Add a new member to a team."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access token to use for the request."
  }

  param "team_id" {
    type        = string
    description = "The unique identifier for the team."
  }

  param "user_id" {
    type    = string
    default = "The unique identifier for the user."
  }

  param "roles" {
    type        = list(string)
    default     = ["member"] // or "owner" or other applicable roles
    description = "The roles for the user."
  }

  step "http" "add_team_member" {
    title  = "Add Member to Team"
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
