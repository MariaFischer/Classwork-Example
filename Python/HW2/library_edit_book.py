import webapp2
import base_page
from google.appengine.ext import ndb
from google.appengine.ext import blobstore
from google.appengine.ext.webapp import blobstore_handlers
import db_defs

class bookEditHandler(blobstore_handlers.BlobstoreUploadHandler):
	def post(self):
		bk_key = ndb.Key(urlsafe=self.request.get('libKey'))
		bk = bk_key.get()
		bk.title = self.request.get('book-titleN')
		bk.author = self.request.get('book-authorN')
		bk.isbn = int(self.request.get('book-isbnN'))
		bk.cover = self.request.get('book-coverN')
		bk.soft = self.request.get('book-softN')
		bk.hard = self.request.get('book-hardN')
		bk.owner = self.request.get('book-ownerN')
		bk.owned = self.request.get('book-ownedN')
		bk.want = self.request.get('book-wantN')
		bk.put()
		self.redirect('/library_edit?key=' + bk_key.urlsafe() + '&type=book')