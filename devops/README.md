# DevOps

This website's infra is managed by Terraform. Look for files with the `.tf` extension in the devops folder for details.

## Terraform

We're hosted on a Google Could Platform (GCP) instance, so the deployment machine must have a credentials file with Project Editor access to the FerreiraRocks project with name "FerreiraRocks-542aab0986e4.json".

The existing terraform scripts set up the instance and configure its network.
