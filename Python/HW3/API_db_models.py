from google.appengine.ext import ndb

class Model(ndb.Model):
	def to_dict(self):
		d = super(Model, self).to_dict()
		d['key'] = self.key.id()
		return d

class UpdateModel(Model):		
	date_time = ndb.DateTimeProperty(required=True)
	user_count = ndb.IntegerProperty(required=True)
	messsage_count = ndb.IntegerProperty(required=True)

class Book(Model):	
	title = ndb.StringProperty(required=True)
	author= ndb.StringProperty(required=True)
	isbn = ndb.StringProperty(required=True)
	libs = ndb.KeyProperty(repeated=True)
	ownership = ndb.StringProperty()
	cover = ndb.StringProperty()
	genres = ndb.StringProperty(repeated=True)
	
	def to_dict(self):
		d = super(Book, self).to_dict()
		d['libs'] = [l.id() for l in d['libs']]
		return d
		
class Library(Model):
	name = ndb.StringProperty(required=True)
	location = ndb.StringProperty(required=True)
	accessability = ndb.StringProperty(required=True)
	hours = ndb.StringProperty()