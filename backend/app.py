# app.py
import os
from flask import Flask, jsonify
import mysql.connector

app = Flask(__name__)

# Function to establish connection to MySQL database and fetch data
def fetch_data_from_mysql():
    try:
        # Fetch the host name from the environment variable
        db_hostname = os.environ.get('DB_HOSTNAME')
        
        # Establish connection to MySQL database hosted on Amazon RDS
        conn = mysql.connector.connect(
            host=db_hostname,
            user='dbuser',
            password='dbpassword',
            database='database'
        )
        
        # Create cursor
        cursor = conn.cursor()

        # Execute query to fetch data (replace this query with your actual SQL query)
        cursor.execute("SELECT * FROM your_table_name")

        # Fetch all rows
        rows = cursor.fetchall()

        # Close cursor and connection
        cursor.close()
        conn.close()

        # Return fetched data
        return rows
    
    except Exception as e:
        print("Error fetching data from MySQL:", e)
        return None

@app.route('/Labcom-task')
def get_data():
    # Fetch data from MySQL database
    data = fetch_data_from_mysql()

    # If data is fetched successfully, return it as JSON
    if data:
        return jsonify(data)
    else:
        return jsonify({"error": "Failed to fetch data from MySQL database"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
