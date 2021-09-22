# terraform-hcloud-tor-obfs4-bridge

Deploy obfs4 public Tor bridges to Hetzner Cloud.

Example:

```
provider "hcloud" {
  token    = "<your token>"
}

locals {
  ssh_key = file("~/.ssh/id_rsa.pub")
}

module "bridge" {
  source = "git::https://gitlab.com/sr2c/terraform-hcloud-tor-obfs4-bridge.git?ref=master"
  count = 1 # increase for more bridges
  namespace = "<yourorg>"
  name = "bridge"
  attributes = [tostring(count.index)]
  ssh_keypair_name = "<key name>" # must be created via the web console
  contact_info = "<admin email address>"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_hcloud"></a> [hcloud](#requirement\_hcloud) | 1.31.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_hcloud"></a> [hcloud](#provider\_hcloud) | 1.31.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bridgeline"></a> [bridgeline](#module\_bridgeline) | matti/resource/shell | 1.5.0 |
| <a name="module_fingerprint_ed25519"></a> [fingerprint\_ed25519](#module\_fingerprint\_ed25519) | matti/resource/shell | 1.5.0 |
| <a name="module_fingerprint_rsa"></a> [fingerprint\_rsa](#module\_fingerprint\_rsa) | matti/resource/shell | 1.5.0 |
| <a name="module_hashed_fingerprint"></a> [hashed\_fingerprint](#module\_hashed\_fingerprint) | matti/resource/shell | 1.5.0 |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.25.0 |

## Resources

| Name | Type |
|------|------|
| [hcloud_server.this](https://registry.terraform.io/providers/hetznercloud/hcloud/1.31.1/docs/resources/server) | resource |
| [random_integer.obfs_port](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/integer) | resource |
| [random_integer.or_port](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/integer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br>This is for some rare cases where resources want additional configuration of tags<br>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br>in the order they appear in the list. New attributes are appended to the<br>end of the list. The elements of the list are joined by the `delimiter`<br>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_contact_info"></a> [contact\_info](#input\_contact\_info) | Contact information to be published in the bridge descriptor. | `string` | n/a | yes |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "descriptor_formats": {},<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "labels_as_tags": [<br>    "unset"<br>  ],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {},<br>  "tenant": null<br>}</pre> | no |
| <a name="input_datacenter"></a> [datacenter](#input\_datacenter) | Datacenter to deploy the instance in. | `string` | n/a | yes |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br>Map of maps. Keys are names of descriptors. Values are maps of the form<br>`{<br>   format = string<br>   labels = list(string)<br>}`<br>(Type is `any` so the map values can later be enhanced to provide additional options.)<br>`format` is a Terraform format string to be passed to the `format()` function.<br>`labels` is a list of labels, in order, to pass to `format()` function.<br>Label values will be normalized before being passed to `format()` so they will be<br>identical to how they appear in `id`.<br>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for keep the existing setting, which defaults to `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br>Does not affect keys of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br>set as tag values, and output by this module individually.<br>Does not affect values of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br>Default is to include all labels.<br>Tags with empty values will not be included in the `tags` output.<br>Set to `[]` to suppress all generated tags.<br>**Notes:**<br>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br>This is the only ID element not also included as a `tag`.<br>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br>Characters matching the regex will be removed from the ID elements.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_server_type"></a> [server\_type](#input\_server\_type) | Name of the server type to use for the compute instance. | `string` | `"cx11"` | no |
| <a name="input_ssh_key_name"></a> [ssh\_key\_name](#input\_ssh\_key\_name) | Public SSH key name for provisioning. This SSH key must have already been created via the console. | `string` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bridgeline"></a> [bridgeline](#output\_bridgeline) | The bridgeline that would allow a Tor client to use this bridge. |
| <a name="output_fingerprint_ed25519"></a> [fingerprint\_ed25519](#output\_fingerprint\_ed25519) | The Ed25519 fingerprint of this bridge. |
| <a name="output_fingerprint_rsa"></a> [fingerprint\_rsa](#output\_fingerprint\_rsa) | The hex-encoded RSA fingerprint of this bridge. |
| <a name="output_hashed_fingerprint"></a> [hashed\_fingerprint](#output\_hashed\_fingerprint) | The hex-encoded hashed fingerprint of this bridge. This is used to identify the bridge in public Tor Metrics data. |
| <a name="output_id"></a> [id](#output\_id) | An identifier for the bridge formed of the ID elements. |
| <a name="output_ip_address"></a> [ip\_address](#output\_ip\_address) | The IP address of the server. This is treated as sensitive as this information may be used to censor access to the bridge. |
| <a name="output_nickname"></a> [nickname](#output\_nickname) | The nickname of the bridge published in the bridge descriptors. This is based on the ID, reformatted for the nickname restrictions. |
| <a name="output_obfs_port"></a> [obfs\_port](#output\_obfs\_port) | The TCP port number used for the obfs4 port. This is treated as sensitive as this information may be used to censor access to the bridge. |
| <a name="output_or_port"></a> [or\_port](#output\_or\_port) | The TCP port number used for the OR port. This is treated as sensitive as this information may be used to censor access to the bridge. |
