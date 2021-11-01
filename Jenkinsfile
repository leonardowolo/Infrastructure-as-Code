pipeline{
    agent any
    tools {
        terraform 'Terraform'
    }
    environment {
        TF_HOME = tool('Terraform')
        TF_IN_AUTOMATION = "true"
        PATH = "$TF_HOME:$PATH"
    }

    stages {
        stage('Terraform Init'){
            steps {
                    ansiColor('xterm') {
                    withCredentials([azureServicePrincipal(
                    credentialsId: 'AzureServicePrincipal',
                    subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',
                    clientIdVariable: 'ARM_CLIENT_ID',
                    clientSecretVariable: 'ARM_CLIENT_SECRET',
                    tenantIdVariable: 'ARM_TENANT_ID'
                ), string(credentialsId: 'AccessKey', variable: 'ARM_ACCESS_KEY')]) {

                        sh """
                        echo "Initialising Terraform"
                        terraform init -reconfigure -upgrade -backend-config='AccessKey=$ARM_ACCESS_KEY'
                        terraform state replace-provider -auto-approve registry.terraform.io/-/vault registry.terraform.io/hashicorp/vault
                        """
                           }
                    }
             }
        }

        stage('Terraform Validate'){
            steps {
                    ansiColor('xterm') {
                    withCredentials([azureServicePrincipal(
                    credentialsId: 'AzureServicePrincipal',
                    subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',
                    clientIdVariable: 'ARM_CLIENT_ID',
                    clientSecretVariable: 'ARM_CLIENT_SECRET',
                    tenantIdVariable: 'ARM_TENANT_ID'
                ), string(credentialsId: 'AccessKey', variable: 'ARM_ACCESS_KEY')]) {

                        sh """
                        terraform validate
                        """
                           }
                    }
             }
        }

        stage('Terraform Plan'){
            steps {
                    ansiColor('xterm') {
                    withCredentials([azureServicePrincipal(
                    credentialsId: 'AzureServicePrincipal',
                    subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',
                    clientIdVariable: 'ARM_CLIENT_ID',
                    clientSecretVariable: 'ARM_CLIENT_SECRET',
                    tenantIdVariable: 'ARM_TENANT_ID'
                ), string(credentialsId: 'AccessKey', variable: 'ARM_ACCESS_KEY')]) {

                        sh """
                        echo "Creating Terraform Plan"
                        terraform plan -var 'client_id=$ARM_CLIENT_ID' -var 'client_secret=$ARM_CLIENT_SECRET' -var 'subscription_id=$ARM_SUBSCRIPTION_ID' -var 'tenant_id=$ARM_TENANT_ID'
                        """
                        }
                }
            }
        }

        stage('Waiting for Approval'){
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    input (message: "Deploy the infrastructure?")
                }
            }

        }


        stage('Terraform Apply'){
            steps {
                    ansiColor('xterm') {
                    withCredentials([azureServicePrincipal(
                    credentialsId: 'AzureServicePrincipal',
                    subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',
                    clientIdVariable: 'ARM_CLIENT_ID',
                    clientSecretVariable: 'ARM_CLIENT_SECRET',
                    tenantIdVariable: 'ARM_TENANT_ID'
                ), string(credentialsId: 'AccessKey', variable: 'ARM_ACCESS_KEY')]) {

                        sh """
                        echo "Applying the plan"
                        terraform apply -auto-approve -var 'client_id=$ARM_CLIENT_ID' -var 'client_secret=$ARM_CLIENT_SECRET' -var 'subscription_id=$ARM_SUBSCRIPTION_ID' -var 'tenant_id=$ARM_TENANT_ID'
                        """
                                }
                }
            }
        }

    }
}