pipeline "assign_licenses_to_user" {
  title       = "Assign Licenses to User"
  description = "Add subscriptions for the user."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
  }

  param "user_id" {
    type        = string
    description = "The ID or userPrincipalName of the user to whom you want to assign the license."
    default     = "test2cis@turbotoffice.onmicrosoft.com"
  }

  param "sku_ids" {
    type        = list(string)
    description = "The unique identifier for the available licenses."
    default     = ["f30db892-07e9-47e9-837c-80727f46fd3d"]
  }

  step "http" "assign_licenses_to_user" {
    method = "post"
    url    = "https://graph.microsoft.com/v1.0/users/${param.user_id}/assignLicense"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }

    request_body = jsonencode({
      addLicenses = [for sku_id in param.sku_ids : {
        skuId = sku_id
      }],
      removeLicenses = []
    })
  }

  output "assigned_licenses" {
    value       = step.http.assign_licenses_to_user.response_body
    description = "The user details."
  }
}
