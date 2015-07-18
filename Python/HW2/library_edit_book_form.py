import webapp2
import base_page
from google.appengine.ext import ndb
from google.appengine.api import images
from google.appengine.ext import blobstore
import db_defs

class bookEditFormHandler(base_page.BaseHandler):
	def __init__(self, request, response):
		self.initialize(request, response)
		self.template_values = {} 
		self.template_values['edit_url'] = blobstore.create_upload_url( '/edit/book' )
	
	def get(self):
		if self.request.get('type') == 'book':
			bk_key = ndb.Key(urlsafe=self.request.get('key'))
			book = bk_key.get()
			self.template_values['book'] = book 	
		self.render('library_edit_book.html',self.template_values)

	def post(self):
		action = self.request.get('action')
		if action == 'back':
			self.render('library_main.html')		