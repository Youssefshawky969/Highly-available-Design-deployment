#!/bin/bash
            echo "DB Endpoint: ${db_endpoint}"
            echo "DB Name: ${db_name}"
            echo "DB User: ${db_user}"
            echo "DB Password: ${db_password}"
            yum update -y
            yum install -y python3
            pip3 install flask pymysql
            echo 'from flask import Flask
            import pymysql
            app = Flask(__name__)
            
            def connect_db():
                return pymysql.connect(
                    host= "aws_db_instance.rds_instance.address",
                    user="admin",
                    password="admin1234",
                    database="mydatabase"
                )
            
            @app.route("/")
            def hello():
                connection = connect_db()
                with connection.cursor() as cursor:
                    cursor.execute("SELECT 'Hello, RDS!'")
                    result = cursor.fetchone()
                connection.close()
                return result[0]

            if __name__ == "__main__":
                app.run(host="0.0.0.0")' > /home/ec2-user/app.py
            python3 /home/ec2-user/app.py &