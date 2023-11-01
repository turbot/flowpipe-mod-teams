// usage: flowpipe pipeline run delete_team --pipeline-arg team_id="9b68a1x9-ab01-5678-1234-956f2846aab4"
pipeline "delete_team" {
  title       = "Delete Team"
  description = "Delete a new team."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access token to use for the request."
  }

  param "team_id" {
    type        = string
    default     = var.team_id
    description = "The unique identifier of the team."
  }

  step "http" "delete_team" {
    method = "delete"
    url    = "https://graph.microsoft.com/v1.0/groups/${param.team_id}"

    request_headers = {
      Content-Type  = "application/json"
      cache-control = "no-cache"
      Authorization = "Bearer ${param.access_token}"
    }
  }
}
