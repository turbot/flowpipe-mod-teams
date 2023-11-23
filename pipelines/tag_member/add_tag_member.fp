pipeline "add_tag_member" {
  title       = "Add a Teamwork Tag Member"
  description = "Create a new teamwork tag member object in a team."

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

  param "user_id" {
    type        = string
    description = "The unique identifier for the user to add to the tag."
  }

  step "http" "add_tag_member" {
    title  = "Add a Teamwork Tag Member"
    method = "post"
    url    = "https://graph.microsoft.com/beta/teams/${param.team_id}/tags/${param.teamwork_tag_id}/members"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }

    request_body = jsonencode({
      userId = param.user_id,
    })
  }

  output "tag_member" {
    value       = step.http.add_tag_member.response_body
    description = "A teamwork tag member object."
  }
}
