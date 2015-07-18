import webapp2
import os
import jinja2

#Read about these properties at http://jinja.pocoo.org/docs/dev/api
JINJA_ENVIRONMENT = jinja2.environment(
	loader=jinja2.FileSystemLoader(os.path.dirname(__file__) + '/templates'),
	extensions=['jinja2.ext.autoescape'],
	autoescape=True
	)

class HelloWorld(webapp2.RequestHandler):
	template variables = {}
	def get(self):
		template = JINJA_ENVIRONMENT.get_template('helloworld.html')
		self.response.write(template.render())
	def post(self):
		self.template_variables['form_content'] = {}
		template = JINJA_ENVIRONMENT.get_template('helloworld.html')
		for i in self.request.arguments():
			self.template_variables['form content'][i] = self.request.get(i)
		self.response.write(template.render(self.template_varaibles))