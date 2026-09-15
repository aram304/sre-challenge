import sqlite3
import logging
import bcrypt
import os
from flask import Flask, jsonify, session, redirect, url_for, request, render_template, abort

db_path = "/var/lib/sre-challenge/database.db"

app = Flask(__name__)
app.secret_key = os.environ["app_secret"]
app.logger.setLevel(logging.INFO)


def get_db_connection():
    connection = sqlite3.connect(db_path)
    connection.row_factory = sqlite3.Row
    return connection


def is_authenticated():
    if "username" in session:
        return True
    return False



def authenticate(username, password):
    connection = get_db_connection()
    users = connection.execute("SELECT * FROM users WHERE username = ?", (username,)).fetchall()

    connection.close()
    

    for user in users:
        if user["username"] == username and bcrypt.checkpw(password.encode(), user["password"].encode()):
            app.logger.info(f"the user '{username}' logged in successfully")
            session["username"] = username
            return True

    app.logger.warning(f"the user '{ username }' failed to log in")
    abort(401)


@app.route("/")
def index():
    return render_template("index.html", is_authenticated=is_authenticated())


@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        username = request.form.get("username")
        password = request.form.get("password")
        if authenticate(username, password):
            return redirect(url_for("index"))
    return render_template("login.html")


@app.route("/logout", methods=["POST"])
def logout():
    session.pop("username", None)
    return redirect(url_for("index"))

@app.route("/health", methods=['GET'])
def health_check():
      return jsonify({"status": "OK"}), 200 

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
