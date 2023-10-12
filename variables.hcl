variable "access_token" {
  type        = string
  description = "The Microsoft personal security access_token to authenticate to the Microsoft identity platform APIs, e.g., `eyJ0eXAiOiJKV1QiLCJub25jZSI6Ij...ZXLSTNROW5OUjdiUm9meG1lWm9YcWJIWkdldyJ9`. Please see https://learn.microsoft.com/en-us/graph/auth/auth-concepts#access-access_tokens for more information. Can also be set with the P_VAR_access_token environment variable."
  default     = ""
}