node{
   stage('SCM Checkout'){
       git credentialsId: 'git-creds', url: 'https://github.com/Gurusowjith/Vedika-Service.git'
   }
   
   stage('gradle Package'){
     def gradleHome = tool name: 'gradle', type: 'gradle'
     def gradleCMD = "${gradleHome}/bin/gradle"
     sh "${gradleCMD} clean build"
   } 
   
   stage('installing Docker'){
   sh label: '', script: '''sudo apt update -y
sudo apt upgrade -y
echo Install Prerequisite Packages
sudo apt-get install curl apt-transport-https ca-certificates software-properties-common -y
echo Add the Docker Repositories
echo we add the GPG key, by entering the following command in the command line:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - 
echo Next, we add the repository:
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y
echo just update the repository information:
sudo apt update -y
echo Install Docker on Ubuntu 
sudo apt install docker-ce -y'''
   }
 
   stage('ansible installing'){
   sh label: '', script: '''#!/bin/bash
   echo this script done by shiva
   echo Installing software-properties-common packages, then add the java OpenJDK PPA repository.
   sudo apt install software-properties-common apt-transport-https -y
   sudo add-apt-repository ppa:openjdk-r/ppa -y
   Now installing the Java 8 using apt command.
   sudo apt install openjdk-8-jdk -y
   echo java version installed on the system.
   java -version
   echo updating and upgrading the version
   sudo apt-get update -y
   sudo apt-get upgrade -y
   echo Ansible PPA to your server
   sudo apt-add-repository ppa:ansible/ansible \' \'
   echo update the repository and install Ansible
   sudo apt-get update -y
   sudo apt-get install ansible -y
   echo Ansible version
   sudo ansible --version'''
   }
   
 stage('installing Docker'){
   sh label: '', script: '''cd /opt
cat >docker.sh <<\'EOF\'
sudo apt update -y
sudo apt upgrade -y
echo Install Prerequisite Packages
sudo apt-get install curl apt-transport-https ca-certificates software-properties-common -y
echo Add the Docker Repositories
echo we add the GPG key, by entering the following command in the command line:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - 
echo Next, we add the repository:
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y
echo just update the repository information:
sudo apt update -y
echo Install Docker on Ubuntu 
sudo apt install docker-ce -y'''
   }
 
stage('Docker file'){
sh label: '', script: '''cd /var/lib/jenkins/workspace/Docker.pipeline'''
sh label: '', script: '''cat >Dockerfile <<\'EOF\'
FROM java:8-jdk-alpine
COPY ./build/libs/functionhall-service-0.0.1-SNAPSHOT.jar /usr/app/
WORKDIR /usr/app
EXPOSE 8057
ENTRYPOINT ["java", "-jar", "functionhall-service-0.0.1-SNAPSHOT.jar"]'''
}
 
 stage('Creating Image'){
 sh label: '', script: 'sudo docker build -t service .'
   }
   
   stage('converting Image'){
   sh label: '', script: 'sudo docker save -o /home/ubuntu/service.tar service'
   }
 
 
  stage('permissions ansible dir'){
   sh label: '', script: '''sudo chmod 777 /etc/ansible/
   '''
   }
   stage('permissions ansible dir'){
   sh label: '', script: '''sudo chmod 777 /etc/ansible/hosts
   '''
   }
   
   stage('permissions ansible dir'){
   sh label: '', script: '''sudo mv /etc/ansible/hosts /opt
   '''
   }
   
   stage('adding ansible hosts'){
   sh label: '', script: '''cd /etc/ansible
   cat >hosts <<\'EOF\'
   [hosts]
   52.66.204.33
   '''
   }
 
 stage('creating playbook'){
 sh label: '', script: '''cd /opt/
sudo echo "---
-
  hosts: 34.205.41.234
  tasks:
    vars:
    ansible_python_interpreter: /usr/bin/python3
  tasks:  
  
    -
      copy:
        src:  /home/ubuntu/service.tar
        dest: /home/ubuntu/
    -
      copy:
        src:  /opt/docker.sh
        dest: /home/ubuntu/
    -
       shell: sudo chmod +x /home/ubuntu/docker.sh
    -
       shell: sudo sh /home/ubuntu/docker.sh
    -
       shell: sudo docker load -i /home/ubuntu/service.tar
    -
       shell: sudo docker run -i -t -d -p 8057:8057 --name service.container service //bin/bash" > service.yaml'''
  }
      
      stage('execution playbook'){
       sh label: '', script: '''cd /opt/
       sudo ansible-playbook service.yaml'''
       }
}
