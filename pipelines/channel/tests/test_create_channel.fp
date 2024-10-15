pipeline "test_create_channel" {
  title       = "Test Create Channel"
  description = "Test the create_channel pipeline."

  tags = {
    type = "test"
  }

  param "conn" {
    type        = connection.microsoft_teams
    description = local.conn_param_description
    default     = connection.microsoft_teams.default
  }

  param "team_id" {
    type        = string
    description = "The unique identifier of the team."
  }

  param "channel_name" {
    type        = string
    description = "The name of the channel."
    default     = "fp-channel-${uuid()}"
  }

  param "channel_description" {
    type        = string
    description = "Flowpipe test channel."
    default     = "flowpipe-test-channel"
    optional    = true
  }

  param "membership_type" {
    type        = string
    description = "The type of the channel. The possible values are: standard, private, unknownFutureValue, shared. The default value is standard."
    default     = "standard"
  }

  step "pipeline" "create_channel" {
    pipeline = pipeline.create_channel
    args = {
      conn                = param.conn
      team_id             = param.team_id
      channel_name        = param.channel_name
      channel_description = param.channel_description
      membership_type     = param.membership_type
    }
  }

  step "sleep" "wait_for_create_complete" {
    depends_on = [step.pipeline.create_channel]
    duration   = "10s"
  }

  step "pipeline" "get_channel" {
    if         = !is_error(step.pipeline.create_channel)
    depends_on = [step.sleep.wait_for_create_complete]

    pipeline = pipeline.get_channel
    args = {
      conn       = param.conn
      team_id    = param.team_id
      channel_id = step.pipeline.create_channel.output.channel.id
    }

    # Ignore errors so we can delete
    error {
      ignore = true
    }
  }

  step "pipeline" "delete_channel" {
    if         = !is_error(step.pipeline.create_channel)
    depends_on = [step.pipeline.get_channel]
    pipeline   = pipeline.delete_channel
    args = {
      conn       = param.conn
      team_id    = param.team_id
      channel_id = step.pipeline.create_channel.output.channel.id
    }
  }

  output "create_channel" {
    description = "Check for pipeline.create_channel."
    value       = !is_error(step.pipeline.create_channel) ? "pass" : "fail: ${step.pipeline.create_channel.errors}"
  }

  output "get_channel" {
    description = "Check for pipeline.get_channel."
    value       = !is_error(step.pipeline.get_channel) ? "pass" : "fail: ${step.pipeline.get_channel.errors}"
  }

  output "delete_channel" {
    description = "Check for pipeline.delete_channel."
    value       = !is_error(step.pipeline.delete_channel) ? "pass" : "fail: ${step.pipeline.delete_channel.errors}"
  }
}
