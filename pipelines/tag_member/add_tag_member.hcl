// usage: flowpipe pipeline add_tag_member --pipeline-arg team_id="TEAM_ID" --pipeline-arg teamwork_tag_id="TAG_ID" --pipeline-arg user_id="USER_ID"
pipeline "add_tag_member" {
  description = "Add a member to a tag in a team."

  param "token" {
    type        = string
    default     = var.token
    description = "The access token to use for the request."
  }

  param "team_id" {
    type        = string
    description = "The ID of the team"
  }

  param "teamwork_tag_id" {
    type        = string
    description = "The ID of the teamwork tag"
  }

  param "user_id" {
    type        = string
    description = "The ID of the user to add to the tag"
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
    value       = jsondecode(step.http.add_tag_member.response_body).id
    description = "The ID of the tag member"
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
