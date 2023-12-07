pipeline "assign_licenses_to_user" {
  title       = "Assign Licenses to User"
  description = "Add subscriptions for the user."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "user_id" {
    type        = string
    description = "The ID or userPrincipalName of the user to whom you want to assign the license."
  }

  param "sku_ids" {
    type        = list(string)
    description = "The unique identifier for the available licenses."
  }

  step "http" "assign_licenses_to_user" {
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/users/${param.user_id}/assignLicense"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${credential.teams[param.cred].access_token}"
    }

    request_body = jsonencode({
      addLicenses = [for sku_id in param.sku_ids : {
        skuId = sku_id
      }],
      removeLicenses = []
    })
  }

  output "licenses" {
    description = "The user details."
    value       = step.http.assign_licenses_to_user.response_body
  }
}
