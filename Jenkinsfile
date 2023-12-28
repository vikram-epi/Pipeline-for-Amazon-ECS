properties([parameters([choice(choices: ['Terraform-ECS-Fargate'], name: 'Terraform-ECS-Fargate'), choice(choices: ['plan', 'apply', 'destroy'], name: 'Terraform_Action')])])
pipeline {
    agent any
    environment {
        registry = "public.ecr.aws/g2b6m8b9/helloworldrepo"
    }    
    stages {
        stage('Preparing') {
            steps {
                sh 'echo Preparing'
            }
        }
        stage('Git Pulling') {
            steps {
                cleanWs()
                git branch: 'main', url: 'https://github.com/vikram-epi/Pipeline-for-Amazon-ECS.git'
            }
        }
        stage('Build docker image') {
            steps {
                script {
                    docker.build registry
                }
            }
        }
        stage('Push into ECR') {
            steps {
                sh"aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/g2b6m8b9"
                sh"docker build -t hello_world ."
                sh"docker tag hello_world:latest public.ecr.aws/g2b6m8b9/helloworldrepo"
                sh"docker push hello_world:latest public.ecr.aws/g2b6m8b9/helloworldrepo/hello_world:latest"
            }
        }
        stage('Terraform Init') {
            steps {
                script {
                    dir('./terraform/accounts/dev/ecs'){
                    sh 'terraform init'
                    sh 'terraform plan -input=false -out tfplan'
                    sh 'terraform show -no-color tfplan > tfplan.txt'
                    def plan = readFile 'tfplan.txt'
                    def returnCode = sh(script: 'grep "Your infrastructure matches the configuration" tfplan.txt', returnStdout: true, returnStatus: true)
                    if (returnCode == 1) {
                    timeout(time: 10, unit: 'MINUTES') {
                    input message: "Do you want to apply the plan?",
                          parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                                    }
                                    sh "terraform apply --auto-approve"
                                }                                                                                  
                }}
            }
        }
        
    }
         
    }
