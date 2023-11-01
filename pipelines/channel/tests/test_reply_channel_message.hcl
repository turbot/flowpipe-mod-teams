pipeline "test_reply_channel_message" {
  title       = "Test Reply Channel Message"
  description = "Test the reply_channel_message pipeline."

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
      channel_name        = param.channel_name
      channel_description = param.channel_description
      membership_type     = param.membership_type
      team_id             = param.team_id
    }
  }

  step "sleep" "wait_for_create_complete" {
    depends_on = [step.pipeline.create_channel]
    duration   = "10s"
  }

  step "pipeline" "send_channel_message" {
    if       = !is_error(step.pipeline.create_channel)
    depends_on = [step.sleep.wait_for_create_complete]
    pipeline = pipeline.send_channel_message
    args = {
      access_token = param.access_token
      channel_id   = step.pipeline.create_channel.output.channel.id
      message      = param.message
      team_id      = param.team_id
    }
  }

  step "pipeline" "reply_channel_message" {
    if       = !is_error(step.pipeline.send_channel_message)
    pipeline = pipeline.reply_channel_message
    args = {
      access_token = param.access_token
      channel_id   = step.pipeline.create_channel.output.channel.id
      message      = param.message
      message_id   = step.pipeline.send_channel_message.output.message.id
      team_id      = param.team_id
    }
  }

  step "pipeline" "update_channel_message" {
    if       = !is_error(step.pipeline.send_channel_message)
    pipeline = pipeline.update_channel_message
    args = {
      access_token = param.access_token
      channel_id   = step.pipeline.create_channel.output.channel.id
      message      = param.message
      message_id   = step.pipeline.send_channel_message.output.message.id
      team_id      = param.team_id
    }

    # Ignore errors so we can delete
    error {
      ignore = true
    }
  }

  step "pipeline" "delete_reply_channel_message" {
    if       = !is_error(step.pipeline.reply_channel_message)
    depends_on = [step.pipeline.update_channel_message]
    pipeline = pipeline.delete_channel_message
    args = {
      access_token = param.access_token
      channel_id   = step.pipeline.create_channel.output.channel.id
      message_id   = step.pipeline.reply_channel_message.output.message.id
      team_id      = param.team_id
    }
  }

  step "pipeline" "delete_channel_message" {
    if       = !is_error(step.pipeline.send_channel_message)
    depends_on = [step.pipeline.delete_reply_channel_message]
    pipeline = pipeline.delete_channel_message
    args = {
      access_token = param.access_token
      channel_id   = step.pipeline.create_channel.output.channel.id
      message_id   = step.pipeline.send_channel_message.output.message.id
      team_id      = param.team_id
    }
  }

  step "pipeline" "delete_channel" {
    if       = !is_error(step.pipeline.create_channel)
    depends_on = [step.pipeline.delete_channel_message]
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

  output "send_channel_message" {
    description = "Check for pipeline.send_channel_message."
    value       = !is_error(step.pipeline.send_channel_message) ? "pass" : "fail: ${step.pipeline.send_channel_message.errors[0].error.detail}"
  }

  output "reply_channel_message" {
    description = "Check for pipeline.reply_channel_message."
    value       = !is_error(step.pipeline.reply_channel_message) ? "pass" : "fail: ${step.pipeline.reply_channel_message.errors[0].error.detail}"
  }

  output "update_channel_message" {
    description = "Check for pipeline.update_channel_message."
    value       = !is_error(step.pipeline.update_channel_message) ? "pass" : "fail: ${step.pipeline.update_channel_message.errors[0].error.detail}"
  }

  output "delete_reply_channel_message" {
    description = "Check for pipeline.delete_channel_message."
    value       = !is_error(step.pipeline.delete_reply_channel_message) ? "pass" : "fail: ${step.pipeline.delete_reply_channel_message.errors[0].error.detail}"
  }

  output "delete_channel_message" {
    description = "Check for pipeline.delete_channel_message."
    value       = !is_error(step.pipeline.delete_channel_message) ? "pass" : "fail: ${step.pipeline.delete_channel_message.errors[0].error.detail}"
  }

  output "delete_channel" {
    description = "Check for pipeline.delete_channel."
    value       = !is_error(step.pipeline.delete_channel) ? "pass" : "fail: ${step.pipeline.delete_channel.errors[0].error.detail}"
  }
}
