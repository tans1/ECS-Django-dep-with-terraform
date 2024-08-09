
Route 53 nameservers may take up to 48 hours to propagate DNS changes worldwide after being configured in the domain registry.
we can track that on the 
- [https://www.whatsmydns.net](https://www.whatsmydns.net)
- [https://dnschecker.org](https://dnschecker.org)

[why does it take 60 seconds - 48 hours?](https://www.siteground.com/kb/dns-propagation/#:~:text=Typically%2C%20DNS%20propagation%20takes%2024,may%20cause%20DNS%20propagation%20delays.)

1. using nginx along with alb might not be necessary as alb will handle what nginx does.like ssl/tls termination, loadbalancing, routing....
we can leave it out, but I just used it 😄


2. this is a general implementation that can be used with any techstack not only for django
 


3. here I am using docker images from dockerhub not from ECR, I want to save my ECR free tier for another side projects, 😄
but If it is required to use ECR, I should create a policy and attach the role to EC2 to use ECR image