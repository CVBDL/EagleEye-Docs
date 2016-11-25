#! /bin/bash

option="$1"
taskId=${option:10}
apiEndpoint="http://localhost:3000/api/v1/tasks/"$taskId

curl -H "Content-Type: application/json" -X PUT -d '{"state":"failure"}' $apiEndpoint --silent > /dev/null

printf "Done.\n"
