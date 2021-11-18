
import mysql.connector
from mysql.connector import Error



# Create database connection
def create_server_connection(host_name, user_name, user_password):
    connection = None
    try:
        connection = mysql.connector.connect(
            host=host_name,
            user=user_name,
            passwd=user_password
        )
        print("MySQL Database connection successful")
    except Error as err:
        print(f"Error: '{err}'")
    return connection


# Create database
def create_database(connection, query):
    cursor = connection.cursor()
    try:
        cursor.execute(query)
        print("Database created successfully")
    except Error as err:
        print(f"Error: '{err}'")


# Make connection and create database
connection = create_server_connection('192.168.1.183', 'root', 'my-secret-pw')
create_database_query = "CREATE DATABASE application"
create_database(connection, create_database_query)

