// usage : flowpipe pipeline run list_tag_members  --pipeline-arg team_id="TEAM_D" --pipeline-arg teamwork_tag_id="TAG_D" 
pipeline "list_tag_members" {
  title       = "List Tag Members"
  description = "Retrieve a list of members associated with a specific tag."

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

  step "http" "list_tag_members" {
    title  = "List Tag Members"
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/tags/${param.teamwork_tag_id}/members"

    request_headers = {
      Authorization = "Bearer ${param.access_token}"
    }
  }

  output "tag_members" {
    value       = jsondecode(step.http.list_tag_members.response_body).value
    description = "The members associated with the tag."
  }
}
