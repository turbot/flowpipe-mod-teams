// usage: flowpipe pipeline add_tag_member --pipeline-arg team_id="TEAM_ID" --pipeline-arg teamwork_tag_id="TAG_ID" --pipeline-arg user_id="USER_ID"
pipeline "add_tag_member" {
  title       = "Add a Teamwork Tag Member"
  description = "Create a new teamwork tag member object in a team."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access token to use for the request."
  }

  param "team_id" {
    type        = string
    description = "The unique identifier of the team."
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
