import webapp2
import base_page
from google.appengine.ext import ndb
from google.appengine.ext import blobstore
import db_defs

class Admin(base_page.BaseHandler):	#extends base_page
	def __init__(self, request, response):
		self.initialize(request, response)
		self.template_values = {}
	
	# def render(self, page):
		# libKey = ndb.Key(db_defs.Book, self.app.config.get('default-group'))
		# self.template_values['book'] = [{'title':x.title, 'author':x.author, 'isbn':x.isbn, 'cover':x.cover, 'soft':x.soft, 'hard':x.hard, 'owner':x.owner, 'owned':x.owned, 'want':x.want, 'key':x.key.urlsafe()} for x in db_defs.Book.query(ancestor=libKey).fetch()]
		# base_page.BaseHandler.render(self, page, self.template_values)
	
	def get(self):
		self.render('library_admin.html')	#calls render function of base_page.py
		
	def post(self):
		action = self.request.get('action')
		if action == 'add_book':
			k  = ndb.Key(db_defs.Book, self.app.config.get('default-group'))
			book = db_defs.Book(parent=k)
			book.title = self.request.get('book-title')
			book.author = self.request.get('book-author')
			book.isbn = int(self.request.get('book-isbn'))
			book.cover = self.request.get('book-cover')
			book.soft = self.request.get('book-soft')
			book.hard = self.request.get('book-hard')
			book.owner = self.request.get('book-owner')
			book.owned = self.request.get('book-owned')
			book.want = self.request.get('book-want')
			book.active = True
			book.put()				#saves
			self.render('library_admin.html', {'message':'Added ' + book.title + ' by ' + book.author + ' to the database.'})
		if action == 'back':
			self.render('library_main.html')
		else:
			self.render('library_admin.html', {'message':'Action ' + action + 'is unknown.'})