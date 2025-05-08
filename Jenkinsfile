pipeline {
  agent any
  environment {
    PM_API_TOKEN_ID = credentials('pm-api-token-id')
    PM_API_TOKEN_SECRET = credentials('pm-api-token-secret')
    AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
    AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    JENKINS_PUB_KEY = credentials('jenkins-pub-key')
  }
  parameters {
    choice(
      name: 'CREATE_OR_DESTROY',
      choices: ['Create', 'Destroy'],
      description: 'Would you like to create or destroy the Kubernetes cluster?'
    )
  }
  stages {
    stage('authentication') {
      agent {
        docker {
          image 'alpine'
        }
      }
      steps {
        dir('kubernetes/02_kubernetes_production_ready/terraform') {
          withCredentials([sshUserPrivateKey(credentialsId: 'jenkins-priv-key', keyFileVariable: 'JENKINS_PRIV_KEY')]) {
            sh '''
              cp "$JENKINS_PRIV_KEY" id_rsa
              echo "$JENKINS_PUB_KEY" > id_rsa.pub
            '''
          }
        }
      }
    }
    stage('init') {
      agent {
        docker {
          image 'hashicorp/terraform:1.9.8'
          args '--entrypoint=""'
        }
      }
      steps {
        dir('kubernetes/02_kubernetes_production_ready/terraform') {
          sh '''
            terraform init -no-color
          '''
        }
      }
    }
    stage('plan') {
      agent {
        docker {
          image 'hashicorp/terraform:1.9.8'
          args '--entrypoint=""'
        }
      }
      steps {
        dir('kubernetes/02_kubernetes_production_ready/terraform') {
          sh '''
            terraform plan -no-color
          '''
        }
      }
      when {
        expression {
          params.CREATE_OR_DESTROY == "Create"
        }
      }
    }
    stage('apply') {
      agent {
        docker {
          image 'hashicorp/terraform:1.9.8'
          args '--entrypoint=""'
        }
      }
      steps {
        dir('kubernetes/02_kubernetes_production_ready/terraform') {
          sh '''
            terraform apply -no-color -auto-approve
          '''
        }
      }
      when {
        expression {
          params.CREATE_OR_DESTROY == "Create"
        }
      }
    }
    stage('kubespray') {
      agent {
        docker {
          image 'quay.io/kubespray/kubespray:v2.26.0'
          args '--entrypoint="" -u root'
        }
      }
      steps {
        dir('kubernetes/02_kubernetes_production_ready/terraform') {
          sh '''
            export ANSIBLE_ROLES_PATH="$ANSIBLE_ROLES_PATH:/kubespray/roles"
            export ANSIBLE_HOST_KEY_CHECKING="False"

            ansible-playbook \
              --become \
              --inventory inventory.ini \
              --extra-vars "kube_network_plugin=flannel" \
              --private-key id_rsa \
              /kubespray/cluster.yml
          '''
        }
      }
      when {
        expression {
          params.CREATE_OR_DESTROY == "Create"
        }
      }
    }
    stage('destroy') {
      agent {
        docker {
          image 'hashicorp/terraform:1.9.8'
          args '--entrypoint=""'
        }
      }
      steps {
        dir('kubernetes/02_kubernetes_production_ready/terraform') {
          sh '''
            terraform apply -destroy -no-color -auto-approve
          '''
        }
      }
      when {
        expression {
          params.CREATE_OR_DESTROY == "Destroy"
        }
      }
    }
  }
}
