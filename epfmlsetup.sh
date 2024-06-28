#!/usr/bin/env bash

#Needs to be executed with WSL, and be given executable permission

#Download kubectl, give right permissions and move it
#We put version v1.27.0 because server kubectl version is v1.26.0 and we want the difference in 
#version to be 1 or less
curl -LO "https://dl.k8s.io/release/v1.27.0/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
sudo chown root: /usr/local/bin/kubectl

#Download runai CLI, give right permissions and move it
wget --content-disposition https://rcp-caas-test.rcp.epfl.ch/cli/linux
chmod +x ./runai
sudo mv ./runai /usr/local/bin/runai
sudo chown root: /usr/local/bin/runai

runai version

#Runai
#Set the GASPAR_USERNAME bash variable
GASPAR_USERNAME='easselin'
# Switch to the IC cluster
runai config cluster ic-context
#Login to the cluster
runai login
#Verify the login has been successful
runai list projects
#Set the default project
runai config project mlo-$GASPAR_USERNAME
#Switch to the RCP cluster
runai config cluster rcp-context
#Login to the cluster
runai login
#Verify the login has been successful
runai list projects
#Set the default project
runai config project mlo-$GASPAR_USERNAME

# We need to delete the job first if this command has run before, two jobs can't have the same name
# Try to submit a job that mounts our shared storage and see its content.
runai submit \
     --name setup-test-storage \
     --image ubuntu \
     --pvc runai-mlo-$GASPAR_USERNAME-scratch:/mloscratch \
     -- ls -la /mloscratch/homes
# Check the status of the job
runai describe job setup-test-storage
# Check its logs to see that it ran.
runai logs setup-test-storage
# Delete the successful jobs
runai delete jobs setup-test-storage

