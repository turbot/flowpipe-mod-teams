pipeline "test_send_chat_message" {
  title       = "Test Send Chat Message"
  description = "Test the send_chat_message pipeline."

  tags = {
    type = "test"
  }
  
  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "message" {
    type        = string
    default     = "Hello World from send_chat_message pipeline - Will be deleted in 10 seconds."
    description = "The message to send."
  }

  param "topic" {
    type        = string
    description = local.chat_topic_param_description
    optional    = true
  }

  step "pipeline" "get_current_user" {
    pipeline = pipeline.get_current_user
    args = {
      access_token = credential.teams[param.cred].access_token
    }
  }

  step "pipeline" "create_chat" {
    pipeline = pipeline.create_chat
    args = {
      access_token = credential.teams[param.cred].access_token
      chat_type    = "group"
      topic        = "flowpipe-mod-test"
    }
  }

  step "pipeline" "send_chat_message" {
    if       = !is_error(step.pipeline.create_chat)
    pipeline = pipeline.send_chat_message
    args = {
      access_token = credential.teams[param.cred].access_token
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
      access_token = credential.teams[param.cred].access_token
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
