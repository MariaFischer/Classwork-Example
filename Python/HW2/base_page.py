import webapp2
import os
import jinja2
import db_defs
from google.appengine.ext import ndb

#Must have both class HelloWorld and JINJA_ENVIRONMENT as well as class BaseHandler or it will not work - unsure as to reason
#7/1/2015 12:03 AM - HN

JINJA_ENVIRONMENT = jinja2.Environment(
		loader=jinja2.FileSystemLoader(os.path.dirname(__file__) + '/templates'),
		extensions=['jinja2.ext.autoescape'],
		autoescape=True
		)

class BaseHandler(webapp2.RequestHandler):
	
	@webapp2.cached_property
	def jinja2(self):
		return jinja2.Environment(
		loader=jinja2.FileSystemLoader(os.path.dirname(__file__) + '/templates'),
		extensions=['jinja2.ext.autoescape'],
		autoescape=True
		)
		
	def render(self, template, template_variables={}):
		template = self.jinja2.get_template(template)
		self.response.write(template.render(template_variables))

class PageHandler(BaseHandler):
	def __init__(self, request, response):
		self.initialize(request, response)
		self.template_values = {}
	
	def get(self):
		self.render('library_main.html')
		
	def render(self, page):
		libKey = ndb.Key(db_defs.Book, self.app.config.get('default-group'))
		self.template_values['book'] = [{'title':x.title, 'author':x.author, 'isbn':x.isbn, 'cover':x.cover, 'soft':x.soft, 'hard':x.hard, 'owner':x.owner, 'owned':x.owned, 'want':x.want, 'key':x.key.urlsafe()} for x in db_defs.Book.query(ancestor=libKey).fetch()]
		BaseHandler.render(self, page, self.template_values)
			
		

class HelloWorld(webapp2.RequestHandler):
	 template_variables = {}

	 def get(self):
		 template = JINJA_ENVIRONMENT.get_template('helloworld.html')
		 self.response.write(template.render())
		
	 def post(self):
		 self.template_variables['form_content'] = {}
		 template = JINJA_ENVIRONMENT.get_template('helloworld.html')
		 for i in self.request.arguments():
			 self.template_variables['form_content'][i] = self.request.get(i)
		 self.response.write(template.render(self.template_variables))
