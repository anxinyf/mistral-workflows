#!/bin/sh

id=$(python -c "import uuid; print uuid.uuid4()")
name="My workflow testing"
description="Just a test"
enabled=false
owner="wiebalck"


### Test project_create.init

output=$(openstack workflow execution create -f json project_create.init "{\"id\": \"$id\", \"name\": \"$name\", \"description\": \"$description\", \"enabled\": $enabled, \"owner\": \"$owner\"}")
echo $output

workflow_id=$(echo $output | jq '.[] | select(.Field == "ID").Value' | tr -d '"')
echo "My workflow id is: $workflow_id"

state=$(openstack workflow execution show -f json $workflow_id | jq '.[] | select(.Field == "State").Value' | tr -d '"')

while [ "$state" == "RUNNING" ]; do
  echo "Waiting until workflow finishes"
  state=$(openstack workflow execution show -f json $workflow_id | jq '.[] | select(.Field == "State").Value' | tr -d '"')
  sleep 1
done

echo "Project created: "
openstack workflow execution output show $workflow_id
project_id=$(openstack workflow execution output show $workflow_id | jq '.openstack_id' | tr -d '"')
openstack project show $project_id

### Test project_get.init

output=$(openstack workflow execution create -f json project_get.init "{\"id\": \"$id\"}")
echo $output

workflow_id=$(echo $output | jq '.[] | select(.Field == "ID").Value' | tr -d '"')
echo "My workflow id is: $workflow_id"

state=$(openstack workflow execution show -f json $workflow_id | jq '.[] | select(.Field == "State").Value' | tr -d '"')

while [ "$state" == "RUNNING" ]; do
  echo "Waiting until workflow finishes"
  state=$(openstack workflow execution show -f json $workflow_id | jq '.[] | select(.Field == "State").Value' | tr -d '"')
  sleep 1
done

echo "Project GET: "
openstack workflow execution output show $workflow_id

### Test project_get.detailed

output=$(openstack workflow execution create -f json project_get.detailed "{\"id\": \"$id\"}")
echo $output

workflow_id=$(echo $output | jq '.[] | select(.Field == "ID").Value' | tr -d '"')
echo "My workflow id is: $workflow_id"

state=$(openstack workflow execution show -f json $workflow_id | jq '.[] | select(.Field == "State").Value' | tr -d '"')

while [ "$state" == "RUNNING" ]; do
  echo "Waiting until workflow finishes"
  state=$(openstack workflow execution show -f json $workflow_id | jq '.[] | select(.Field == "State").Value' | tr -d '"')
  sleep 1
done

echo "Project GET (detailed): "
openstack workflow execution output show $workflow_id

### Test project_get.all

output=$(openstack workflow execution create -f json project_get.all)
echo $output

workflow_id=$(echo $output | jq '.[] | select(.Field == "ID").Value' | tr -d '"')
echo "My workflow id is: $workflow_id"

state=$(openstack workflow execution show -f json $workflow_id | jq '.[] | select(.Field == "State").Value' | tr -d '"')

while [ "$state" == "RUNNING" ]; do
  echo "Waiting until workflow finishes"
  state=$(openstack workflow execution show -f json $workflow_id | jq '.[] | select(.Field == "State").Value' | tr -d '"')
  sleep 1
done

echo "Project ALL (detailed): "
openstack workflow execution output show $workflow_id  | head -10

### Test project_update.init

update_name="UPDATED My workflow testing"
update_description="UPDATED Just a test"
update_owner="vaneldik"
update_enabled=true

output=$(openstack workflow execution create -f json project_update.init "{\"id\": \"$id\", \"name\": \"$update_name\", \"description\": \"$update_description\", \"enabled\": $update_enabled, \"owner\": \"$update_owner\"}")
echo $output

workflow_id=$(echo $output | jq '.[] | select(.Field == "ID").Value' | tr -d '"')
echo "My workflow id is: $workflow_id"

state=$(openstack workflow execution show -f json $workflow_id | jq '.[] | select(.Field == "State").Value' | tr -d '"')

while [ "$state" == "RUNNING" ]; do
  echo "Waiting until workflow finishes"
  state=$(openstack workflow execution show -f json $workflow_id | jq '.[] | select(.Field == "State").Value' | tr -d '"')
  sleep 1
done

echo "Project UPDATED: "
openstack workflow execution output show $workflow_id
openstack project show $project_id


### Test project_property.update

output=$(openstack workflow execution create -f json project_property.update "{\"project\": \"$id\", \"properties\": {\"fim-lock\": false, \"fim-skip\": false, \"magic\": \"wow\"}}")
echo $output

