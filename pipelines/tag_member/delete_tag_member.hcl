// usage: flowpipe pipeline delete_tag_member --pipeline-arg team_id="TEAM_ID" --pipeline-arg teamwork_tag_id="TAG_ID" --pipeline-arg teamwork_tag_member_id="TAG_MEMBER_ID"
pipeline "delete_tag_member" {
  description = "Delete a tag member in a team."

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

  param "teamwork_tag_member_id" {
    type        = string
    description = "The ID of the teamwork tag member"
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
