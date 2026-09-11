# tf-azurerm-module_primitive-api_management_backend

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

This module provisions an Azure API Management backend. Backends can reference azure resources or FQDNs, optionally with authentication.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.117, < 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_api_management_backend.backend](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_backend) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_management_name"></a> [api\_management\_name](#input\_api\_management\_name) | name of the APIM in which this backend will de deployed | `string` | `null` | no |
| <a name="input_credentials"></a> [credentials](#input\_credentials) | options to authenticate with the backend server | <pre>object({<br/>    authorization = optional(object({<br/>      scheme    = optional(string, null)<br/>      parameter = optional(string, null)<br/>    }), null)<br/>    certificate = optional(list(string), null)<br/>    query       = optional(map(string), null)<br/>    header      = optional(map(string), null)<br/>  })</pre> | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | description of the backend | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | name of the backend | `string` | `null` | no |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | n/a | `string` | `"http"` | no |
| <a name="input_proxy"></a> [proxy](#input\_proxy) | options for a proxy server used to connect to the backend URI | <pre>object({<br/>    url      = string<br/>    password = optional(string, null)<br/>    username = string<br/>  })</pre> | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | name of the resource group where the APIM exists | `string` | `null` | no |
| <a name="input_resource_id"></a> [resource\_id](#input\_resource\_id) | Can be the ARM Resource ID of Logic Apps, Function Apps or API Apps, or the management endpoint of a Service Fabric cluster. | `string` | `null` | no |
| <a name="input_service_fabric_cluster"></a> [service\_fabric\_cluster](#input\_service\_fabric\_cluster) | options for connecting to a service fabric cluster | <pre>object({<br/>    client_certificate_thumbprint    = optional(string, null)<br/>    client_certificate_id            = optional(string, null)<br/>    management_endpoints             = list(string)<br/>    max_partition_resolution_retries = number<br/>    server_certificate_thumbprints   = optional(list(string), null)<br/>    server_x509_names = optional(list(object({<br/>      issuer_certificate_thumbprint = string<br/>      name                          = string<br/>    })), null)<br/>  })</pre> | `null` | no |
| <a name="input_title"></a> [title](#input\_title) | title of the backend | `string` | `null` | no |
| <a name="input_tls"></a> [tls](#input\_tls) | options when using self-signed certificates for the backend host | <pre>object({<br/>    validate_certificate_chain = optional(bool, null)<br/>    validate_certificate_name  = optional(bool, null)<br/>  })</pre> | `null` | no |
| <a name="input_url"></a> [url](#input\_url) | the url for the backend service | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_id"></a> [backend\_id](#output\_backend\_id) | n/a |
| <a name="output_backend_name"></a> [backend\_name](#output\_backend\_name) | n/a |
| <a name="output_backend_url"></a> [backend\_url](#output\_backend\_url) | n/a |
<!-- END_TF_DOCS -->

## Module Development

### Pre-Requisites

The following commands should be available on your system:

- `asdf` or `mise`
- `make`
- `python3` (for pre-commit)

Additionally, your `git` user and email must be configured. Run the `make configure` command from the root of the repository to ensure that you meet these requirements.

### Pre-Commit hooks

The [.pre-commit-config.yaml](.pre-commit-config.yaml) file defines certain `pre-commit` hooks that are relevant to Terraform and Golang, as well as some common linting tasks. These will be configured for you when you run `make configure`.

### Local Validation

You should validate the changes you make to any module locally, prior to pushing your changes in a branch to GitHub.

1. Ensure that you have run `make configure` successfully.

2. Ensure you are signed into the appropriate cloud provider (e.g. AWS or Azure) for the module under test in your current console session.

3. Run the Terraform and Golang linters with the following command:

```
make lint
```

4. Once you have satisfied the linters, the following command will build example infrastructure in your configured cloud, run the tests, and then tear down the infrastructure it created:

```
make test
```

The pre-commit validations, as well as the `make lint` and `make test` targets, will all be performed in CI. Running these validations locally prior to opening a PR helps ensure a smooth review and merge process.

### Review & Merge Process

Once your change has been tested locally and your branch pushed up, open a new Pull Request for your branch to the default (main) branch of this repository.

The title of your Pull Request will determine the version bump for this change, and the title must be in [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/#specification) format in order to merge. A breaking change will trigger a major version bump, a feature will trigger a minor version bump, and all other types will trigger a patch version bump.

Ensure your CI workflows are passing; seek approval from teammates and address any feedback; seek any explicit approvals required by the CODEOWNERS file. You may merge the PR as soon as all requirements are met, and a new release and tag will be automatically created for you.

### Automatic Updates

The shared configuration and workflow files in this repository are largely managed through the [launch-terraform-skeleton](https://github.com/launchbynttdata/launch-terraform-skeleton) repository. Outside of perhaps the `.gitignore` to account for specific files being generated by certain Terraform modules (e.g. Lambda functions), there should not be much cause to update these files on a per-repo basis, and making changes to them individually is discouraged.

If desired, you can check for and run these updates locally in a branch if you have the `copier` tool installed. Some example commands are included below:

```
# Check for updates, optionally checking prerelease versions
copier check-update [--prereleases]

# Run an update, using default answers if there are any. We use tasks, which requires --trust to be set.
copier update --defaults --trust [--prereleases]

# Recopy from the source, and --overwrite all templated files in the process
copier recopy --defaults --trust --overwrite [--prereleases]
```

Automatic updates will run through a scheduled workflow, and if the post-update tests are successful, the Pull Request created will automatically merge. Conflicts in the update or failures to test may leave a Pull Request outstanding, which needs to be addressed by a Launch Engineer.
