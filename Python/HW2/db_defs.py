from google.appengine.ext import ndb

# class Message(ndb.Model):
	# channel = ndb.StringProperty(required=True)
	# date_time = ndb.DateTimeProperty(required=True)
	# count = ndb.IntegerProperty(required=True)

# class Channel(ndb.Model):
	# name = ndb.StringProperty(required=True)
	# classes = ndb.StringProperty(repeated=True)
	# active = ndb.BooleanProperty(required=True)	
	
class Message(ndb.Model):
	book = ndb.StringProperty(required=True)
	
class Book(ndb.Model):		
#	user-name = ndb.TextProperty(required=True)
#	user-password = ndb.TextProperty(required=True)
	title = ndb.TextProperty(required=True)
	author = ndb.TextProperty(required=True)
	isbn = ndb.IntegerProperty(required=True)
	cover = ndb.TextProperty(required=True)
	hard = ndb.TextProperty(required=True)
	soft = ndb.TextProperty(required=True)
	owner = ndb.TextProperty(required=True)
	owned = ndb.TextProperty(required=True)
	want = ndb.TextProperty(required=True)
	genre = ndb.StringProperty(choices=set(["mystery", "horror", "fiction", "fantasy", "horror", "sci-fi", "non-fiction", "textbook", "childrens", "teen", "adult", "romance", "other"])) 