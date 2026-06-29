pipeline {
    agent any

    environment {
        IMAGE_NAME = "your-dockerhub-username/java-k8s-app"
        TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/your-repo/java-k8s-app.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Static Code Scan (Optional SonarQube)') {
            steps {
                echo "Run SonarQube analysis here if configured"
            }
        }

        stage('Security Scan (Trivy)') {
            steps {
                sh """
                trivy fs . || true
                """
            }
        }

        stage('Docker Build') {
            steps {
                sh """
                docker build -t $IMAGE_NAME:$TAG .
                """
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                    usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh """
                    echo $PASS | docker login -u $USER --password-stdin
                    docker push $IMAGE_NAME:$TAG
                    """
                }
            }
        }

        stage('Tag Repo') {
            steps {
                sh """
                git tag v$TAG
                git push origin v$TAG
                """
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully"
        }
        failure {
            echo "Pipeline failed"
        }
    }
}
