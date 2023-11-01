pipeline "test_update_channel" {
  title       = "Test Update Channel"
  description = "Test the update_channel pipeline."

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
      channel_description = param.channel_description
      channel_name        = param.channel_name
      membership_type     = param.membership_type
      team_id             = param.team_id
    }
  }

  step "sleep" "wait_for_create_complete" {
    depends_on = [step.pipeline.create_channel]
    duration   = "20s"
  }

  // Update the displayName of the channel from "fp-channel-${uuid()}" to "test-update-channel"
  step "pipeline" "update_channel" {
    if       = !is_error(step.pipeline.create_channel)
    depends_on = [step.sleep.wait_for_create_complete]
    pipeline   = pipeline.update_channel

    args = {
      access_token        = param.access_token
      channel_description = "flowpipe-channel-updated-description"
      channel_id   = step.pipeline.create_channel.output.channel.id
      channel_name        = "flowpipe-update-channel"
      team_id             = param.team_id
    }

    # Ignore errors so we can delete
    error {
      ignore = true
    }
  }

  step "sleep" "wait_for_update_complete" {
    depends_on = [step.pipeline.update_channel]
    duration   = "10s"
  }

  step "pipeline" "get_channel" {
    if       = !is_error(step.pipeline.update_channel)
    depends_on = [step.sleep.wait_for_update_complete]

    pipeline = pipeline.get_channel
    args = {
      access_token = param.access_token
      channel_id   = step.pipeline.create_channel.output.channel.id
      team_id      = param.team_id
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
      channel_id   = step.pipeline.create_channel.output.channel.id
      team_id      = var.team_id
    }
  }

  output "create_channel" {
    description = "Check for pipeline.create_channel."
    value       = !is_error(step.pipeline.create_channel) ? "pass" : "fail: ${step.pipeline.create_channel.errors[0].error.detail}"
  }

  output "update_channel" {
    description = "Check for pipeline.update_channel."
    value       = !is_error(step.pipeline.update_channel) ? "pass" : "fail: ${step.pipeline.update_channel.errors[0].error.detail}"
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
