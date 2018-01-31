#!/bin/bash
#
# Uploads the mistral workflows to the infrastructure.
#
# PARAMS:
#   - CI_PROJECT_DIR
#        the location of the code (including the spec file). if using gitlab
#        this is predefined by the runner
#   - MISTRALCI_PASSWORD
#        the password of the mistralci. if using gitlab define this in Settings/Variables
#   - OS_AUTH_URL
#   - OS_AUTH_TYPE
#   - OS_MUTUAL_AUTH
#   - OS_IDENTITY_API_VERSION
#   - OS_PROJECT_DOMAIN_ID
#   - OS_PROJECT_NAME
#        Openstack credentials to upload the workbooks/workflows into the service

cd $CI_PROJECT_DIR

# Connect using kerberos credentials
echo $MISTRALCI_PASSWORD | kinit mistralci@CERN.CH

# Retrieve the list of workbooks in the project
WORKBOOKS=$(openstack workbook list -f value -c Name)

# Check workbooks and update them if required
for file in workbooks/*.yaml; do
    [ -e "$file" ] || continue
    filename=${file##*/}
    name=${filename%.*}
    if [[ " ${WORKBOOKS[@]} " =~ "${name}" ]]; then
        # Workflow existed previously check the scope to update accordingly
        scope=$(openstack workbook show $name -f value -c Scope)
        if [ "$scope" == "public" ]; then
	    # The workbook is public update it with public parameter
            echo "openstack workbook update --public $file"
            openstack workbook update --public $file
        else
            # The workbook is not public just update it
            echo "openstack workbook update $file"
            openstack workbook update $file
        fi  
    else
         # The workbook does not exist, just create it
         echo "openstack workbook create $file"
         openstack workbook create $file
    fi 
done

# Retrieve the list of worflows in the project
WORKFLOWS=$(openstack workflow list -f value -c Name)

# Check workflows and update them if required
for file in workflows/*.yaml; do
    [ -e "$file" ] || continue
    filename=${file##*/}
    name=${filename%.*}
    if [[ " ${WORKFLOWS[@]} " =~ "${name}" ]]; then
        # Workflow existed previously check the scope to update accordingly
        scope=$(openstack workflow show $name -f value -c Scope)
        if [ "$scope" == "public" ]; then
            # The workflow is public update it with public as parameter
            echo "openstack workflow update --public $file"
            openstack workflow update --public $file
        else
            # The workflow is not public just update it
            echo "openstack workflow update $file"
            openstack workflow update $file
        fi
    else
        # The workflow does not exist, just create it
        echo "openstack workflow create $file"
        openstack workflow create $file
    fi
done
