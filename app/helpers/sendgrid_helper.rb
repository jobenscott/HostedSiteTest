module SendgridHelper
	require 'sendgrid-ruby'
	include SendGrid
	require 'json'

	@sendgrid = SendGrid::API.new(api_key: ENV.fetch('SENDGRID_API_KEY'), host: 'https://api.sendgrid.com')

	def self.test
	  from = Email.new(email: 'aaroneveleth@gmail.com')
	  subject = 'Hello World from the SendGrid Ruby Library'
	  to = Email.new(email: 'aaroneveleth@gmail.com')
	  content = Content.new(type: 'text/html', value: 'some text here')
	  mail = Mail.new(from, subject, to, content)
	  # puts JSON.pretty_generate(mail.to_json)
	  puts mail.to_json

	  sg = SendGrid::API.new(api_key: ENV.fetch('SENDGRID_API_KEY'), host: 'https://api.sendgrid.com')
	  response = sg.client.mail._('send').post(request_body: mail.to_json)
	  puts response.status_code
	  puts response.body
	  puts response.headers
	end

end