pipeline "update_tag" {
  description = "Update a tag in a team."

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

  param "new_tag_name" {
    type = string
  }

  step "http" "update_tag" {
    title  = "Updates an existing tag in a team"
    method = "patch"
    url    = "https://graph.microsoft.com/beta/teams/${param.team_id}/tags/${param.teamwork_tag_id}"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      displayName = param.new_tag_name,
    })
  }

  output "id" {
    value = jsondecode(step.http.update_tag.response_body).id
  }
  output "display_name" {
    value = jsondecode(step.http.update_tag.response_body).displayName
  }
  output "member_count" {
    value = jsondecode(step.http.update_tag.response_body).memberCount
  }
  output "response_body" {
    value = step.http.update_tag.response_body
  }
  output "response_headers" {
    value = step.http.update_tag.response_headers
  }
  output "status_code" {
    value = step.http.update_tag.status_code
  }
}
