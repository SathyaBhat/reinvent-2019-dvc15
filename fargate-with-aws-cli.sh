# Create a cluster
aws ecs create-cluster --cluster-name mysql-export --region=us-east-1 

# Create a repository (optional)
aws ecr create-repository --repository-name sathyabhat/mysql-export --region=us-east-1 

# Create a log group
aws logs create-log-group --log-group-name /ecs/mysql-export

# Register a task definition
aws ecs register-task-definition --cli-input-json file://mysql-export.json --region=us-east-1

# Run the task
task_arn=$(aws ecs run-task \
--cluster fargate-cluster \
--task-definition mysql-export:1 \
--overrides '{"containerOverrides":[{"name":"mysql-export","environment":[ {"name":"dbhost", "value":'\"$dbhost\“’}, {"name":"dbname","value":'\"$database\"'}]}]}' \
--launch-type FARGATE \
--network-configuration 'awsvpcConfiguration={subnets=['subnet-1a2b3c4d'],securityGroups=['sg-0fa6089fc94b1438'],assignPublicIp='DISABLED'}' \
--region=us-east-1 | jq -r .tasks[].taskArn)

# Wait for the task to be completed
echo "Waiting for export to complete.. "
aws ecs wait tasks-stopped \
--cluster fargate-cluster \
--tasks $task_arn \
--region=us-east-1
