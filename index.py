from flask import Flask,jsonify,json
from flask_sqlalchemy import SQLAlchemy
import psycopg2
from psycopg2._json import Json
from psycopg2.extensions import register_adapter


#connect to the db
from psycopg2.extras import RealDictCursor

con=psycopg2.connect(
    host="localhost",
    database="miaPractica1",
    user="postgres",
    password="password")


app=Flask(__name__)

@app.route('/')

@app.route('/test',methods=['GET'])

def test():
    cur=con.cursor(cursor_factory=RealDictCursor)
    cur.execute("select * from TEMPORAL limit 10;")
    rows = cur.fetchall()
    result=jsonify(rows)

    return result


@app.route('/eliminarTemporal',methods=['GET'])
def eliminarTemporal():
    cur=con.cursor(cursor_factory=RealDictCursor)
    cur.execute("TRUNCATE TABLE TEMPORAL;")
    con.commit()
    cur.close()
    return {'status':'temporal elminada con exito'}



@app.route('/cargarTemporal',methods=['GET'])
def cargarTemporal():
    cur = con.cursor(cursor_factory=RealDictCursor)

    cur.execute(
        "copy TEMPORAL FROM '/home/daniel/Desktop/PRACTICA1/BlockbusterData.csv' DELIMITER ';' CSV HEADER ENCODING 'WIN1252';")
    con.commit()
    cur.close()
    return {'status': 'temporal cargada con exito'}


if __name__=='__main__':
    app.run(debug=True)


