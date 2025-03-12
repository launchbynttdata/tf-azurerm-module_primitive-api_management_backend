// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
variable "product_family" {
  description = <<EOF
    (Required) Name of the product family for which the resource is created.
    Example: org_name, department_name.
  EOF
  type        = string
  default     = "dso"
}

variable "product_service" {
  description = <<EOF
    (Required) Name of the product service for which the resource is created.
    For example, backend, frontend, middleware etc.
  EOF
  type        = string
  default     = "apim"
}

variable "environment" {
  description = "Environment in which the resource should be provisioned like dev, qa, prod etc."
  type        = string
  default     = "dev"
}

variable "environment_number" {
  description = "The environment count for the respective environment. Defaults to 000. Increments in value of 1"
  type        = string
  default     = "000"
}

variable "resource_number" {
  description = "The resource count for the respective resource. Defaults to 000. Increments in value of 1"
  type        = string
  default     = "000"
}

variable "region" {
  description = "Azure Region in which the infra needs to be provisioned"
  type        = string
  default     = "eastus"
}

variable "resource_names_map" {
  description = "A map of key to resource_name that will be used by tf-launch-module_library-resource_name to generate resource names"
  type = map(object(
    {
      name       = string
      max_length = optional(number, 60)
    }
  ))
  default = {
    resource_group = {
      name       = "rg"
      max_length = 50
    }
    api_management = {
      name       = "apim"
      max_length = 50
    }
  }
}

# APIM settings

variable "sku_name" {
  type        = string
  description = <<EOT
    String consisting of two parts separated by an underscore. The fist part is the name, valid values include: Developer,
    Basic, Standard and Premium. The second part is the capacity. Default is Consumption_0.
  EOT
  default     = "Consumption_0"
}

variable "publisher_name" {
  type        = string
  description = "The name of publisher/company."
  default     = "launchdso"
}

variable "publisher_email" {
  type        = string
  description = "The email of publisher/company."
  default     = "launchdso@nttdata.com"
}

variable "public_network_access_enabled" {
  description = <<EOT
    Should the API Management Service be accessible from the public internet?
    This option is applicable only to the Management plane, not the API gateway or Developer portal.
    It is required to be true on the creation.
    For sku=Developer/Premium and network_type=Internal, it must be true.
    It can only be set to false if there is at least one approve private endpoint connection.
  EOT
  type        = bool
  default     = true
}

variable "virtual_network_type" {
  type        = string
  description = <<EOT
    The type of virtual network you want to use, valid values include: None, External, Internal.
    External and Internal are only supported in the SKUs - Premium and Developer
  EOT
  default     = "None"
}

# Backend settings
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

# Common settings

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
