# EC2 Stop/Start Lambda Terraform Module

This Terraform module creates an AWS Lambda function that automatically stops and starts EC2 instances based on a specified schedule. The module leverages AWS CloudWatch Events to trigger the Lambda function.

## Table of Contents

- [EC2 Stop/Start Lambda Terraform Module](#ec2-stopstart-lambda-terraform-module)
  - [Table of Contents](#table-of-contents)
  - [Prerequisites](#prerequisites)
  - [Usage](#usage)
  - [Inputs](#inputs)
  - [Outputs](#outputs)
  - [Contributing](#contributing)
  - [License](#license)

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
- AWS CLI configured with appropriate permissions.
- An AWS account with access to manage EC2 instances and Lambda functions.

## Usage

To use this module, include it in your Terraform configuration and specify the required variables.

```hcl
module "ec2_stop_start_lambda" {
  source          = "github.com/ThawThuHan/ec2-stop-start-lambda-terraform"
  region          = "us-east-1"
  instance_ids    = ["i-0abcd1234efgh5678", "i-0ijkl9012mnop3456"]
  start_schedule  = "cron(0 8 * * ? *)"
  stop_schedule   = "cron(0 20 * * ? *)"
}
```
## Inputs
| Name                      | Type        | Default              | Required |
|---------------------------|-------------|----------------------|----------|
| region                    | string      | "us-east-1"          | No       |
| instance_ids              | set(string) | []                   | Yes      |
| start_schedule_expression | string      | "cron(0 19 * * ? *)" | No       |
| stop_schedule_expression  | string      | "cron(0 7 * * ? *)"  | No       |

## Outputs
| Name                           | Description                                                 |
|--------------------------------|-------------------------------------------------------------|
| cloudwatch_event_rule_start_id | The ID of AWS CloudWatch Event Rule for starting instances. |
| cloudwatch_event_rule_stop_id  | The ID of AWS CloudWatch Event Rule for stopping instances. |
| lambda_start_function_name     | The name of Lambda function for starting instances.         |
| lambda_stop_function_name      | The name of Lambda function for stopping instances.         |

## Contributing
Contributions are welcome! Please open an issue or submit a pull request with your improvements.

## License
This project is licensed under the MIT License. See the [LICENSE](#license) file for details.
