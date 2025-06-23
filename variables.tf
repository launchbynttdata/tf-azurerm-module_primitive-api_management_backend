variable "resource_group_name" {
  type        = string
  description = "name of the resource group where the APIM exists"
  default     = null
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,50}$", var.resource_group_name))
    error_message = "The resource group name can only contain alphanumeric characters and dashes and must be between 1 and 50 characters long."
  }
}

variable "api_management_name" {
  type        = string
  description = "name of the APIM in which this backend will de deployed"
  default     = null
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,50}$", var.api_management_name))
    error_message = "The APIM name can only contain alphanumeric characters and dashes and must be between 1 and 50 characters long."
  }
}

variable "title" {
  type        = string
  description = "title of the backend"
  default     = null
  validation {
    condition     = var.title == null || can(regex("^[a-zA-Z0-9- ]{1,50}$", var.title))
    error_message = "The title can only contain alphanumeric characters, dashes, or spaces and must be between 1 and 50 characters long."
  }
}

variable "protocol" {
  type    = string
  default = "http"
  validation {
    condition     = can(regex("^(http|soap)$", var.protocol))
    error_message = "The protocol must be either http or soap."
  }
}

variable "resource_id" {
  type        = string
  description = "Can be the ARM Resource ID of Logic Apps, Function Apps or API Apps, or the management endpoint of a Service Fabric cluster."
  default     = null
  validation {
    condition     = var.resource_id == null || can(regex("^[a-zA-Z0-9-:\\/_.]{1,256}$", var.resource_id))
    error_message = "The resource_id can be a URI or URL."
  }
}
variable "name" {
  type        = string
  description = "name of the backend"
  default     = null
  validation {
    condition     = var.name == null || can(regex("^[a-zA-Z0-9-]{1,50}$", var.name))
    error_message = "The backend name can only contain alphanumeric characters and dashes and must be between 1 and 50 characters long."
  }
}
variable "url" {
  type        = string
  description = "the url for the backend service"
  default     = null
  validation {
    condition     = can(regex("^(http|https)://", var.url))
    error_message = "The backend url must start with http:// or https://."
  }
}

variable "description" {
  type        = string
  description = "description of the backend"
  default     = null
}

variable "proxy" {
  description = "options for a proxy server used to connect to the backend URI"
  type = object({
    url      = string
    password = optional(string, null)
    username = string
  })
  default = null
}

variable "service_fabric_cluster" {
  description = "options for connecting to a service fabric cluster"
  type = object({
    client_certificate_thumbprint    = optional(string, null)
    client_certificate_id            = optional(string, null)
    management_endpoints             = list(string)
    max_partition_resolution_retries = number
    server_certificate_thumbprints   = optional(list(string), null)
    server_x509_names = optional(list(object({
      issuer_certificate_thumbprint = string
      name                          = string
    })), null)
  })
  default = null
}

variable "tls" {
  description = "options when using self-signed certificates for the backend host"
  type = object({
    validate_certificate_chain = optional(bool, null)
    validate_certificate_name  = optional(bool, null)
  })
  default = null
  validation {
    condition     = var.tls == null || can(regex("^(true|false)$", var.tls.validate_certificate_chain))
    error_message = "The validate_certificate_chain must be either true or false."
  }
  validation {
    condition     = var.tls == null || can(regex("^(true|false)$", var.tls.validate_certificate_name))
    error_message = "The validate_certificate_name must be either true or false."
  }
}

variable "credentials" {
  description = "options to authenticate with the backend server"
  type = object({
    authorization = optional(object({
      scheme    = optional(string, null)
      parameter = optional(string, null)
    }), null)
    certificate = optional(list(string), null)
    query       = optional(map(string), null)
    header      = optional(map(string), null)
  })
  default = null
}
