pipeline "send_email" {
  title       = "Send Email"
  description = "Send a mail message to a recipient."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
  }

  param "subject" {
    type        = string
    description = "The subject of the email."
  }

  param "content" {
    type        = string
    description = "The content of the email."
  }

  param "to_email" {
    type        = string
    description = "The email-id of the receipient."
  }

  step "http" "send_email" {
    title  = "Send Mail"
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/me/sendMail"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }

    request_body = jsonencode({
      "message" : {
        "subject" : "${param.subject}",
        "body" : {
          "contentType" : "Text",
          "content" : "${param.content}"
        },
        "toRecipients" : [
          {
            "emailAddress" : {
              "address" : "${param.to_email}"
            }
          }
        ]
      }
    })
  }

}
