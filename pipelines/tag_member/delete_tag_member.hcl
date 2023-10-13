// usage: flowpipe pipeline delete_tag_member --pipeline-arg team_id="TEAM_ID" --pipeline-arg teamwork_tag_id="TAG_ID" --pipeline-arg teamwork_tag_member_id="TAG_MEMBER_ID"
pipeline "delete_tag_member" {
  title       = "Delete a Teamwork Tag Member"
  description = "Delete a member from a standard tag in a team."

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

  param "teamwork_tag_member_id" {
    type        = string
    description = "The unique identifier for the member."
  }

  step "http" "delete_tag_member" {
    title  = "Delete a Teamwork Tag Member"
    method = "delete"
    url    = "https://graph.microsoft.com/beta/teams/${param.team_id}/tags/${param.teamwork_tag_id}/members/${param.teamwork_tag_member_id}"

    request_headers = {
      Authorization = "Bearer ${param.access_token}"
    }
  }
}
