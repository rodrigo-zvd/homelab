pipeline {
  agent any

  environment {
    XOA_USER = credentials('xoa_user')
    XOA_PASSWORD = credentials('xoa_password')
    AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
    AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
    JENKINS_PUB_KEY = credentials('jenkins-pub-key')
  }
  
  parameters {
    choice(
      name: 'CREATE_OR_DESTROY',
      choices: ['Create', 'Destroy'],
      description: 'Would you like to create or destroy the Kubernetes cluster?'
    )
    booleanParam(
      name: 'DEBUG',
      defaultValue: false,
      description: 'Se ativado, exporta os valores das credenciais como artefatos para depuração'
    )
  }

  stages {

    stage('Exportar credenciais para artefatos') {
      when {
        expression { return params.DEBUG }
      }
      steps {
        withCredentials([
          string(credentialsId: 'xoa_user', variable: 'REAL_XOA_USER'),
          string(credentialsId: 'xoa_password', variable: 'REAL_XOA_PASSWORD'),
          string(credentialsId: 'aws_access_key_id', variable: 'REAL_AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'aws_secret_access_key', variable: 'REAL_AWS_SECRET_ACCESS_KEY'),
          string(credentialsId: 'jenkins-pub-key', variable: 'REAL_JENKINS_PUB_KEY'),
          sshUserPrivateKey(credentialsId: 'jenkins-priv-key', keyFileVariable: 'JENKINS_PRIV_KEY'),
        ]) {
          sh '''
            echo "$REAL_XOA_USER" > xoa_user.txt
            echo "$REAL_XOA_PASSWORD" > xoa_password.txt
            echo "$REAL_AWS_ACCESS_KEY_ID" > aws_access_key_id.txt
            echo "$REAL_AWS_SECRET_ACCESS_KEY" > aws_secret_access_key.txt
            echo "$REAL_JENKINS_PUB_KEY" > jenkins_pub_key.txt
            cat "$SSH_PRIVATE_KEY" > jenkins_priv_key.txt
          '''
        }

        archiveArtifacts artifacts: 'xoa_user.txt', onlyIfSuccessful: true
        archiveArtifacts artifacts: 'xoa_password.txt', onlyIfSuccessful: true
        archiveArtifacts artifacts: 'aws_access_key_id.txt', onlyIfSuccessful: true
        archiveArtifacts artifacts: 'aws_secret_access_key.txt', onlyIfSuccessful: true
        archiveArtifacts artifacts: 'jenkins_pub_key.txt', onlyIfSuccessful: true
        archiveArtifacts artifacts: 'jenkins_priv_key.txt', onlyIfSuccessful: true
      }
    }
    
    stage('SSH Keys Deploy') {
      agent {
        docker {
          image 'alpine'
        }
      }
      steps {
        dir('terraform') {
          withCredentials([
            sshUserPrivateKey(credentialsId: 'jenkins-priv-key', keyFileVariable: 'JENKINS_PRIV_KEY'),
            // string(credentialsId: 'xoa_user', variable: 'TF_XOA_USER'),
            // string(credentialsId: 'xoa_password', variable: 'TF_XOA_PASSWORD'),
            // string(credentialsId: 'aws_access_key_id', variable: 'TF_MINIO_ACCESS_KEY_ID'),
            // string(credentialsId: 'aws_secret_access_key', variable: 'TF_MINIO_SECRET_ACCESS_KEY'),
            ]) {
            sh '''
              cat "$JENKINS_PRIV_KEY" > id_ed25519
              echo "$JENKINS_PUB_KEY" > id_ed25519.pub
              #echo "xoa_username = \\"$TF_XOA_USER\\"" > terraform.tfvars
              #echo "xoa_password = \\"$TF_XOA_PASSWORD\\"" >> terraform.tfvars
              #echo "minio_access_key = \\"$TF_MINIO_ACCESS_KEY_ID\\"" >> terraform.tfvars
              #echo "minio_secret_key = \\"$TF_MINIO_SECRET_ACCESS_KEY\\"" >> terraform.tfvars
            '''
            }
        }
      }
    }

    stage('setup terraform endpoints') {
      steps {
        script {
          def minioIp = sh(script: "getent hosts minio | awk '{ print \$1 }'", returnStdout: true).trim()
          env.MINIO_URL = minioIp
          def xoaIp = sh(script: "getent hosts xen-orchestra | awk '{ print \$1 }'", returnStdout: true).trim()
          env.XOA_IP = xoaIp
        }
      }
    }

    stage('Render Terraform Configs') {
      steps {
        withCredentials([
          string(credentialsId: 'minio_access_key', variable: 'MINIO_ACCESS_KEY'),
          string(credentialsId: 'minio_secret_key', variable: 'MINIO_SECRET_KEY'),
          string(credentialsId: 'minio_endpoint',   variable: 'MINIO_ENDPOINT'),
          string(credentialsId: 'xoa_url',          variable: 'XOA_URL'),
          string(credentialsId: 'xoa_user',         variable: 'XOA_USERNAME'),
          string(credentialsId: 'xoa_password',     variable: 'XOA_PASSWORD')
        ]) {
          dir('terraform') {
            sh '''
              docker run --rm \
                -v "$PWD:/work" \
                -e MINIO_ACCESS_KEY \
                -e MINIO_SECRET_KEY \
                -e MINIO_ENDPOINT \
                -e XOA_URL \
                -e XOA_USER \
                -e XOA_PASSWORD \
                hairyhenderson/gomplate \
                -f /work/backend.hcl.tpl -o /work/backend.hcl

              docker run --rm \
                -v "$PWD:/work" \
                -e XOA_URL \
                -e XOA_USER \
                -e XOA_PASSWORD \
                hairyhenderson/gomplate \
                -f /work/terraform.tfvars.tpl -o /work/terraform.tfvars
            '''
          }
        }
      }
    }
  
    stage('init') {
      agent {
        docker {
          image 'hashicorp/terraform:1.11.4'
          args "--entrypoint= --add-host minio:${env.MINIO_URL} --add-host xen-orchestra:${env.XOA_IP}"
        }
      }
      steps {
        dir('terraform'){
        sh '''
          terraform init -no-color -migrate-state -backend-config=backend.hcl
        '''
        }
      }
    }
  
    stage('plan') {
      agent {
        docker {
          image 'hashicorp/terraform:1.11.4'
          args "--entrypoint= --add-host minio:${env.MINIO_URL} --add-host xen-orchestra:${env.XOA_IP}"
        }
      }
      steps {
        dir('terraform'){
              sh '''
                terraform plan -no-color -var-file=terraform.tfvars
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
          image 'hashicorp/terraform:1.11.4'
          args "--entrypoint= --add-host minio:${env.MINIO_URL} --add-host xen-orchestra:${env.XOA_IP}"
        }
      }
      steps {
        dir('terraform'){
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

//     // stage('kubespray') {
//     //   agent {
//     //     docker {
//     //       image 'quay.io/kubespray/kubespray:v2.26.0'
//     //       args '--entrypoint="" -u root'
//     //     }
//     //   }
//     //   steps {
//     //     dir('terraform') {
//     //       sh '''
//     //         export ANSIBLE_ROLES_PATH="$ANSIBLE_ROLES_PATH:/kubespray/roles"
//     //         export ANSIBLE_HOST_KEY_CHECKING="False"

//     //         ansible-playbook \
//     //           --become \
//     //           --inventory inventory.ini \
//     //           --extra-vars "kube_network_plugin=flannel" \
//     //           --private-key id_ed25519 \
//     //           /kubespray/cluster.yml
//     //       '''
//     //     }
//     //   }
//     //   when {
//     //     expression {
//     //       params.CREATE_OR_DESTROY == "Create"
//     //     }
//     //   }
//     // }

    stage('destroy') {
      agent {
        docker {
          image 'hashicorp/terraform:1.11.4'
          args "--entrypoint= --add-host minio:${env.MINIO_URL} --add-host xen-orchestra:${env.XOA_IP}"
        }
      }
      steps {
        dir('terraform') {
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