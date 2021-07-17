from antilupa import app
from flask import render_template, redirect, url_for, flash, request
from antilupa.models import Person, User, TrackReaction, TrackRecord
from antilupa.forms import RegisterForm, LoginForm, PersonSearchForm
from antilupa import db
from flask_login import login_user, logout_user, login_required, current_user
from datetime import date


@app.route('/', methods=['GET', 'POST'])
@app.route('/home', methods=['GET', 'POST'])
def home_page():
    search_form = PersonSearchForm()
    if current_user.is_authenticated:
        return render_template('home.html', form=search_form)
    else:
        return render_template('home.html')


@app.route('/about')
def about_page():
    return render_template('about.html')


@app.route('/person')
@login_required
def person_page():
    return render_template('person.html')


@app.route('/new_record')
@login_required
def add_record_page():
    return render_template('new_record.html')

@app.route('/remember', methods=['GET', 'POST'])
@login_required
def remember_page():
    if request.method == "POST":
        print("post detected")
        name = request.form.get('name')
        print(name)
        if name:
            search = "%{}%".format(name)
            person = Person.query.filter(Person.name.like(search)).count()
            if person:
                if person > 1:
                    return redirect(url_for('person_page'))
                else:
                    person = Person.query.filter(Person.name.like(search)).first()
                    track_records = TrackRecord.query.filter_by(person_id=person.id)
                    return render_template('track_record.html', track_records=track_records)

            else:
                flash(f'no record for { name }', category='success')
                return redirect(url_for('home_page'))
        # print(track_reactions)
        # items = Item.query.filter_by(owner=None)
        # owned_items = Item.query.filter_by(owner=current_user.id)
        return redirect(url_for('home_page'))
    else:
        print("here")
        return redirect(url_for('home_page'))


@app.route('/register', methods=['GET', 'POST'])
def register_page():
    form = RegisterForm()
    if form.validate_on_submit():
        user_to_create = User(username=form.username.data,
                              name=form.username.data,
                              email_address=form.email_address.data,
                              register_date=date.today(),
                              password=form.password1.data)
        db.session.add(user_to_create)
        db.session.commit()
        login_user(user_to_create)
        flash(f"Account created successfully! You are now logged in as {user_to_create.username}", category='success')
        return redirect(url_for('remember_page'))
    if form.errors != {}: #If there are not errors from the validations
        for err_msg in form.errors.values():
            flash(f'There was an error with creating a user: {err_msg}', category='danger')

    return render_template('register.html', form=form)


@app.route('/login', methods=['GET', 'POST'])
def login_page():
    if current_user.is_authenticated:
        return redirect(url_for('home_page'))
    form = LoginForm()
    if form.validate_on_submit():
        attempted_user = User.query.filter_by(username=form.username.data).first()
        if attempted_user and attempted_user.check_password_correction(
                attempted_password=form.password.data
        ):
            login_user(attempted_user)
            flash(f'Success! You are logged in as: {attempted_user.username}', category='success')
            return redirect(url_for('home_page'))
        else:
            flash('Username and password are not match! Please try again', category='danger')

    return render_template('login.html', form=form)


@app.route('/logout')
@login_required
def logout_page():
    logout_user()
    flash("You have been logged out!", category='info')
    return redirect(url_for("home_page"))










