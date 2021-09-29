import psycopg2


#connect to the db

con=psycopg2.connect(
    host="localhost",
    database="practica1",
    user="practica1",
    password="practica1")

