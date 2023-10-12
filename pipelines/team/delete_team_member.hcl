// usage: flowpipe pipeline run delete_team_member --pipeline-arg team_id="TEAM_ID" --pipeline-arg team_membership_id="TEAM_MEMBERSHIP_ID"
pipeline "delete_team_member" {
  description = "Delete a member from an existing team."

  param "token" {
    type        = string
    default     = var.token
    description = "The access token to use for the request."
  }

  param "team_id" {
    type        = string
    description = "The ID of the team"
  }

  param "team_membership_id" {
    type        = string
    description = "The ID of the team membership"
  }

  step "http" "delete_team_member" {
    title  = "Deletes a member from an exisiting team"
    method = "delete"
    url    = "https://graph.microsoft.com/v1.0/teams/${param.team_id}/members/${param.team_membership_id}"

    request_headers = {
      Authorization = "Bearer ${param.token}"
    }
  }

  output "response_body" {
    value = step.http.delete_team_member.response_body
  }
  output "response_headers" {
    value = step.http.delete_team_member.response_headers
  }
  output "status_code" {
    value = step.http.delete_team_member.status_code
  }
}
