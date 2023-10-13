// usage: flowpipe pipeline run get_tag  --pipeline-arg team_id="TEAM_ID" --pipeline-arg teamwork_tag_id="TEAMWORK_TAG_ID"
pipeline "get_tag" {
  title       = "Get a Teamwork Tag"
  description = "Read the properties and relationships of a tag object."

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

  step "http" "get_tag" {
    title  = "Get Teamwork Tag"
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/tags/${param.teamwork_tag_id}"

    request_headers = {
      Authorization = "Bearer ${param.access_token}"
    }
  }

  output "tag" {
    value       = step.http.get_tag.response_body
    description = "The teamwork tag object."
  }
}
