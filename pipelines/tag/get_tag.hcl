// usage: flowpipe pipeline run get_tag  --pipeline-arg team_id="TEAM_ID" --pipeline-arg teamwork_tag_id="TEAMWORK_TAG_ID"
pipeline "get_tag" {
  description = "Retrieve a specific tag associated with a specific team."

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

  step "http" "get_tag" {
    title  = "Retrieves a specific tag associated with a specific team"
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/tags/${param.teamwork_tag_id}"

    request_headers = {
      Authorization = "Bearer ${param.token}"
    }
  }

  output "id" {
    value       = jsondecode(step.http.get_tag.response_body).id
    description = "The ID of the tag"
  }
  output "display_name" {
    value       = jsondecode(step.http.get_tag.response_body).displayName
    description = "The display name of the tag"
  }
  output "member_count" {
    value       = jsondecode(step.http.get_tag.response_body).memberCount
    description = "The number of members in the tag"
  }
  output "response_body" {
    value = step.http.get_tag.response_body
  }
  output "response_headers" {
    value = step.http.get_tag.response_headers
  }
  output "status_code" {
    value = step.http.get_tag.status_code
  }
}
