pipeline "delete_tag_member" {
  title       = "Delete Teamwork Tag Member"
  description = "Delete a member from a standard tag in a team."

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

  param "teamwork_tag_id" {
    type        = string
    description = local.teamwork_tag_id_param_description
  }

  param "teamwork_tag_member_id" {
    type        = string
    description = "The unique identifier for the member."
  }

  step "http" "delete_tag_member" {
    method = "delete"
    url    = "https://graph.microsoft.com/beta/teams/${param.team_id}/tags/${param.teamwork_tag_id}/members/${param.teamwork_tag_member_id}"

    request_headers = {
      Authorization = "Bearer ${param.access_token}"
    }
  }
}
