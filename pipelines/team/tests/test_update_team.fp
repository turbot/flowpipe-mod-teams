pipeline "test_update_team" {
  title       = "Test Update Team"
  description = "Test the update_team pipeline."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
  }

  param "team_name" {
    type        = string
    description = local.team_name_param_description
    default     = "flowpipe-mod-test-team"
  }

  param "team_description" {
    type        = string
    description = "Flowpipe test team."
    optional    = true
    default     = "flowpipe-mod-test-team"
  }

  param "visibility" {
    type        = string
    description = "The visibility of the group and team."
    default     = "private"
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

  // Updating the visibility from private to public
  step "pipeline" "update_team" {
    if         = !is_error(step.pipeline.create_team)
    depends_on = [step.sleep.wait_for_create_complete]
    pipeline   = pipeline.update_team

    args = {
      access_token     = param.access_token
      team_description = param.team_description
      team_id          = step.pipeline.create_team.output.team_id
      team_name        = param.team_name
      visibility       = "public"
    }
  }

  step "sleep" "wait_for_update_complete" {
    depends_on = [step.pipeline.update_team]
    duration   = "10s"
  }

  step "pipeline" "get_team" {
    if         = !is_error(step.pipeline.update_team)
    depends_on = [step.sleep.wait_for_update_complete]
    pipeline   = pipeline.get_team
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

  output "update_team" {
    description = "Check for pipeline.update_team."
    value       = !is_error(step.pipeline.update_team) ? "pass" : "fail: ${step.pipeline.update_team.errors}"
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
