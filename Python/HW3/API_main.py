
import webapp2
from google.appengine.api import oauth

app = webapp2.WSGIApplication([
	('/API_library', 'API_library.Library'),
], debug=True)
app.router.add(webapp2.Route(r'/API_library/<id:[0-9]+><:/?>', 'API_library.Library'))
app.router.add(webapp2.Route(r'/API_library/search', 'API_library.LibrarySearch'))
app.router.add(webapp2.Route(r'/API_book', 'API_book.Book'))
app.router.add(webapp2.Route(r'/API_book/<id:[0-9]+><:/?>', 'API_book.Book'))
app.router.add(webapp2.Route(r'/API_book/<bid:[0-9]+>/API_library/<lid:[0-9]+><:/?>', 'API_book.LibraryBooks'))