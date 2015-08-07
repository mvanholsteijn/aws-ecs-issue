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

registerTask $TASK
ID=$(runTask $CLUSTER $TASK)
getState $CLUSTER $ID
while [ "$(getStatus)" == PENDING ] ; do
	printSummary
	sleep 1
	getState $CLUSTER $ID
done
printSummary
