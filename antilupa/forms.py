from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField, HiddenField
from wtforms.validators import Length, EqualTo, Email, DataRequired, ValidationError
from antilupa.models import User, Person, TrackRecordView
from wtforms import StringField, BooleanField, FileField, SubmitField
from flask_wtf.file import FileField, FileRequired
from werkzeug.utils import secure_filename

class RegisterForm(FlaskForm):
    def validate_username(self, username_to_check):
        user = User.query.filter_by(username=username_to_check.data).first()
        if user:
            raise ValidationError('Username already exists! Please try a different username')

    def validate_email_address(self, email_address_to_check):
        email_address = User.query.filter_by(email_address=email_address_to_check.data).first()
        if email_address:
            raise ValidationError('Email Address already exists! Please try a different email address')

    username = StringField(label='User Name:', validators=[Length(min=2, max=30), DataRequired()])
    email_address = StringField(label='Email Address:', validators=[Email(), DataRequired()])
    password1 = PasswordField(label='Password:', validators=[Length(min=6), DataRequired()])
    password2 = PasswordField(label='Confirm Password:', validators=[EqualTo('password1'), DataRequired()])
    submit = SubmitField(label='Create Account')


class PersonSearchForm(FlaskForm):
    name = StringField(label='Person to track:', validators=[Length(min=2, max=100), DataRequired()])
    submit = SubmitField(label='Track')


class PersonForm(FlaskForm):
    name = StringField(label='Person to track:', validators=[Length(min=2, max=100), DataRequired()])

    submit = SubmitField(label='Track')


class RecordForm(FlaskForm):
    name = StringField(label='Topic or person :', validators=[Length(min=2, max=100), DataRequired()])
    photo = FileField(label='Photo :')  # IMAGE
    person_id = StringField(label='Topic or person :', validators=[Length(min=0, max=100)])
    user_id = StringField(label='User id :', validators=[Length(min=0, max=100)])
    title = StringField(label='Record :', validators=[Length(min=2, max=200), DataRequired()])
    date = StringField(label='Date :', validators=[Length(min=2, max=100), DataRequired()])
    url = StringField(label='URL :', validators=[Length(min=2, max=100), DataRequired()])
    tag = StringField(label='Tag - maximum of 5 tags separated by comma :', validators=[Length(min=0, max=100)])
    submit = SubmitField(label='Add Record')


class LoginForm(FlaskForm):
    username = StringField(label='User Name:', validators=[DataRequired()])
    password = PasswordField(label='Password:', validators=[DataRequired()])
    submit = SubmitField(label='Sign in')
