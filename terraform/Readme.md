## => Using 2 configurations
1. the special/special-provider.tf is used to create S3-bucket and dynamoDb to store the tf state for other resources(ECS) and this state will later used in CICD, so first apply it and and the S3 bucket and DynamoDb will be created with the state on the local machine

2. the other provider(ecs/provider) is used for the other resources



