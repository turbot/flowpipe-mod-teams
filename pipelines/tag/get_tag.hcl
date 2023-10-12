// usage: flowpipe pipeline run get_tag  --pipeline-arg team_id="TEAM_ID" --pipeline-arg teamwork_tag_id="TEAMWORK_TAG_ID"
pipeline "get_tag" {
  title       = "Get a tag"
  description = "Retrieve a specific tag associated with a specific team."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access access_token to use for the request."
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
      Authorization = "Bearer ${param.access_token}"
    }
  }

  output "tag" {
    value       = jsondecode(step.http.get_tag.response_body)
    description = "The fetched tag."
  }
}
