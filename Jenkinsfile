node{
   stage('SCM Checkout'){
       git credentialsId: 'git-creds', url: 'https://github.com/shivastunts0327/Vedika-Service.git'
   }
   stage('gradle Package'){
     def gradleHome = tool name: 'gradle', type: 'gradle'
     def gradleCMD = "${gradleHome}/bin/gradle"
     sh "${gradleCMD} clean build"
     } 
   }
                   