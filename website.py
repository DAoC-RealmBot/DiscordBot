import os
import pyodbc
from flask import Flask, render_template, redirect, url_for, request, flash, jsonify
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text
from flask_login import LoginManager, UserMixin, login_user, login_required, logout_user, current_user
from flask_socketio import SocketIO, send
from werkzeug.security import generate_password_hash, check_password_hash
from bot_commands import char_search, link_character, who_command
import pandas as pd

app = Flask(__name__)
app.secret_key = os.urandom(24)
socketio = SocketIO(app)

login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = "login"

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
    return render_template('home.html', username=current_user.username)

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

@app.route('/chat')
def chat():
    return render_template('chat.html')

@socketio.on('message')
def handleMessage(msg):
    print('Message: ' + msg)
    send(msg, broadcast=True)


@app.route('/search', methods=['POST'])
def search_character():    
    character_name = request.get_json().get('character', '')
    # Process the input and execute your Python function here
    result = your_python_function(character_name)

    
    return jsonify({'result': result})


def your_python_function(character_name):
    found_characters = char_search(character_name)
    return  found_characters

@login_required    
@app.route('/linkcharactertouser', methods=['POST'])
def process_selected_table():
    table_data = request.get_json()
    df = pd.DataFrame(table_data)
    new_column_name = 'userid'
    new_column_value = current_user.id

    df[new_column_name] = new_column_value
    df.columns = ['character_web_id','userid']
    # Process the DataFrame as needed
    link_character(df)

    return jsonify({'status': 'success'})



@app.route('/charactersearch/<name>', methods=['GET'])
def api_logic(name):
    #Call char_search from bot_commands library
    data = char_search(name)
    return data#jsonify(data)



if __name__ == '__main__':
    app.run(debug=True)






