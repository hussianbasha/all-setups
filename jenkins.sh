#STEP-1: INSTALLING GIT JAVA-1.8.0 MAVEN 
sudo yum install git -y
sudo yum install java-1.8.0
sudo yum install maven -y

#STEP-2: GETTING THE REPO (jenkins.io --> download -- > redhat)
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

#STEP-3: DOWNLOAD JAVA11 AND JENKINS
sudo yum install java-17-amazon-corretto -y
sudo yum install jenkins -y
update-alternatives --config java

#STEP-4: RESTARTING JENKINS (when we download service it will on stopped state)
sudo systemctl start jenkins.service
sudo systemctl status jenkins.service
