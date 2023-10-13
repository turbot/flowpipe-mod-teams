// usage : flowpipe pipeline run get_tag_member --pipeline-arg team_id="TEAM_ID" --pipeline-arg teamwork_tag_id="TAG_ID" --pipeline-arg teamwork_tag_member_id="TAG_MEMBER_ID"
pipeline "get_tag_member" {
  title       = "Get a Teamwork Tag Member"
  description = "Get the properties and relationships of a member of a standard tag in a team."

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

  step "http" "get_tag_member" {
    title  = "Get a Teamwork Tag Member"
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/tags/${param.teamwork_tag_id}/members/${param.teamwork_tag_member_id}"

    request_headers = {
      Authorization = "Bearer ${param.access_token}"
    }
  }

  output "tag_member" {
    value       = step.http.get_tag_member.response_body
    description = "A teamwork tag member object."
  }
}
