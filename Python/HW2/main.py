import webapp2

config = {'default-group':'base-data'}
                       
application = webapp2.WSGIApplication([
	('/add', 'library_admin.Admin'),
	('/edit', 'library_edit.Admin'),
	('/view', 'library_view.Admin'),
	('/', 'base_page.PageHandler'),
	('/hello', 'base_page.HelloWorld'),
], debug=True, config=config)

