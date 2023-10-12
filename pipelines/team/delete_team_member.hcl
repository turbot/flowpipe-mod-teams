// usage: flowpipe pipeline run delete_team_member --pipeline-arg team_id="TEAM_ID" --pipeline-arg team_membership_id="TEAM_MEMBERSHIP_ID"
pipeline "delete_team_member" {
  title       = "Delete Team Member"
  description = "Delete a member from an existing team."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access_token to use for the request."
  }

  param "team_id" {
    type        = string
    description = "The ID of the team."
  }

  param "team_membership_id" {
    type        = string
    description = "The ID of the team membership."
  }

  step "http" "delete_team_member" {
    title  = "Delete Team Member"
    method = "delete"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/members/${param.team_membership_id}"

    request_headers = {
      Authorization = "Bearer ${param.access_token}"
    }
  }
}
