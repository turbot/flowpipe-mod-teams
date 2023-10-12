// usage : flowpipe pipeline run get_tag_member --pipeline-arg team_id="TEAM_ID" --pipeline-arg teamwork_tag_id="TAG_ID" --pipeline-arg teamwork_tag_member_id="TAG_MEMBER_ID"
pipeline "get_tag_member" {
  description = "Retrieve a specific member associated with a specific tag."

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

  step "http" "get_tag_member" {
    title  = "Retrieves a specific member associated with a specific tag"
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/tags/${param.teamwork_tag_id}/members/${param.teamwork_tag_member_id}"

    request_headers = {
      Authorization = "Bearer ${param.token}"
    }
  }

  output "id" {
    value       = jsondecode(step.http.get_tag_member.response_body).id
    description = "The ID of the tag member"
  }
  output "display_name" {
    value       = jsondecode(step.http.get_tag_member.response_body).displayName
    description = "The display name of the tag member"
  }
  output "user_id" {
    value       = jsondecode(step.http.get_tag_member.response_body).userId
    description = "The ID of the user associated with the tag member"
  }
  output "response_body" {
    value = step.http.get_tag_member.response_body
  }
  output "response_headers" {
    value = step.http.get_tag_member.response_headers
  }
  output "status_code" {
    value = step.http.get_tag_member.status_code
  }
}
