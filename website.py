import os
import pyodbc
from flask import Flask, render_template, redirect, url_for, request, flash
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text
from flask_login import LoginManager, UserMixin, login_user, login_required, logout_user, current_user
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)
app.secret_key = os.urandom(24)

server = 'localhost'
database = 'daoctracking'
username = 'RealmBotSvc'
password = 'Password1'

connection_string = f'mssql+pyodbc://{username}:{password}@{server}/{database}?driver=ODBC+Driver+17+for+SQL+Server'
app.config['SQLALCHEMY_DATABASE_URI'] = connection_string
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

print(connection_string)
print(app.config['SQLALCHEMY_DATABASE_URI'])
print('---------1-------------------')

def db_connect():
    print('---------2-------------------')
    with app.app_context():
        print('---------3-------------------')
        db = SQLAlchemy(app)
        print('---------4-------------------')
        try:
            with db.engine.connect() as connection:
                connection.execute(text("SELECT 1"))
                print("Database connection successful")
            return db
        except Exception as e:
            print(f"Error connecting to database: {str(e)}")
            return db

db = db_connect()


login_manager = LoginManager()
login_manager.init_app(app)

class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True)
    email = db.Column(db.String(120), unique=True)
    password_hash = db.Column(db.String(120))

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)


@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

@app.route("/")
@login_required
def home():
    return f"Hello, {current_user.username}!"

@app.route("/register", methods=["GET", "POST"])
def register():
    if request.method == "POST":
        username = request.form["username"]
        email = request.form["email"]
        password = request.form["password"]
        existing_user = User.query.filter_by(email=email).first()
        if existing_user:
            flash("Email already exists. Please log in.")
            return redirect(url_for("login"))

        user = User(username=username, email=email)
        user.set_password(password)
        db.session.add(user)
        db.session.commit()
        login_user(user)
        return redirect(url_for("home"))

    return render_template("register.html")

@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        email = request.form["email"]
        password = request.form["password"]
        remember_me = "remember-me" in request.form

        user = User.query.filter_by(email=email).first()
        if user and user.check_password(password):
            login_user(user, remember=remember_me)
            return redirect(url_for("home"))

        flash("Invalid email or password.")
    
    return render_template("login.html")

@app.route("/logout")
@login_required
def logout():
    logout_user()
    return redirect(url_for("login"))

if __name__ == "__main__":
    app.run(debug=True)
