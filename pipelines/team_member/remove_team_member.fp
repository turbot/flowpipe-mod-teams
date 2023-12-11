pipeline "remove_team_member" {
  title       = "Remove Team Member"
  description = "Remove a conversation member from a team."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "team_id" {
    type        = string
    description = local.team_id_param_description
  }

  param "team_membership_id" {
    type        = string
    description = "The unique identifier of the team membership."
  }

  step "http" "remove_team_member" {
    method = "delete"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/members/${param.team_membership_id}"

    request_headers = {
      Authorization = "Bearer ${credential.teams[param.cred].access_token}"
    }
  }
}
