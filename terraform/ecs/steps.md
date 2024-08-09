1. create vpc along with :-
        - IGW
        - Private and Public subnets
        - NAT
        ! those are configured based on the tf module

2. Create Security Group for the VPC specifying ingress and egress rules
     
     [resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)
    
3. create loadbalancer with 
        - Target group
        - Listeners 

        ! the alb should be created with the public subnet configuration , so that alb will create lb capacity in them and traffic will route according to route table 
        
        [resource](https://docs.aws.amazon.com/prescriptive-guidance/latest/load-balancer-stickiness/subnets-routing.html)


4. create ECS cluster

5. create EC2 launch template with 
        - specific image id and appropriate instance type , which is found from the console
        - allocate additional ebs volume if it is needed,
        - attach the instance to the cluster via cli(user_data.sh)
        - create a public and private key to connect to the instance over SSH. the private key is being created on the local machine(this machine) with the read-only permission for the owner(chmod 400)
        - create and attach instance role/profile

        [volume-block](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/block-device-mapping-concepts.html)
    
6. create autoscaling group based on the instance template with 
        - min, desired and maximum instance amount
        - tag also needs to include "AmazonECSManaged"

7. create capacity providers with appropriate provider configuration of
        => capacity provider
            - required autoscaling group
            - scaling amount
        => capacity providers
            - list of capacity providers(1 or more)
            - default capacity provider


8. define task with
        - roles and policies if the container needs to access AWS API(like s3 ...)
        - cpu, memory, port
        - environment variables can be passed as 
                - .env which is stored in s3, but ECS must have a role(permission) to read it
                - aws secret ...
                - local variables
        
        [task-definition](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#volumes)
        [task-container-definition resource](https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_ContainerDefinition.html)


9. define service with
        - role for service , if it is needed
        - network configuration, capacity provider, loadbalancer target group ...
        - also I am using service connect for the service to discover and connect to services, and be discovered by, and connected from, other services within a namespace.
        
        [resource](https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_ServiceConnectConfiguration.html)

ALB , target group and nginx
- alb has 2 listeners . one for http(80) and one for https(443). the http is forwarded to https and the TLS/SSL certification is handled here. then it will forward the request to http target group.since the TLS/SSL termination is handled on the ALB, the nginx accepts only the http(80) on the http_target group.
