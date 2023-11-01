pipeline "test_create_team" {
  title       = "Test Create Team"
  description = "Test the create_team pipeline."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access token to use for the request."
  }

  param "team_name" {
    type        = string
    default     = "flowpipe-test-team"
    description = "The name of the team."
  }

  param "team_description" {
    type        = string
    optional    = true
    default     = "flowpipe-test-team"
    description = "Flowpipe test team."
  }

  param "visibility" {
    type        = string
    default     = "public"
    description = "The visibility of the group and team. Defaults to public"
  }

  step "pipeline" "create_team" {
    pipeline = pipeline.create_team
    args = {
      access_token     = param.access_token
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
      access_token = param.access_token
      team_id      = step.pipeline.create_team.output.team_id
    }

    # Ignore errors so we can delete
    error {
      ignore = true
    }
  }

  step "pipeline" "delete_team" {
    if         = !is_error(step.pipeline.create_team)
    depends_on = [step.pipeline.get_team]
    pipeline   = pipeline.delete_team
    args = {
      access_token = param.access_token
      team_id      = step.pipeline.create_team.output.team_id
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

  output "delete_team" {
    description = "Check for pipeline.delete_team."
    value       = !is_error(step.pipeline.delete_team) ? "pass" : "fail: ${step.pipeline.delete_team.errors}"
  }
}
