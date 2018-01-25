# Mistral workflows

## Structure

The repository is divided in several folders:

* dev: workflows and workbooks in development right now
* scripts: series of scripts used for the CI/CD integration
* templates: location of mail templates
* workbooks: repository of workbooks currently in production
* workflows: repository of workflows currently in production

## Examples about how to execute workflows with CLI
```bash
# Create a workflow
$ mistral workflow-create project_delete.yaml

# Execute project delete workflow
$ mistral execution-create project_delete '{"id": "b11d59260c134a68a7d5116139e3a673"}'
```
