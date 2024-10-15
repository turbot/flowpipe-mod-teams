pipeline "test_create_team" {
  title       = "Test Create Team"
  description = "Test the create_team pipeline."

  tags = {
    type = "test"
  }

  param "conn" {
    type        = connection.microsoft_teams
    description = local.conn_param_description
    default     = connection.microsoft_teams.default
  }

  param "team_name" {
    type        = string
    description = local.team_name_param_description
    default     = "flowpipe-test-team"
  }

  param "team_description" {
    type        = string
    optional    = true
    default     = "flowpipe-test-team"
    description = "Flowpipe test team."
  }

  param "visibility" {
    type        = string
    description = "The visibility of the group and team. Defaults to public"
    default     = "public"
  }

  step "pipeline" "create_team" {
    pipeline = pipeline.create_team
    args = {
      conn             = param.conn
      team_description = param.team_description
      team_name        = param.team_name
      visibility       = param.visibility
    }
  }

  step "sleep" "wait_for_create_complete" {
    depends_on = [step.pipeline.create_team]
    duration   = "10s"
  }

  step "pipeline" "get_team" {
    if         = !is_error(step.pipeline.create_team)
    depends_on = [step.sleep.wait_for_create_complete]

    pipeline = pipeline.get_team
    args = {
      conn    = param.conn
      team_id = step.pipeline.create_team.output.team_id
    }

    # Ignore errors so we can delete
    error {
      ignore = true
    }
  }

  step "pipeline" "delete_group" {
    if         = !is_error(step.pipeline.create_team)
    depends_on = [step.pipeline.get_team]
    pipeline   = pipeline.delete_group
    args = {
      conn    = param.conn
      team_id = step.pipeline.create_team.output.team_id
    }
  }

  output "create_team" {
    description = "Check for pipeline.create_team."
    value       = !is_error(step.pipeline.create_team) ? "pass" : "fail: ${step.pipeline.create_team.errors}"
  }

  output "get_team" {
    description = "Check for pipeline.get_team."
    value       = !is_error(step.pipeline.get_team) ? "pass" : "fail: ${step.pipeline.get_team.errors}"
  }

  output "delete_group" {
    description = "Check for pipeline.delete_group."
    value       = !is_error(step.pipeline.delete_group) ? "pass" : "fail: ${step.pipeline.delete_group.errors}"
  }
}
