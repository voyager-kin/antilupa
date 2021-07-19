from antilupa import db, login_manager
from antilupa import bcrypt
from flask_login import UserMixin


@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))


class User(db.Model, UserMixin):
    id = db.Column(db.Integer(), primary_key=True)
    username = db.Column(db.String(length=20), nullable=False, unique=True)
    name = db.Column(db.String(length=20), nullable=False, unique=True)
    register_date = db.Column(db.DateTime(timezone=True), nullable=False)
    email_address = db.Column(db.String(length=100), nullable=False, unique=True)
    password_hash = db.Column(db.String(length=200), nullable=False)

    @property
    def password(self):
        return self.password

    @password.setter
    def password(self, plain_text_password):
        self.password_hash = bcrypt.generate_password_hash(plain_text_password).decode('utf-8')

    def check_password_correction(self, attempted_password):
        return bcrypt.check_password_hash(self.password_hash, attempted_password)


class Reaction(db.Model):
    id = db.Column(db.Integer(), primary_key=True)
    name = db.Column(db.String(length=20))


class TrackReaction(db.Model, UserMixin):
    __tablename__ = 'track_reaction'
    reaction = db.Column(db.String(), primary_key=True)
    track_id = db.Column(db.Integer())


class Person(db.Model):
    id = db.Column(db.Integer(), primary_key=True)
    name = db.Column(db.String(length=100), nullable=False)
    photo = db.Column(db.String(length=200), nullable=False)
    user_id = db.Column(db.Integer())
    added_date = db.Column(db.DateTime(timezone=True))


class TrackRecordView(db.Model, UserMixin):
    __tablename__ = 'track_record_view'
    id = db.Column(db.Integer(), primary_key=True)
    person_id = db.Column(db.Integer())
    user_id = db.Column(db.Integer())
    record = db.Column(db.String(length=2000))
    title = db.Column(db.String(length=200))
    url = db.Column(db.String(length=200))
    date = db.Column(db.DateTime(timezone=True))
    reaction = db.Column(db.String(length=200), nullable=False)
    truth_score = db.Column(db.Integer())

class TrackRecord(db.Model, UserMixin):
    __tablename__ = 'track_record'
    id = db.Column(db.Integer(), primary_key=True)
    person_id = db.Column(db.Integer())
    user_id = db.Column(db.Integer())
    record = db.Column(db.String(length=2000))
    title = db.Column(db.String(length=200))
    url = db.Column(db.String(length=200))
    date = db.Column(db.DateTime(timezone=True))
