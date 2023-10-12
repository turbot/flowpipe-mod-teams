
// usage: flowpipe pipeline run update_team --pipeline-arg team_id="TEAM_ID" --pipeline-arg team_membership_id="TEAM_MEMBERSHIP_ID" --pipeline-arg display_name="DISPLAY_NAME" --pipeline-arg description="DESCRIPTION"
pipeline "update_team" {
  title       = "Update Team"
  description = "Update the properties of an existing team."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access access_token to use for the request."
  }

  param "team_id" {
    type        = string
    description = "The ID of the team"
  }

  param "display_name" {
    type        = string
    default     = ""
    description = "The display name of the team"
  }

  param "description" {
    type        = string
    default     = ""
    description = "The description of the team"
  }

  step "http" "update_team" {
    title  = "Updates the properties of an existing team"
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
