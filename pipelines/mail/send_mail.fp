pipeline "send_mail" {
  title       = "Send Mail"
  description = "Send a new email using JSON format."

  tags = {
    type = "featured"
  }

  param "conn" {
    type        = connection.microsoft_teams
    description = local.conn_param_description
    default     = connection.microsoft_teams.default
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
    type        = list(string)
    description = "The email-id(s) of the primary receipient(s)."
  }

  step "http" "send_mail" {
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/me/sendMail"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.conn.access_token}"
    }

    request_body = jsonencode({
      "message" : {
        "subject" : "${param.subject}",
        "body" : {
          "contentType" : "Text",
          "content" : "${param.content}"
        },
        "toRecipients" : [
          for email in param.to_email : {
            "emailAddress" : {
              "address" : email
            }
          }
        ]
      }
    })
  }
}
