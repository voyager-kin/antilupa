from antilupa import app
from flask import render_template, redirect, url_for, flash, request
from antilupa.models import Person, User, TrackReaction, TrackRecord, TrackRecordView
from antilupa.forms import RegisterForm, LoginForm, PersonSearchForm, RecordForm
from antilupa import db
from flask_login import login_user, logout_user, login_required, current_user
from datetime import date
from werkzeug.utils import secure_filename




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


@app.route('/donation')
def donation_page():
    return render_template('donation.html')


@app.route('/person')
@login_required
def person_page():
    return render_template('person.html')


@app.route('/new_record', methods=['GET', 'POST'])
@login_required
def add_record_page():
    form = RecordForm()
    if request.method == "GET":
        return render_template('new_record.html', form=form)
    else:
        if form.validate_on_submit():
            record_to_create = TrackRecord()
            person_to_create = None
            if form.person_id.data:
                person_id = form.person_id.data
            else:
                person = Person.query.filter_by(name=form.name.data).count()
                if person > 0:
                    flash(f'Name already exist, please try different unique name', category='danger')
                    return render_template('new_record.html', form=form)
                else:
                    print(form.photo.data)
                    photo = secure_filename(form.photo.data.filename)
                    form.photo.data.save('photos/' + photo)
                    person_to_create = Person(name=form.name.data,
                                              user_id=current_user.id, added_date=date.today(), photo=photo)
                    db.session.add(person_to_create)
                    db.session.flush()
                    db.session.refresh(person_to_create)
                    person_id = person_to_create.id
                    db.session.commit()

            record_to_create = TrackRecord(title=form.title.data,
                                           date=form.date.data,
                                           person_id=person_id,
                                           url=form.url.data,
                                           user_id=current_user.id)
            db.session.add(record_to_create)
            db.session.commit()
            flash(f"Record created successfully!",
                  category='success')
            track_records = TrackRecordView.query.filter_by(person_id=person_id)
            return render_template('track_record.html', track_records=track_records, name=person_to_create.name)
        print("here")
        if form.errors != {}:  # If there are not errors from the validations
            for err_msg in form.errors.values():
                flash(f'There was an error with creating the record: {err_msg}', category='danger')
        return render_template('new_record.html', form=form)



@app.route('/remember', methods=['GET', 'POST'])
@app.route('/remember/<name>', methods=['GET'])
@login_required
def remember_page(name=None):
    if request.method == "POST":
        name = request.form.get('name')
    else:
        name = name
        if name:
            search = "%{}%".format(name)
            person = Person.query.filter_by(name=name).count()
            if person:
                if person > 0:
                    person = Person.query.filter(Person.name.like(search)).first()
                    track_records = TrackRecordView.query.filter_by(person_id=person.id)
                    return render_template('track_record.html', track_records=track_records, name=person.name)
            else:
                person = Person.query.filter(Person.name.like(search)).count()
                if person:
                    if person > 1:
                        return redirect(url_for('person_page'))
                    else:
                        person = Person.query.filter(Person.name.like(search)).first()
                        track_records = TrackRecordView.query.filter_by(person_id=person.id)
                        return render_template('track_record.html', track_records=track_records, name=person.name)

                flash(f'no record for {name}, you may add new record below', category='warning')
                return redirect(url_for('add_record_page'))
        # print(track_reactions)
        # items = Item.query.filter_by(owner=None)
        # owned_items = Item.query.filter_by(owner=current_user.id)
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










