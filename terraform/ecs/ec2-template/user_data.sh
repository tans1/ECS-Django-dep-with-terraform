#!/bin/bash

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

yum update -y
yum install -y amazon-cloudwatch-agent docker amazon-ssm-agent

# Start Docker service
service docker start
usermod -a -G docker ec2-user


# Start SSM Agent service
service amazon-ssm-agent start
chkconfig amazon-ssm-agent on


adduser -m ssm-user
tee /etc/sudoers.d/ssm-agent-users <<'EOF'
# User rules for ssm-user
ssm-user ALL=(ALL) NOPASSWD:ALL
EOF
chmod 440 /etc/sudoers.d/ssm-agent-users 
# Now adding the ssm-user works!
usermod -a -G docker ssm-user

echo ECS_CLUSTER=${cluster_name} >> /etc/ecs/ecs.config
echo "Hello world"