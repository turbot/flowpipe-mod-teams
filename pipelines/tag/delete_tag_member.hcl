pipeline "delete_tag_member" {
  description = "Delete a tag member in a team."

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

  param "teamwork_tag_member_id" {
    type = string
  }

  step "http" "delete_tag_member" {
    title  = "Deletes an existing member from a tag in a team"
    method = "delete"
    url    = "https://graph.microsoft.com/beta/teams/${param.team_id}/tags/${param.teamwork_tag_id}/members/${param.teamwork_tag_member_id}"

    request_headers = {
      Authorization = "Bearer ${param.token}"
    }
  }

  output "response_body" {
    value = step.http.delete_tag_member.response_body
  }
  output "response_headers" {
    value = step.http.delete_tag_member.response_headers
  }
  output "status_code" {
    value = step.http.delete_tag_member.status_code
  }
}
