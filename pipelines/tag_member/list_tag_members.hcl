// usage : flowpipe pipeline run list_tag_members  --pipeline-arg team_id="TEAM_D" --pipeline-arg teamwork_tag_id="TAG_D" 
pipeline "list_tag_members" {
  title       = "List Members in a Teamwork Tag"
  description = "Get a list of the members of a standard tag in a team and their properties."

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

  step "http" "list_tag_members" {
    title  = "List Members in a Teamwork Tag"
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/tags/${param.teamwork_tag_id}/members"

    request_headers = {
      Authorization = "Bearer ${param.access_token}"
    }
  }

  output "tag_members" {
    value       = jsondecode(step.http.list_tag_members.response_body).value
    description = "A collection of teamwork tag member object."
  }
}
