pipeline "update_team" {
  title       = "Update Team"
  description = "Update the properties of the specified team."

  param "conn" {
    type        = connection.teams
    description = local.conn_param_description
    default     = connection.teams.default
  }

  param "team_id" {
    type        = string
    description = local.team_id_param_description
  }

  param "team_name" {
    type        = string
    description = local.team_name_param_description
    optional    = true
  }

  param "team_description" {
    type        = string
    description = "The optional description for the team."
    optional    = true
  }

  param "visibility" {
    type        = string
    description = "The visibility of the group and team. Defaults to public"
    optional    = true
  }

  step "pipeline" "get_team" {
    pipeline = pipeline.get_team
    args = {
      conn    = param.conn
      team_id = param.team_id
    }
  }

  step "http" "update_team" {
    depends_on = [step.pipeline.get_team]
    method     = "patch"
    url        = "https://graph.microsoft.com/v1.0/teams/${param.team_id}"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.conn.access_token}"
    }

    # If the optional params are not passed then retain the original value from the get_team call, otherwise it passes these fields as null
    request_body = jsonencode({
      displayName = coalesce(param.team_name, step.pipeline.get_team.output.team.displayName)
      description = coalesce(param.team_description, step.pipeline.get_team.output.team.description)
      visibility  = coalesce(param.visibility, step.pipeline.get_team.output.team.visibility)
    })
  }
}
