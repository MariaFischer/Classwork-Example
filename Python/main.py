import webapp2
                       
APP = webapp2.WSGIApplication([
    ('/', 'base_page.HelloWorld'),
], debug=True)

