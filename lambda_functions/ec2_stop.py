import boto3
import os

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    instance_ids = os.environ['INSTANCE_IDS'].split(',')
    ec2.stop_instances(InstanceIds=instance_ids)
    return 'Stopped your instances: ' + str(instance_ids)