// usage : flowpipe pipeline run list_tag_members  --pipeline-arg team_id="TEAM_D" --pipeline-arg teamwork_tag_id="TAG_D" 
pipeline "list_tag_members" {
  description = "Retrieve a list of members associated with a specific tag."

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

  step "http" "list_tag_members" {
    title  = "Retrieves a list of members associated with a specific tag"
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/tags/${param.teamwork_tag_id}/members"

    request_headers = {
      Authorization = "Bearer ${param.token}"
    }
  }

  output "members" {
    value       = jsondecode(step.http.list_tag_members.response_body).value
    description = "The members associated with the tag"
  }
  output "response_headers" {
    value = step.http.list_tag_members.response_headers
  }
  output "status_code" {
    value = step.http.list_tag_members.status_code
  }
}
