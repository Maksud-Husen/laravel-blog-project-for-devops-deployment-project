pipeline {
    agent any

    stages {
        stage("Remove old project") {
            steps {
                echo "Removing old project if exists"
                script {
                    sh '''
                        rm -rf laravel-blog-project-for-devops-deployment-project'''
                }
            }
        }

        stage("Clone project") {
            steps {
                echo "Cloning project"
                script {
                    sh 'git clone https://github.com/Maksud-Husen/laravel-blog-project-for-devops-deployment-project.git'
                }
            }
        }

        stage("Run Ansible") {
            steps {
                echo "Running ansible playbook"
                script {
                    sh '''cd laravel-blog-project-for-devops-deployment-project
                    echo "Contents of repo:"
                    ls -la
                    echo "Running playbook..."
                    ansible-playbook -i inventory.ini service.yml
                    '''
                }
            }
        }
    }
}
