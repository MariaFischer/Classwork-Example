import webapp2
from google.appengine.ext import ndb
import API_db_models
import json

class Book(webapp2.RequestHandler):
	def post(self):
		""" Creates a Book entity
		Post Body Variables:
		title - Required. Book Title
		author - Required. Book Author
		isbn- Required. Book ISBN
		ownership - Book Ownership (Want/Have)
		cover - Book Cover (Hard/Soft)
		genre - Book Genre(s)
		"""
		if 'application/json' not in self.request.accept:
			self.response.status = 406
			self.response.status_message = "Not Acceptable, API only supports application/json MIME type"
			return
		new_book = API_db_models.Book()
		title = self.request.get('title', default_value=None)
		author = self.request.get('author', default_value=None)
		isbn = self.request.get('isbn', default_value=None)
		libs = self.request.get_all('libs[]', default_value=None)
		ownership = self.request.get('ownership', default_value=None)
		cover = self.request.get('cover', default_value=None)
		genres = self.request.get_all('genres[]', default_value=None)
		if title:
			new_book.title = title
		else:
			self.response.status = 400
			self.response.status_message = "Invalid request, Title is Required"
		if author:
			new_book.author= author
		else:
			self.response.status = 400
			self.response.status_message = "Invalid request, Author is Required"
		if isbn:
			new_book.isbn = isbn
		else:
			self.response.status = 400
			self.response.status_message = "Invalid request, ISBN is Required"
		if libs:
			for lib in libs:
				new_book.libs.append(ndb.Key(API_db_models.Library, int(lib)))	
		if ownership:
			new_book.ownership = ownership
		if cover:
			new_book.cover = cover
		if genres:
			new_book.genres = genres
		for genre in new_book.genres:
			print genre	
		key = new_book.put()
		out = new_book.to_dict()
		self.response.write(json.dumps(out))
		return
		
	def get(self, **kwargs):
		if 'application/json' not in self.request.accept:
			self.response.status = 406
			self.response.status_message = "Not Acceptable, API only supports application/json MIME type"
			return
		if 'id' in kwargs:
			out = ndb.Key(API_db_models.Book, int(kwargs['id'])).get().to_dict()
			self.response.write(json.dumps(out))
		else:
			q = API_db_models.Book.query()
			keys = q.fetch(keys_only=True)
			results = { 'keys' : [x.id() for x in keys]}
			self.response.write(json.dumps(results))
	
class LibraryBooks(webapp2.RequestHandler):
	def put(self, **kwargs):
		if 'application/json' not in self.request.accept:
			self.response.status = 406
			self.response.status_message = "Not Acceptable, API only supports application/json MIME type"
			return
		if 'bid' in kwargs:
			book = ndb.Key(API_db_models.Book, int(kwargs['bid'])).get()
			if not book:
				self.response.status = 404
				self.response.status_message = "Book Not Found"
				return
		if 'lid' in kwargs:
			lib = ndb.Key(API_db_models.Library, int(kwargs['lid']))
			if not lib:
				self.response.status = 404
				self.response.status_message = "Library Not Found"
				return	
		if lib not in book.libs:
			book.libs.append(lib)
			book.put()
		self.response.write(json.dumps(book.to_dict()))
		return