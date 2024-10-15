pipeline "update_teamwork_tag" {
  title       = "Update Teamwork Tag"
  description = "Update the properties of a tag object."

  param "conn" {
    type        = connection.microsoft_teams
    description = local.conn_param_description
    default     = connection.microsoft_teams.default
  }

  param "team_id" {
    type        = string
    description = local.team_id_param_description
  }

  param "teamwork_tag_id" {
    type        = string
    description = local.teamwork_tag_id_param_description
  }

  param "new_tag_name" {
    type        = string
    description = "The name of the tag as it appears to the user in Microsoft Teams."
  }

  step "http" "update_teamwork_tag" {
    method = "patch"
    url    = "https://graph.microsoft.com/beta/teams/${param.team_id}/tags/${param.teamwork_tag_id}"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.conn.access_token}"
    }

    request_body = jsonencode({
      displayName = param.new_tag_name,
    })
  }

  output "teamwork_tag" {
    description = "The updated teamwork tag object."
    value       = step.http.update_teamwork_tag.response_body
  }
}
