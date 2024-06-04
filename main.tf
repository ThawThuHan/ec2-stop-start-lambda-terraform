resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Sid    = ""
          Principal = {
            Service = "lambda.amazonaws.com"
          }
        }
      ]
    }
  )

  inline_policy {
    name = "allow-ec2-start-stop-and-store-cloudwatch-logs"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["ec2:StartInstances", "ec2:StopInstances", "logs:CreateLogStream", "logs:CreateLogGroup", "logs:PutLogEvents"]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    })
  }
}

resource "aws_lambda_function" "stop_ec2" {
  filename         = "lambda_functions/ec2_stop.zip" # Path to your zipped Lambda function code
  function_name    = "StopEC2Instances"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "ec2_stop.lambda_handler"
  runtime          = "python3.8"
  timeout          = 60
  source_code_hash = filebase64sha256("lambda_functions/ec2_stop.zip")
  environment {
    variables = {
      INSTANCE_IDS = join(",", var.instance_ids)
    }
  }
}

resource "aws_lambda_function" "start_ec2" {
  filename         = "lambda_functions/ec2_start.zip" # Path to your zipped Lambda function code
  function_name    = "StartEC2Instances"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "ec2_start.lambda_handler"
  runtime          = "python3.8"
  timeout          = 60
  source_code_hash = filebase64sha256("lambda_functions/ec2_start.zip")
  environment {
    variables = {
      INSTANCE_IDS = join(",", var.instance_ids)
    }
  }
}

resource "aws_cloudwatch_event_rule" "stop_ec2_rule" {
  name                = "EC2_Stop_Rule_Schedule"
  schedule_expression = var.stop_schedule_expression
}

resource "aws_cloudwatch_event_rule" "start_ec2_rule" {
  name                = "EC2_Start_Rule_Schedule"
  schedule_expression = var.start_schedule_expression
}

resource "aws_cloudwatch_event_target" "stop_target" {
  rule      = aws_cloudwatch_event_rule.stop_ec2_rule.name
  target_id = "Stop_EC2Instances"
  arn       = aws_lambda_function.stop_ec2.arn
}

resource "aws_cloudwatch_event_target" "start_target" {
  rule      = aws_cloudwatch_event_rule.start_ec2_rule.name
  target_id = "Start_EC2Instances"
  arn       = aws_lambda_function.start_ec2.arn
}

resource "aws_lambda_permission" "allow_ec2_stop_cw_rule" {
  statement_id  = "AllowEC2StopCWRule"
  function_name = aws_lambda_function.stop_ec2.function_name
  principal     = "events.amazonaws.com"
  action        = "lambda:InvokeFunction"
  source_arn    = aws_cloudwatch_event_rule.stop_ec2_rule.arn
}

resource "aws_lambda_permission" "allow_ec2_start_cw_rule" {
  statement_id  = "AllowEC2StartCWRule"
  function_name = aws_lambda_function.start_ec2.function_name
  principal     = "events.amazonaws.com"
  action        = "lambda:InvokeFunction"
  source_arn    = aws_cloudwatch_event_rule.start_ec2_rule.arn
}
