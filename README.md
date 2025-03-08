## AWS infra setup using Terraform
### Directory Structure
    - **setup**
        - Contains file regarding IAM policies and Backend server
    - **infra**
        - configuration files for infra setup including networking
    

#### TODO
    - Make all the entire project use remote backend to tf-statefiles and move it from local for security
    - Use proper access management(IAM) for the above infra setup with correct aws profile following principle of least privilage