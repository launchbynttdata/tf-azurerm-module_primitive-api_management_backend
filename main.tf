resource "azurerm_api_management_backend" "apim-backend" {
  name                = var.name
  resource_group_name = var.resource_group.name
  api_management_name = var.apim_name
  protocol            = var.protocol
  url                 = var.url
  description         = var.description != null ? var.description : null
  resource_id         = var.resource_id != null ? var.resource_id : null
  title               = var.title != null ? var.title : null

  dynamic "credentials" {
    for_each = var.credentials != null ? [var.credentials] : []
    content {
      dynamic "authorization" {
        for_each = var.credentials.authorization != null ? [var.credentials.authorization] : []
        content {
          scheme    = authorization.value.scheme != null ? authorization.value.scheme : null
          parameter = authorization.value.parameter != null ? authorization.value.parameter : null
        }
      }
      header      = var.credentials.header != null ? var.credentials.header : null
      certificate = var.credentials.certificate != null ? var.credentials.certificate : null
      query       = var.credentials.query != null ? var.credentials.query : null
    }
  }

  dynamic "proxy" {
    for_each = var.proxy != null ? [var.proxy] : []
    content {
      url      = var.proxy.url
      username = var.proxy.username
      password = var.proxy.password != null ? var.proxy.password : null
    }
  }

  dynamic "service_fabric_cluster" {
    for_each = var.service_fabric_cluster != null ? [var.service_fabric_cluster] : []
    content {
      client_certificate_thumbprint    = service_fabric_cluster.value.client_certificate_thumbprint != null ? var.service_fabric_cluster.client_certificate_thumbprint : null
      client_certificate_id            = service_fabric_cluster.value.client_certificate_id != null ? var.service_fabric_cluster.client_certificate_id : null
      management_endpoints             = service_fabric_cluster.value.management_endpoints
      max_partition_resolution_retries = service_fabric_cluster.value.max_partition_resolution_retries != null ? var.service_fabric_cluster.max_partition_resolution_retries : null
      server_certificate_thumbprints   = service_fabric_cluster.value.server_certificate_thumbprints != null ? var.service_fabric_cluster.server_certificate_thumbprints : null
      dynamic "server_x509_name" {
        for_each = service_fabric_cluster.value.server_x509_name != null ? [var.service_fabric_cluster.server_x509_name] : []
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
      validate_certificate_chain = tls.value.validate_certificate_chain != null ? var.tls.validate_certificate_chain : null
      validate_certificate_name  = tls.value.validate_certificate_name != null ? var.tls.validate_certificate_name : null
    }
  }

}



