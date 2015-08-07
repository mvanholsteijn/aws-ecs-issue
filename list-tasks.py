import boto3

client = boto3.client('ecs')

response = client.describe_tasks(
    cluster='consul-with-router-on-ecs',
    tasks=[ 'arn:aws:ecs:eu-west-1:233211978703:task/21c1761e-574d-46d6-9165-cb9e73fec47a' ]
)
print response
