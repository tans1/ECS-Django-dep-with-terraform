pipeline {
    agent any

    environment {
        IS_PR = "${env.CHANGE_ID != null}"
        ORIGIN_BRANCH = "$env.CHANGE_BRANCH"
        TARGET_BRANCH = "$env.CHANGE_TARGET"
        PR_NAME = "$env.CHANGE_TITLE"
        PR_AUTHOR = "$env.CHANGE_AUTHOR"
        CURRENT_BRANCH = "$env.BRANCH_NAME"

        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials-id')  
        REGISTRY = credentials('docker-hub-registry')
        AWS_CREDENTIALS = credentials('aws-credentials-id')  

        DJANGO_IMAGE_NAME = "django-ecs"
        NGINX_IMAGE_NAME = "nginx-ecs"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Notify PR'){
            when {
                expression {IS_PR.toBoolean()}
            }
            steps{
                echo "$PR_AUTHOR sent a $PR_NAME PR"
            }
        }

        stage('Test') {
            when {
                expression { IS_PR.toBoolean() }
            }
            steps {
                echo "Running a test before pr is merged to the target branch.."
            }
        }

        stage('Build'){
            when {
                expression { CURRENT_BRANCH == "main" || CHANGE_BRANCH == "uat"}
            }
            steps{
                echo "build the docker image"
                
                script {
                    dir('main') {
                        docker.build("${env.REGISTRY}/${env.DJANGO_IMAGE_NAME}:${env.BUILD_NUMBER}")
                    }
                    dir('nginx') {
                        docker.build("${env.REGISTRY}/${env.NGINX_IMAGE_NAME}:${env.BUILD_NUMBER}")
                    }
                }
            }
        }

        

        stage('Push image'){
            when {
                expression { CURRENT_BRANCH == "main" || CHANGE_BRANCH == "uat" } 
            }
            steps{
                
                script {
                     docker.withRegistry("https://${env.REGISTRY}", 'DOCKERHUB_CREDENTIALS') {

                        docker.image("${env.REGISTRY}/${env.DJANGO_IMAGE_NAME}:${env.BUILD_NUMBER}").push()

                        docker.image("${env.REGISTRY}/${env.NGINX_IMAGE_NAME}:${env.BUILD_NUMBER}").push()
                    }
                }
            }
        }



        stage('Deploy') {
            when {
                expression { CURRENT_BRANCH == "main" || CHANGE_BRANCH == "uat" }
            }
            steps {
                echo 'deploy it on the AWS'
                echo "doing deployment stuff.."

                def stage
                if (env.BRANCH_NAME == 'main') {
                    stage = "prod"
                } else if (env.BRANCH_NAME == 'uat') {
                    stage = "uat"
                } else {
                    stage = "dev" 
                }

                def DJANGO_IMAGE = "docker.io/${env.REGISTRY}/${env.DJANGO_IMAGE_NAME}:${env.BUILD_NUMBER}"
                def NGINX_IMAGE = "docker.io/${env.REGISTRY}/${env.NGINX_IMAGE_NAME}:${env.BUILD_NUMBER}"

                withCredentials([file(credentialsId: 'TERRAFORM_VARS', variable: 'TF_VARS_FILE'), 
                [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_CREDENTIALS']]) {
                    sh """
                    cd terraform/ecs
                    terraform init
                    terraform apply \
                        -var "django_image=${DJANGO_IMAGE}" \
                        -var "nginx_image=${NGINX_IMAGE}" \
                        -var-file="$TF_VARS_FILE" \
                        -auto-approve
                    """
                }
            }
        }
    }
}