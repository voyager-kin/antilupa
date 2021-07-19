from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt
from flask_login import LoginManager
from urllib.parse import urlparse
from flask_wtf.csrf import CSRFProtect

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mariadb://root:password@localhost:3306/antilupa'
app.config['SECRET_KEY'] = 'ec9439cfc6c796ae2029594d'

db = SQLAlchemy(app)
bcrypt = Bcrypt(app)
login_manager = LoginManager(app)
login_manager.login_view = "login_page"
login_manager.login_message_category = "info"
csrf = CSRFProtect()
csrf.init_app(app)


def fetch_domain(url):
    return urlparse(url).netloc


app.jinja_env.globals.update(fetch_domain=fetch_domain)


emojisource = "all logos <a href=https://www.freepik.com/vectors/heart>Heart vector created by rawpixel.com - www.freepik.com</a>"
from antilupa import routes