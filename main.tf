resource "azurerm_api_management_backend" "backend" {
  name                = var.name
  resource_group_name = var.resource_group_name
  api_management_name = var.api_management_name
  protocol            = var.protocol
  url                 = var.url
  description         = var.description
  resource_id         = var.resource_id
  title               = var.title

  dynamic "credentials" {
    for_each = var.credentials != null ? [var.credentials] : []
    content {
      dynamic "authorization" {
        for_each = var.credentials.authorization != null ? [var.credentials.authorization] : []
        content {
          scheme    = authorization.value.scheme
          parameter = authorization.value.parameter
        }
      }
      header      = var.credentials.header
      certificate = var.credentials.certificate
      query       = var.credentials.query
    }
  }

  dynamic "proxy" {
    for_each = var.proxy != null ? [var.proxy] : []
    content {
      url      = var.proxy.url
      username = var.proxy.username
      password = var.proxy.password
    }
  }

  dynamic "service_fabric_cluster" {
    for_each = var.service_fabric_cluster != null ? [var.service_fabric_cluster] : []
    content {
      client_certificate_thumbprint    = service_fabric_cluster.value.client_certificate_thumbprint
      client_certificate_id            = service_fabric_cluster.value.client_certificate_id
      management_endpoints             = service_fabric_cluster.value.management_endpoints
      max_partition_resolution_retries = service_fabric_cluster.value.max_partition_resolution_retries
      server_certificate_thumbprints   = service_fabric_cluster.value.server_certificate_thumbprints
      dynamic "server_x509_name" {
        for_each = toset(var.service_fabric_cluster.server_x509_names)
        content {
          name                          = server_x509_name.value.name
          issuer_certificate_thumbprint = server_x509_name.value.issuer_certificate_thumbprint
        }
      }
    }
  }

  dynamic "tls" {
    for_each = var.tls != null ? [var.tls] : []
    content {
      validate_certificate_chain = tls.value.validate_certificate_chain
      validate_certificate_name  = tls.value.validate_certificate_name
    }
  }
}
