pipeline {
    agent any

    stages {
        stage("Remove old project") {
            steps {
                echo "Removing old project if exists"
                script {
                    sh '''
                        rm -rf Laravel-From-Scratch-Blog-Project'''
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
                    sh '''cd Laravel-From-Scratch-Blog-Project 
                    echo "Contents of repo:"
                    ls -la
                    echo "Running playbook..."
                    ansible-playbook -i inventory.ini server.yml
                    '''
                }
            }
        }
    }
}
