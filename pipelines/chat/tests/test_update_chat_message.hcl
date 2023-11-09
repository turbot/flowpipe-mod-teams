pipeline "test_update_chat_message" {
  title       = "Test Update Chat Message"
  description = "Test the update_chat_message pipeline."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
  }

  param "message" {
    type        = string
    default     = "Hello World from send_chat_message pipeline."
    description = "The message to send."
  }

  param "topic" {
    type        = string
    description = "The title of the chat. The chat title can be provided only if the chat is of group type."
    optional    = true
  }

  step "pipeline" "get_current_user" {
    pipeline = pipeline.get_current_user
    args = {
      access_token = param.access_token
    }
  }

  step "pipeline" "create_chat" {
    pipeline = pipeline.create_chat
    args = {
      access_token = param.access_token
      chat_type    = "group"
      topic        = "flowpipe-mod-test"
    }
  }

  step "pipeline" "send_chat_message" {
    if       = !is_error(step.pipeline.create_chat)
    pipeline = pipeline.send_chat_message
    args = {
      access_token = param.access_token
      chat_id      = step.pipeline.create_chat.output.chat.id
      message      = param.message
    }
  }

  step "pipeline" "update_chat_message" {
    if       = !is_error(step.pipeline.send_chat_message)
    pipeline = pipeline.update_chat_message
    args = {
      access_token = param.access_token
      chat_id      = step.pipeline.create_chat.output.chat.id
      message      = "Hello World - Updated by update_chat_message pipeline"
      message_id   = step.pipeline.send_chat_message.output.message.id
    }
  }

  step "pipeline" "delete_chat_message" {
    if         = !is_error(step.pipeline.send_chat_message)
    depends_on = [step.pipeline.update_chat_message]
    pipeline   = pipeline.delete_chat_message
    args = {
      access_token = param.access_token
      chat_id      = step.pipeline.create_chat.output.chat.id
      message_id   = step.pipeline.send_chat_message.output.message.id
      user_id      = step.pipeline.get_current_user.output.current_user.id
    }
  }

  output "create_chat" {
    description = "Check for pipeline.create_chat."
    value       = !is_error(step.pipeline.create_chat) ? "pass" : "fail: ${step.pipeline.create_chat.errors}"
  }

  output "send_chat_message" {
    description = "Check for pipeline.send_channel_message."
    value       = !is_error(step.pipeline.send_chat_message) ? "pass" : "fail: ${step.pipeline.send_chat_message.errors}"
  }

  output "update_chat_message" {
    description = "Check for pipeline.update_chat_message."
    value       = !is_error(step.pipeline.update_chat_message) ? "pass" : "fail: ${step.pipeline.update_chat_message.errors}"
  }

  output "delete_chat_message" {
    description = "Check for pipeline.delete_chat_message."
    value       = !is_error(step.pipeline.delete_chat_message) ? "pass" : "fail: ${step.pipeline.delete_chat_message.errors}"
  }
}
