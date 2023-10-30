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
      team_name        = param.team_name
      team_description = param.team_description
      visibility       = param.visibility
    }
  }

  step "sleep" "wait_for_create_complete" {
    depends_on = [step.pipeline.create_team]
    duration   = "20s"
  }

  step "pipeline" "get_team" {
    if         = step.pipeline.create_team.status_code == 202
    depends_on = [step.sleep.wait_for_create_complete]

    pipeline = pipeline.get_team
    args = {
      access_token = param.access_token
      team_id      = step.pipeline.create_team.team_id
    }

    # Ignore errors so we can delete
    error {
      ignore = true
    }
  }

  step "pipeline" "delete_team" {
    if         = step.pipeline.create_team.status_code == 202
    depends_on = [step.pipeline.get_team]
    pipeline   = pipeline.delete_team
    args = {
      access_token = param.access_token
      team_id      = step.pipeline.create_team.team_id
    }
  }

  output "create_team" {
    description = "Check for pipeline.create_team."
    value       = step.pipeline.create_team.status_code == 202 ? "pass" : "fail: ${step.pipeline.create_team.status_code}"
  }

  output "get_team" {
    description = "Check for pipeline.get_team."
    value       = step.pipeline.get_team.status_code == 200 ? "pass" : "fail: ${step.pipeline.get_team.status_code}"
  }

  output "delete_team" {
    description = "Check for pipeline.delete_team."
    value       = step.pipeline.delete_team.status_code == 204 ? "pass" : "fail: ${step.pipeline.delete_team.status_code}"
  }
}
