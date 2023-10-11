pipeline "create_tag" {
  description = "Create a new tag in a team."

  param "token" {
    type    = string
    default = var.token
  }

  param "team_id" {
    type = string
  }

  param "tag_name" {
    type = string
  }

  ## Members of the tag: Required
  param "user_id" {
    type = string
  }

  step "http" "create_tag" {
    title  = "Create a new tag in a team"
    method = "post"
    url    = "https://graph.microsoft.com/beta/teams/${param.team_id}/tags"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      displayName = param.tag_name,
      members = [{
        userId = param.user_id,
      }],
    })
  }

  output "id" {
    value = jsondecode(step.http.create_tag.response_body).id
  }
  output "member_count" {
    value = jsondecode(step.http.create_tag.response_body).memberCount
  }
  output "response_body" {
    value = step.http.create_tag.response_body
  }
  output "response_headers" {
    value = step.http.create_tag.response_headers
  }
  output "status_code" {
    value = step.http.create_tag.status_code
  }
}
