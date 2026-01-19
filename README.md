# setup infra
**AWS CLI Installation:**

````
sudo apt install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
````
````
aws --version
````
**Terraform Installation:Ubuntu**
````
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
````
````
terraform --version
````
**Set Up aws profile**
````
aws configure --profile "tf-user"
````
-  provide acccess key
-  provide secret key
-  region

**add profile to provider.tf**
```tf
provider "aws {
 region = "ap-southeast-1"
 profile = "tf-user"
}
```

#### Changes:
- **main.tf** instance-type
- **main.tf** bucket-name

**Initialize terraform**
````
terraform init
````
---



### 1. Setup MariaDB 
- wait for cluster and rds creation
- Create MariaDB instance using AWS RDS. and connect to cluster worker node
- Connect to your RDS instance :

```bash
sudo yum update -y
sudo yum install mariadb105-server -y
```
**Login To RDS**
````
mysql -h <rds-endpoint> -u <db-username> -p<password>
````

- Create the database:

```sql
CREATE DATABASE student_db;
```
```
USE student_db;
```

- Create the students table:

```sql
CREATE TABLE `students` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `course` varchar(255) DEFAULT NULL,
  `student_class` varchar(255) DEFAULT NULL,
  `percentage` double DEFAULT NULL,
  `branch` varchar(255) DEFAULT NULL,
  `mobile_number` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
```

- Exit MySQL:

```bash
exit
``
- Note: check port no 3306 added in security group



