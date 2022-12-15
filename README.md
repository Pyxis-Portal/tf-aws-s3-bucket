<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.1.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 3.50.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 2.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.50.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | terraform-aws-modules/s3-bucket/aws | 2.10.0 |

## Resources

| Name | Type |
|------|------|
| [aws_lambda_permission.lambda_allow_bucket_notification](https://registry.terraform.io/providers/hashicorp/aws/3.50.0/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket_notification.bucket_notification](https://registry.terraform.io/providers/hashicorp/aws/3.50.0/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_object.this](https://registry.terraform.io/providers/hashicorp/aws/3.50.0/docs/resources/s3_bucket_object) | resource |
| [aws_iam_policy_document.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/3.50.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_create_policy"></a> [create\_policy](#input\_create\_policy) | n/a | `bool` | `false` | no |
| <a name="input_create_s3_object"></a> [create\_s3\_object](#input\_create\_s3\_object) | this create reource s3 object | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | `"dev"` | no |
| <a name="input_kms_master_key_id"></a> [kms\_master\_key\_id](#input\_kms\_master\_key\_id) | n/a | `string` | `""` | no |
| <a name="input_lifecycle_rule"></a> [lifecycle\_rule](#input\_lifecycle\_rule) | all configiration for life cyle rule | `any` | `[]` | no |
| <a name="input_s3_access_policy"></a> [s3\_access\_policy](#input\_s3\_access\_policy) | n/a | `list(map(list(string)))` | <pre>[<br>  {<br>    "actions": [],<br>    "principals": [],<br>    "resources": []<br>  }<br>]</pre> | no |
| <a name="input_s3_bucket_force_deletion"></a> [s3\_bucket\_force\_deletion](#input\_s3\_bucket\_force\_deletion) | n/a | `bool` | `false` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | n/a | `string` | `"my-bucket"` | no |
| <a name="input_s3_object_key"></a> [s3\_object\_key](#input\_s3\_object\_key) | Name of the object once it is in the bucket. | `string` | `"java-basic-1.0"` | no |
| <a name="input_s3_object_source"></a> [s3\_object\_source](#input\_s3\_object\_source) | Path to a file that will be read and uploaded as raw bytes for the object content. | `string` | `"java-basic-1.0.jar"` | no |
| <a name="input_s3_trigger_lambdas_list"></a> [s3\_trigger\_lambdas\_list](#input\_s3\_trigger\_lambdas\_list) | n/a | <pre>list(object({<br>    id                  = string<br>    lambda_function_arn = string<br>    events              = list(string)<br>    filter_prefix       = string<br>    filter_suffix       = string<br>  }))</pre> | `[]` | no |
| <a name="input_sse_algorithm"></a> [sse\_algorithm](#input\_sse\_algorithm) | AES256 or aws:kms | `string` | `"AES256"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | The ARN of the bucket. Will be of format arn:aws:s3:::bucketname. |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | The name of the bucket. |
<!-- END_TF_DOCS -->