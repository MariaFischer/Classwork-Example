import webapp2
import base_page
from google.appengine.ext import ndb
from google.appengine.ext import blobstore
import db_defs

class Admin(base_page.BaseHandler):	#extends base_page
	def __init__(self, request, response):
		self.initialize(request, response)
		self.template_values = {}
		self.template_values['edit_url'] = blobstore.create_upload_url('/edit/book')
	
	def render(self, page):
		libKey = ndb.Key(db_defs.Book, self.app.config.get('default-group'))
		self.template_values['books'] = [{'title':x.title, 'author':x.author, 'isbn':x.isbn, 'cover':x.cover, 'soft':x.soft, 'hard':x.hard, 'owner':x.owner, 'owned':x.owned, 'want':x.want, 'key':x.key.urlsafe()} for x in db_defs.Book.query(ancestor=libKey).fetch()]
		base_page.BaseHandler.render(self, page, self.template_values)
	
	def get(self):
		self.render('library_edit.html')	#calls render function of base_page.py
	
	def post(self):
		action = self.request.get('action')
		if action == 'back':
			self.render('library_main.html')
	