workflow_id=$(echo $output | jq '.[] | select(.Field == "ID").Value' | tr -d '"')
echo "My workflow id is: $workflow_id"

state=$(openstack workflow execution show -f json $workflow_id | jq '.[] | select(.Field == "State").Value' | tr -d '"')

while [ "$state" == "RUNNING" ]; do
  echo "Waiting until workflow finishes"
  state=$(openstack workflow execution show -f json $workflow_id | jq '.[] | select(.Field == "State").Value' | tr -d '"')
  sleep 1
done

echo "fim-lock and fim-skip should be false"
openstack workflow execution show $workflow_id
openstack project show $project_id


### Test project_property.update

output=$(openstack workflow execution create -f json project_property.list "{\"project\": \"$id\"}")
echo $output

workflow_id=$(echo $output | jq '.[] | select(.Field == "ID").Value' | tr -d '"')
echo "My workflow id is: $workflow_id"

state=$(openstack workflow execution show -f json $workflow_id | jq '.[] | select(.Field == "State").Value' | tr -d '"')

while [ "$state" == "RUNNING" ]; do
  echo "Waiting until workflow finishes"
  state=$(openstack workflow execution show -f json $workflow_id | jq '.[] | select(.Field == "State").Value' | tr -d '"')
  sleep 1
done

echo "List of properties"
openstack workflow execution output show $workflow_id


### Test project_grants.list

output=$(openstack workflow execution create -f json project_grants.list "{\"project\": \"$id\", \"role\": \"Member\"}")
echo $output

workflow_id=$(echo $output | jq '.[] | select(.Field == "ID").Value' | tr -d '"')
echo "My workflow id is: $workflow_id"

state=$(openstack workflow execution show -f json $workflow_id | jq '.[] | select(.Field == "State").Value' | tr -d '"')

while [ "$state" == "RUNNING" ]; do
  echo "Waiting until workflow finishes"
  state=$(openstack workflow execution show -f json $workflow_id | jq '.[] | select(.Field == "State").Value' | tr -d '"')
  sleep 1
done

echo "List of grants"
openstack workflow execution output show $workflow_id

### Test project_grants.add

output=$(openstack workflow execution create -f json project_grants.add "{\"project\": \"$id\", \"role\": \"Member\", \"members\": [\"jcastro\"]}")
echo $output

workflow_id=$(echo $output | jq '.[] | select(.Field == "ID").Value' | tr -d '"')
echo "My workflow id is: $workflow_id"

state=$(openstack workflow execution show -f json $workflow_id | jq '.[] | select(.Field == "State").Value' | tr -d '"')

while [ "$state" == "RUNNING" ]; do
  echo "Waiting until workflow finishes"
  state=$(openstack workflow execution show -f json $workflow_id | jq '.[] | select(.Field == "State").Value' | tr -d '"')
  sleep 1
done

echo "Adding grants"
openstack workflow execution output show $workflow_id

### Test project_grants.revoke

output=$(openstack workflow execution create -f json project_grants.revoke "{\"project\": \"$id\", \"role\": \"Member\", \"members\": [\"jcastro\"]}")
echo $output

workflow_id=$(echo $output | jq '.[] | select(.Field == "ID").Value' | tr -d '"')
echo "My workflow id is: $workflow_id"

state=$(openstack workflow execution show -f json $workflow_id | jq '.[] | select(.Field == "State").Value' | tr -d '"')

while [ "$state" == "RUNNING" ]; do
  echo "Waiting until workflow finishes"
  state=$(openstack workflow execution show -f json $workflow_id | jq '.[] | select(.Field == "State").Value' | tr -d '"')
  sleep 1
done

echo "Revoking grants"
openstack workflow execution output show $workflow_id

### Test project_delete.init

output=$(openstack workflow execution create -f json project_delete.init "{\"id\": \"$id\"}")
echo $output

workflow_id=$(echo $output | jq '.[] | select(.Field == "ID").Value' | tr -d '"')
echo "My workflow id is: $workflow_id"

state=$(openstack workflow execution show -f json $workflow_id | jq '.[] | select(.Field == "State").Value' | tr -d '"')

while [ "$state" == "RUNNING" ]; do
  echo "Waiting until workflow finishes"
  state=$(openstack workflow execution show -f json $workflow_id | jq '.[] | select(.Field == "State").Value' | tr -d '"')
  sleep 1
done

echo "Project deleted: "
openstack workflow execution show $workflow_id
