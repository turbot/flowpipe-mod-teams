pipeline "delete_tag" {
  description = "Delete a tag in a team."

  param "token" {
    type    = string
    default = var.token
  }

  param "team_id" {
    type = string
  }

  param "teamwork_tag_id" {
    type = string
  }

  step "http" "delete_tag" {
    title  = "Deletes an existing tag in a team"
    method = "delete"
    url    = "https://graph.microsoft.com/beta/teams/${param.team_id}/tags/${param.teamwork_tag_id}"

    request_headers = {
      Authorization = "Bearer ${param.token}"
    }
  }

  output "response_body" {
    value = step.http.delete_tag.response_body
  }
  output "response_headers" {
    value = step.http.delete_tag.response_headers
  }
  output "status_code" {
    value = step.http.delete_tag.status_code
  }
}
