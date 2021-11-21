
import mysql.connector
from mysql.connector import Error



# Create database connection
def create_server_connection(host_name, user_name, user_password, db_name):
    connection = None
    try:
        connection = mysql.connector.connect(
            host=host_name,
            user=user_name,
            passwd=user_password,
            database=db_name
        )
        print("MySQL Database connection successful")
    except Error as err:
        print(f"Error: '{err}'")
    return connection


# Execute commands to database
def execute_query(connection, query):
    cursor = connection.cursor()
    try:
        cursor.execute(query)
        connection.commit()
        print("Query successful")
    except Error as err:
        print(f"Error: '{err}'")


# Create artists table
create_artists_table = """
CREATE TABLE artists (
  artist_id INT PRIMARY KEY,
  full_name VARCHAR(50) NOT NULL,
  genre VARCHAR(15) NOT NULL
  );
 """


# Insert data into table
pop_artists = """
INSERT INTO artists VALUES
(1,  'James Smith', 'Rap'),
(2, 'Stefanie Martin', 'R&B'),
(3, 'Steve Wang', 'Jazz'),
(4, 'Friederike Rossi', 'Clasic'),
(5, 'Isobel Ivanova', 'D&B'),
(6, 'Niamh Murphy', 'Hardstyle');
"""


# Make connectionn with database server, create table & insert dummy data
connection = create_server_connection('iac-team3.westeurope.cloudapp.azure.com', 'root', 'example', 'application')
execute_query(connection, create_artists_table)
execute_query(connection, pop_artists)


