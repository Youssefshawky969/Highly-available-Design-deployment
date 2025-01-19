from flask import Flask
import psycopg2

app = Flask(__name__)

@app.route('/')
def home():
    conn = psycopg2.connect(database="dbname", user="dbuser", password="dbpass", host="dbhost", port="dbport")
    cur = conn.cursor()
    cur.execute("SELECT version();")
    version = cur.fetchone()
    conn.close()
    return f"Connected to {version[0]}"

if __name__ == '__main__':
    app.run(host='0.0.0.0')
