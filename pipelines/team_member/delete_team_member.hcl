// usage: flowpipe pipeline run remove_team_member --pipeline-arg team_id="TEAM_ID" --pipeline-arg team_membership_id="TEAM_MEMBERSHIP_ID"
pipeline "remove_team_member" {
  title       = "Remove Member from Team"
  description = "Remove a member from a team."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access token to use for the request."
  }

  param "team_id" {
    type        = string
    description = "The unique identifier of the team."
  }

  param "team_membership_id" {
    type        = string
    description = "The unique identifier of the team membership."
  }

  step "http" "remove_team_member" {
    title  = "Remove Member from Team"
    method = "delete"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/members/${param.team_membership_id}"

    request_headers = {
      Authorization = "Bearer ${param.access_token}"
    }
  }
}
