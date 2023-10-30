pipeline "test_send_channel_message" {
  title       = "Test Send Channel Message"
  description = "Test the send_channel_message pipeline."

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
    default     = "Hello World!"
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
      team_id             = param.team_id
      channel_name        = param.channel_name
      channel_description = param.channel_description
      membership_type     = param.membership_type
    }
  }

  step "sleep" "wait_for_create_complete" {
    depends_on = [step.pipeline.create_channel]
    duration   = "20s"
  }

  step "pipeline" "send_channel_message" {
    if       = step.pipeline.create_channel.status_code == 201 || step.pipeline.create_channel.status_code == 202
    pipeline = pipeline.send_channel_message
    args = {
      access_token = param.access_token
      team_id      = param.team_id
      channel_id   = step.pipeline.create_channel.channel_id
      message      = param.message
    }
  }

  step "pipeline" "delete_channel_message" {
    if       = step.pipeline.send_channel_message.raw_output.status_code == 201
    pipeline = pipeline.delete_channel_message
    args = {
      access_token = param.access_token
      team_id      = param.team_id
      channel_id   = step.pipeline.create_channel.channel_id
      message_id   = step.pipeline.send_channel_message.raw_output.response_body.id
    }
  }

  step "pipeline" "delete_channel" {
    if         = step.pipeline.create_channel.status_code == 201 || step.pipeline.create_channel.status_code == 202
    depends_on = [step.pipeline.delete_channel_message]
    pipeline   = pipeline.delete_channel
    args = {
      access_token = param.access_token
      team_id      = var.team_id
      channel_id   = step.pipeline.create_channel.channel_id
    }
  }

  output "create_channel" {
    description = "Check for pipeline.create_channel."
    value       = step.pipeline.create_channel.status_code == 201 || step.pipeline.create_channel.status_code == 202 ? "pass" : "fail: ${step.pipeline.create_channel.status_code}"
  }

  output "send_channel_message" {
    description = "Check for pipeline.send_channel_message."
    value       = step.pipeline.send_channel_message.raw_output.status_code == 201 ? "pass" : "fail: ${step.pipeline.send_channel_message.raw_output.status_code}"
  }

  output "delete_channel_message" {
    description = "Check for pipeline.delete_channel_message."
    value       = step.pipeline.delete_channel_message.raw_output.status_code == 204 ? "pass" : "fail: ${step.pipeline.delete_channel_message.raw_output.status_code}"
  }

  output "delete_channel" {
    description = "Check for pipeline.delete_channel."
    value       = step.pipeline.delete_channel.status_code == 204 ? "pass" : "fail: ${step.pipeline.delete_channel.status_code}"
  }
}
