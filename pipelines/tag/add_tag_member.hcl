pipeline "add_tag_member" {
  description = "Add a member to a tag in a team."

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

  param "user_id" {
    type = string
  }

  step "http" "add_tag_member" {
    title  = "Adds a member to a tag in a team."
    method = "post"
    url    = "https://graph.microsoft.com/beta/teams/${param.team_id}/tags/${param.teamwork_tag_id}/members"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      userId = param.user_id,
    })
  }

  output "id" {
    value = jsondecode(step.http.add_tag_member.response_body).id
  }
  output "response_body" {
    value = step.http.add_tag_member.response_body
  }
  output "response_headers" {
    value = step.http.add_tag_member.response_headers
  }
  output "status_code" {
    value = step.http.add_tag_member.status_code
  }
}
