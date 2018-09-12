#!/bin/bash
#
# Validates the mistral workflows to the infrastructure.
#
# PARAMS:
#   - CI_PROJECT_DIR
#        the location of the code (including the spec file). if using gitlab
#        this is predefined by the runner
#   - MISTRALCI_PASSWORD
#        the password of the mistralci. if using gitlab define this in Settings/Variables
#   - OS_CLOUD
#        Cloud against we are validating the changes

cd $CI_PROJECT_DIR

# Copy locally the clouds.yaml to use the credentials
echo "Copy the file with the cloud auth methods"
cp scripts/clouds.yaml ./

# Connect using kerberos credentials
echo $MISTRALCI_PASSWORD | kinit mistralci@CERN.CH

# default exit code
code=0

# Check workbooks and validate them
for file in workbooks/*.yaml; do
    [ -e "$file" ] || continue
    echo "Validating $file"
    error=$(openstack workbook validate $file -f value -c Error | head -1)
    if [ "$error" != "None" ]; then
        echo "Validation failed on $file please check error '$error'"
        code=1
    fi
done

# Check workflows and validate them
for file in workflows/*.yaml; do
    [ -e "$file" ] || continue
    echo "Validating $file"
    error=$(openstack workflow validate $file -f value -c Error | head -1)
    if [ "$error" != "None" ]; then
        echo "Validation failed on $file please check error '$error'"
        code=1
    fi
done

echo "Validation finished with code: $code"
exit $code
