// usage : flowpipe pipeline run list_tags --pipeline-arg team_id="TEAM_ID"
pipeline "list_tags" {
  description = "Retrieve a list of tags associated with a specific team."

  param "token" {
    type        = string
    default     = var.token
    description = "The access token to use for the request."
  }

  param "team_id" {
    type        = string
    description = "The ID of the team"
  }

  step "http" "list_tags" {
    title  = "Retrieves a list of tags associated with a specific team"
    method = "get"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/tags/"

    request_headers = {
      Authorization = "Bearer ${param.token}"
    }
  }

  output "tags" {
    value       = jsondecode(step.http.list_tags.response_body).value
    description = "The list of tags associated with the team"
  }
  output "response_headers" {
    value = step.http.list_tags.response_headers
  }
  output "status_code" {
    value = step.http.list_tags.status_code
  }
}
