import webapp2
from google.appengine.ext import ndb
import API_db_models
import json

class Library(webapp2.RequestHandler):
	def post(self):
		""" Creates a Library entity
		Post Body Variables:
		name - Required. Library Name
		location - Required. Library Location
		accessability - Required. Library Accessability (Public/Private)
		hours - Library Hours
		"""
		if 'application/json' not in self.request.accept:
			self.response.status = 406
			self.response.status_message = "Not Acceptable, API only supports application/json MIME type"
			return
		new_library = API_db_models.Library()
		name = self.request.get('name', default_value=None)
		location = self.request.get('location', default_value=None)
		accessability = self.request.get('accessability', default_value=None)
		hours = self.request.get('hours', default_value=None)
		if name:
			new_library.name = name
		else:
			self.response.status = 400
			self.response.status_message = "Invalid request, Library Name is Required"
		if location:
			new_library.location = location
		else:
			self.response.status = 400
			self.response.status_message = "Invalid request, Library Location is Required"
		if accessability:
			new_library.accessability = accessability
		else:
			self.response.status = 400
			self.response.status_message = "Invalid request, Library Accessability is Required"
		if hours:
			new_library.hours = hours
		key = new_library.put()
		out = new_library.to_dict()
		self.response.write(json.dumps(out))
		return
		
	def get(self, **kwargs):
		if 'application/json' not in self.request.accept:
			self.response.status = 406
			self.response.status_message = "Not Acceptable, API only supports application/json MIME type"
			return
		if 'id' in kwargs:
			out = ndb.Key(API_db_models.Library, int(kwargs['id'])).get().to_dict()
			self.response.write(json.dumps(out))
		else:
			q = API_db_models.Library.query()
			keys = q.fetch(keys_only=True)
			results = { 'keys' : [x.id() for x in keys]}
			self.response.write(json.dumps(results))
	
class LibrarySearch(webapp2.RequestHandler):
	def post(self):
		''' 
		Post Body Variables:
		name - String. Library Name
		location - String. Library Location
		accessability - String. Library Accessability (Public/Private)
		'''
		if 'application/json' not in self.request.accept:
			self.response.status = 406
			self.response.status_message = "Not Acceptable, API only supports application/json MIME type"
			return
		q = API_db_models.Library.query()
		if self.request.get('name',None):
			q = q.filter(API_db_models.Library.name == self.request.get('name'))
		if self.request.get('location',None):
			q = q.filter(API_db_models.Library.location == self.request.get('location'))
		if self.request.get('location',None):
			q = q.filter(API_db_models.Library.location == self.request.get('accessability'))	
		if self.request.get('hours',None):
			q = q.filter(API_db_models.Library.hours == self.request.get('hours'))	
		keys = q.fetch(keys_only=True)
		results = { 'keys' : [x.id() for x in keys]}
		self.response.write(json.dumps(results))