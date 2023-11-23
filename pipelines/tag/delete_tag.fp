pipeline "delete_tag" {
  title       = "Delete a Teamwork Tag"
  description = "Delete a tag object permanently."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
  }

  param "team_id" {
    type        = string
    description = local.team_id_param_description
  }

  param "teamwork_tag_id" {
    type        = string
    description = "The unique identifier for the tag."
  }

  step "http" "delete_tag" {
    title  = "Delete a Teamwork Tag"
    method = "delete"
    url    = "https://graph.microsoft.com/beta/teams/${param.team_id}/tags/${param.teamwork_tag_id}"

    request_headers = {
      Authorization = "Bearer ${param.access_token}"
    }
  }
}
