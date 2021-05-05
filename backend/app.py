import os
from flask import Flask, abort, request, jsonify, g, url_for
from flask_sqlalchemy import SQLAlchemy
from flask_httpauth import HTTPBasicAuth
from passlib.apps import custom_app_context as pwd_context
from flask_admin import Admin
from flask_admin.contrib import sqla
from flask_admin.contrib.sqla import filters
from wtforms import validators
from itsdangerous import (TimedJSONWebSignatureSerializer
                          as Serializer, BadSignature, SignatureExpired)

from flask_cors import CORS

app = Flask(__name__)
app.config['SECRET_KEY'] = 'the quick brown fox jumps over the lazy dog'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///db.sqlite'
app.config['SQLALCHEMY_COMMIT_ON_TEARDOWN'] = True
cors = CORS(app, resources={r"/api/*": {"origins": "*"}})
db = SQLAlchemy(app)
auth = HTTPBasicAuth()


class User(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(32), index=True)
    email = db.Column(db.String(120), unique=True)
    password_hash = db.Column(db.String(128))

    def __str__(self):
        return self.username

    def hash_password(self, password):
        self.password_hash = pwd_context.encrypt(password)

    def verify_password(self, password):
        return pwd_context.verify(password, self.password_hash)

    def generate_auth_token(self, expiration=600):
        s = Serializer(app.config['SECRET_KEY'], expires_in=expiration)
        return s.dumps({'id': self.id})

    @staticmethod
    def verify_auth_token(token):
        s = Serializer(app.config['SECRET_KEY'])
        try:
            data = s.loads(token)
        except SignatureExpired:
            return None    # valid token, but expired
        except BadSignature:
            return None    # invalid token
        user = User.query.get(data['id'])
        return user


class Tree(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    value = db.Column(db.String(56))
    description = db.Column(db.Text)
    question = db.Column(db.String(108))
    parent_id = db.Column(db.Integer, db.ForeignKey('tree.id'))
    parent = db.relationship('Tree', remote_side=[id,
                                                  question], backref='children')

    def __str__(self):
        return self.question

    def save_to_db(self):
        db.session.add(self)
        db.session.commit()

    def __unicode__(self):
        return self.value


class Progress(db.Model):
    __tablename__ = 'progress'
    id = db.Column(db.Integer, primary_key=True)

    user_id = db.Column(db.Integer(), db.ForeignKey(User.id))
    user = db.relationship(User, backref='progress')

    tree_id = db.Column(db.Integer(), db.ForeignKey(Tree.id), nullable=True)
    tree = db.relationship(Tree, backref='progress')

    def save_to_db(self):
        db.session.add(self)
        db.session.commit()

    def __unicode__(self):
        return self.user.username


@auth.verify_password
def verify_password(username_or_token, password):
    user = User.verify_auth_token(username_or_token)
    if not user:
        user = User.query.filter_by(username=username_or_token).first()
        if not user or not user.verify_password(password):
            return False
    g.user = user
    return True


@app.route('/api/fetchstories')
@auth.login_required
def fetch_stories():
    temp=[]
    stories = Tree.query.all()
    for story in stories:
        temp.append([story.id,story.value, story.description,story.question, story.parent_id])
    try:
        progress=Progress.query.filter_by(user_id=g.user.id).first()
        return jsonify({'data': temp,'progress':progress.tree_id})
    except:
        return jsonify({'data': temp,'progress':None})

@app.route('/api/createprogress', methods=['POST'])
@auth.login_required
def create_progress():
    tree_id = request.json.get('treeId')
    try:
        progress=Progress.query.filter_by(user_id=g.user.id).first()
        progress.tree_id=tree_id
        return jsonify({'ok': True})
    except:
        try:
            progress = Progress(user_id=g.user.id,tree_id=tree_id)
            db.session.add(progress)
            db.session.commit()
            return jsonify({'ok': True})
        except:
            return jsonify({'ok': False})


@app.route('/api/users', methods=['POST'])
def new_user():
    username = request.json.get('username')
    password = request.json.get('password')
    email = request.json.get('email')
    if username is None or password is None or email is None:
        abort(400)     # missing arguments
    if User.query.filter_by(username=username).first() is not None:
        abort(400)    # existing user
    user = User(username=username, email=email)
    user.hash_password(password)
    db.session.add(user)
    db.session.commit()
    return (jsonify({'username': user.username, 'email': user.email}), 201,
            {'Location': url_for('get_user', id=user.id, _external=True)})


@app.route('/api/users/<int:id>')
def get_user(id):
    user = User.query.get(id)
    if not user:
        abort(400)
    return jsonify({'username': user.username})


@app.route('/api/token')
@auth.login_required
def get_auth_token():
    token = g.user.generate_auth_token(60*60*24)
    return jsonify({'token': token.decode('ascii'), 'duration': "1 day"})


@app.route('/api/resource')
@auth.login_required
def get_resource():
    return jsonify({'data': 'Hello, %s!' % g.user.username})



@ app.route('/')
def index():
    return '<a href="/admin/">Click me to get to Admin!</a>'


# Customized User model admin

class UserAdmin(sqla.ModelView):
    pass
    #inline_models = (User,)


# Customized Post model admin
class ProgressAdmin(sqla.ModelView):
    column_sortable_list = ('user',)
    column_labels = dict(title='Progress Title')

    column_searchable_list = (User.username,)
    form_args = dict(
        text=dict(label='Big Text', validators=[validators.required()])
    )

    form_ajax_refs = {
        'user': {
            'fields': (User.username, User.email)
        },
    }

    def __init__(self, session):
        super(ProgressAdmin, self).__init__(Progress, session)


class TreeView(sqla.ModelView):
    pass
    # form_excluded

admin = Admin(app, name='Twain Admin')

# Add views
admin.add_view(UserAdmin(User, db.session))
admin.add_view(ProgressAdmin(db.session))
admin.add_view(TreeView(Tree, db.session))


if __name__ == '__main__':
    if not os.path.exists('db.sqlite'):
        db.create_all()
    app.run()
