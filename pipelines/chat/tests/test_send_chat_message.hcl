pipeline "test_send_chat_message" {
  title       = "Test Send Chat Message"
  description = "Test the send_chat_message pipeline."

  param "access_token" {
    type        = string
    default     = var.access_token
    description = "The access token to use for the request."
  }

  param "message" {
    type        = string
    default     = "Hello World from send_chat_message pipeline - Will be deleted in 10 seconds."
    description = "The message to send."
  }

  param "topic" {
    type        = string
    optional    = true
    description = "The title of the chat. The chat title can be provided only if the chat is of group type."
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

  step "sleep" "wait_for_send_chat_message" {
    if       = !is_error(step.pipeline.send_chat_message)
    duration = "10s"
  }

  step "pipeline" "delete_chat_message" {
    if         = !is_error(step.pipeline.send_chat_message)
    depends_on = [step.sleep.wait_for_send_chat_message]
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

  output "delete_chat_message" {
    description = "Check for pipeline.delete_chat_message."
    value       = !is_error(step.pipeline.delete_chat_message) ? "pass" : "fail: ${step.pipeline.delete_chat_message.errors}"
  }
}
