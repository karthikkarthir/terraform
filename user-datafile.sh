
!#/bin/bash
sudo yum -y update && yum install -y docker
systemctl start docker
sudo usermod -aG docker ec2-user 
docker run -p 8080:80 nginx