resource "aws_db_instance" "mysql" {
  allocated_storage = 10
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"
  identifier = "mydb"
  username = "dbuser"
  password = "dbpassword"

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.my_db_subnet_group.name

  skip_final_snapshot = true
}

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name = "my-db-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

  tags = {
    Name = "My DB Subnet Group"
  }
}

resource "aws_security_group" "rds_sg" {
  name_prefix = "rds-"

  vpc_id = aws_vpc.my_vpc.id

  # Add any additional ingress/egress rules as needed
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "rds_hostname" {
  value = aws_db_instance.mysql.endpoint
}


/*
how to create data inside new rds:
0. install mysql on new ec2
1. mysql -h mydb.crgmui4a48ii.us-east-1.rds.amazonaws.com -u dbuser -p
2. CREATE DATABASE my_database;
3. USE my_database;
4. CREATE TABLE users (
    ->     id INT AUTO_INCREMENT PRIMARY KEY,
    ->     username VARCHAR(50) NOT NULL,
    ->     email VARCHAR(100) NOT NULL
    -> );
5. SHOW TABLES;
6. INSERT INTO users (username, email) VALUES ('john_doe', 'john@example.com');
7. SELECT * FROM users;


consider doing rds and bastion as pre requisites
*/