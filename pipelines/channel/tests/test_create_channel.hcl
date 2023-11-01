pipeline "test_create_channel" {
  title       = "Test Create Channel"
  description = "Test the create_channel pipeline."

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

  param "channel_name" {
    type        = string
    default     = "fp-channel-${uuid()}"
    description = "The name of the channel."
  }

  param "channel_description" {
    type        = string
    optional    = true
    default     = "flowpipe-test-channel"
    description = "Flowpipe test channel."
  }

  param "membership_type" {
    type        = string
    default     = "standard"
    description = "The type of the channel. The possible values are: standard, private, unknownFutureValue, shared. The default value is standard."
  }

  step "pipeline" "create_channel" {
    pipeline = pipeline.create_channel
    args = {
      access_token        = param.access_token
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
    if       = !is_error(step.pipeline.create_channel)
    depends_on = [step.sleep.wait_for_create_complete]

    pipeline = pipeline.get_channel
    args = {
      access_token = param.access_token
      team_id      = param.team_id
      channel_id   = step.pipeline.create_channel.output.channel.id
    }

    # Ignore errors so we can delete
    error {
      ignore = true
    }
  }

  step "pipeline" "delete_channel" {
    if       = !is_error(step.pipeline.create_channel)
    depends_on = [step.pipeline.get_channel]
    pipeline   = pipeline.delete_channel
    args = {
      access_token = param.access_token
      team_id      = var.team_id
      channel_id   = step.pipeline.create_channel.output.channel.id
    }
  }

  output "create_channel" {
    description = "Check for pipeline.create_channel."
    value       = !is_error(step.pipeline.create_channel) ? "pass" : "fail: ${step.pipeline.create_channel.errors[0].error.detail}"
  }

  output "get_channel" {
    description = "Check for pipeline.get_channel."
    value       = !is_error(step.pipeline.get_channel) ? "pass" : "fail: ${step.pipeline.get_channel.errors[0].error.detail}"
  }

  output "delete_channel" {
    description = "Check for pipeline.delete_channel."
    value       = !is_error(step.pipeline.delete_channel) ? "pass" : "fail: ${step.pipeline.delete_channel.errors[0].error.detail}"
  }
}
