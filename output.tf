output "cloudwatch_event_rule_start_id" {
  value = aws_cloudwatch_event_rule.start_ec2_rule.id
}

output "cloudwatch_event_rule_stop_id" {
  value = aws_cloudwatch_event_rule.stop_ec2_rule.id
}

output "lambda_start_function_name" {
  value = aws_lambda_function.start_ec2.function_name
}

output "lambda_stop_function_name" {
  value = aws_lambda_function.stop_ec2.function_name
}
