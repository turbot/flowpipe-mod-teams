// usage: flowpipe pipeline run update_team --pipeline-arg team_id="9b68a1x9-ab01-5678-1234-956f2846aab4" --pipeline-arg team_description="Updated description for team"  --pipeline-arg visibility="private"
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
    default     = var.team_id
    description = "The unique identifier of the team."
  }

  param "team_name" {
    type        = string
    optional    = true
    description = "The name of the team."
  }

  param "team_description" {
    type        = string
    optional    = true
    description = "The optional description for the team."
  }

  param "visibility" {
    type        = string
    optional    = true
    description = "The visibility of the group and team. Defaults to public"
  }

  step "pipeline" "get_team" {
    pipeline = pipeline.get_team
    args = {
      access_token = param.access_token
      team_id      = param.team_id
    }
  }

  step "http" "update_team" {
    depends_on = [step.pipeline.get_team]
    method     = "patch"
    url        = "https://graph.microsoft.com/v1.0/teams/${param.team_id}"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }

    // If the optional params are not passed then retain the original value from the get_team call, otherwise it passes these fields as null
    request_body = jsonencode({
      displayName = coalesce(param.team_name, step.pipeline.get_team.output.team.displayName)
      description = coalesce(param.team_description, step.pipeline.get_team.output.team.description)
      visibility  = coalesce(param.visibility, step.pipeline.get_team.output.team.visibility)
    })
  }
}
