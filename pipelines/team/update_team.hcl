
// usage: flowpipe pipeline run update_team --pipeline-arg team_id="TEAM_ID" --pipeline-arg team_membership_id="TEAM_MEMBERSHIP_ID" --pipeline-arg display_name="DISPLAY_NAME" --pipeline-arg description="DESCRIPTION"
pipeline "update_team" {
  title       = "Update Team"
  description = "Update the properties of the specified team."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access token to use for the request."
  }

  param "team_id" {
    type        = string
    description = "The unique identifier of the team."
  }

  param "display_name" {
    type        = string
    optional    = true
    description = "The name of the team."
  }

  param "description" {
    type        = string
    optional    = true
    description = "The optional description for the team."
  }

  step "http" "update_team" {
    title  = "Update Team"
    method = "patch"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }

    request_body = jsonencode({
      displayName = param.display_name,
      description = param.description
    })
  }
}
