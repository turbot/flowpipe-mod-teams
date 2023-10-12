// usage: flowpipe pipeline add_tag_member --pipeline-arg team_id="TEAM_ID" --pipeline-arg teamwork_tag_id="TAG_ID" --pipeline-arg user_id="USER_ID"
pipeline "add_tag_member" {
  title       = "Add Tag Member"
  description = "Add a member to a tag in a team."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access_token to use for the request."
  }

  param "team_id" {
    type        = string
    description = "The ID of the team."
  }

  param "teamwork_tag_id" {
    type        = string
    description = "The ID of the teamwork tag."
  }

  param "user_id" {
    type        = string
    description = "The ID of the user to add to the tag."
  }

  step "http" "add_tag_member" {
    title  = "Add Tag Member"
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
    description = "The added tag member."
  }
}
