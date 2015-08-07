CLUSTER=$1
TASK=$2

ID=
STATE=

function registerTask() {
	aws ecs register-task-definition --cli-input-json "$(<$1.json)"
	
}

function runTask() {
	aws ecs run-task --cluster $1 --task-definition $2 | jq -r ' .tasks[0].taskArn'
}

function getState() {
	STATE=$(aws ecs describe-tasks --cluster $1 --tasks $2)
}

function getStatus() {
	echo "$STATE" | jq -r '.tasks[0].lastStatus'
}

function printSummary() {
	echo "$STATE" | jq -r '.tasks[0].containers[0] | .lastStatus ,  .reason , .exitCode'
}

function getInstanceId() {
	CONTAINER_INSTANCE=$(echo "$STATE" | jq -r '.tasks[0].containerInstanceArn')
	aws ecs describe-container-instances --cluster $CLUSTER --container-instances  $CONTAINER_INSTANCE  | jq -r '.containerInstances[0].ec2InstanceId'
}

function getInstanceIp() {
	aws ec2 describe-instances --instance-id $(getInstanceId) | jq -r '.Reservations[0].Instances[0].NetworkInterfaces[0].Association.PublicIp'
}

registerTask $TASK > /dev/null
ID=$(runTask $CLUSTER $TASK)
echo $ID 
getState $CLUSTER $ID
while [ "$(getStatus)" == PENDING ] ; do
	printSummary
	sleep 1
	getState $CLUSTER $ID
done
printSummary

IP=$(getInstanceIp)
ssh ec2-user@$IP <<!
docker logs \$(docker ps -a | grep mvanholsteijn/ecs-bug | head -1 | awk '{print \$1}')
!
