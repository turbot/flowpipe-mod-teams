pipeline "test_send_channel_message" {
  title       = "Test Send Channel Message"
  description = "Test the send_channel_message pipeline."

  tags = {
    type = "test"
  }
  
  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "team_id" {
    type        = string
    default     = var.team_id
    description = "The unique identifier of the team."
  }

  param "message" {
    type        = string
    default     = "Hello World"
    description = "The message to send."
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
    duration   = "10s"
  }

  step "pipeline" "send_channel_message" {
    if         = !is_error(step.pipeline.create_channel)
    depends_on = [step.sleep.wait_for_create_complete]
    pipeline   = pipeline.send_channel_message
    args = {
      access_token = credential.teams[param.cred].access_token
      channel_id   = step.pipeline.create_channel.output.channel.id
      message      = param.message
      team_id      = param.team_id
    }

    # Ignore errors so we can delete channel
    error {
      ignore = true
    }
  }

  step "pipeline" "delete_channel_message" {
    if       = !is_error(step.pipeline.send_channel_message)
    pipeline = pipeline.delete_channel_message
    args = {
      access_token = credential.teams[param.cred].access_token
      channel_id   = step.pipeline.create_channel.output.channel.id
      message_id   = step.pipeline.send_channel_message.output.message.id
      team_id      = param.team_id
    }
  }

  step "pipeline" "delete_channel" {
    if         = !is_error(step.pipeline.create_channel)
    depends_on = [step.pipeline.delete_channel_message]
    pipeline   = pipeline.delete_channel
    args = {
      access_token = credential.teams[param.cred].access_token
      channel_id   = step.pipeline.create_channel.output.channel.id
      team_id      = var.team_id
    }
  }

  output "create_channel" {
    description = "Check for pipeline.create_channel."
    value       = !is_error(step.pipeline.create_channel) ? "pass" : "fail: ${step.pipeline.create_channel.errors}"
  }

  output "send_channel_message" {
    description = "Check for pipeline.send_channel_message."
    value       = !is_error(step.pipeline.send_channel_message) ? "pass" : "fail: ${step.pipeline.send_channel_message.errors}"
  }

  output "delete_channel_message" {
    description = "Check for pipeline.delete_channel_message."
    value       = !is_error(step.pipeline.delete_channel_message) ? "pass" : "fail: ${step.pipeline.delete_channel_message.errors}"
  }

  output "delete_channel" {
    description = "Check for pipeline.delete_channel."
    value       = !is_error(step.pipeline.delete_channel) ? "pass" : "fail: ${step.pipeline.delete_channel.errors}"
  }
}
