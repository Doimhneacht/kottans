ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'rspec'
require 'sinatra'
require 'capybara'
require 'capybara/rspec'

require File.expand_path '../../app.rb', __FILE__

class TestHelpers
	include Helpers
end

feature 'integration tests' do
	#let(:helpers) { TestHelpers.new }
	#include Rack::Test::Methods
	include Capybara::DSL

	before(:all) do
		Capybara.app = Kottans
	end

	def submit_form(text, del, v, h, key)
		visit '/'
		# fill in the form with valid data
		fill_in('message[text]', with: text)
		if del == 'v'
			choose('v')
		elsif del == 'h'
			choose('h')
		end
		fill_in('message[visits]', with: v)
		fill_in('message[hours]', with: h)
		fill_in('message[key]', with: key)
		# submit form
		click_button('Save the message')
	end

	scenario "home page should be rendered properly" do
		visit '/'
		expect(page).to have_content "Welcome to the Kottans test task implementation!"
	end

	scenario "home page form should successfully submit valid data" do
		submit_form('something', 'h', '', 3, 'password')

		expect(page).to have_content "Your message was successfully saved."
	end

	scenario "home page should reject invalid input and show error messages" do
		submit_form('', 'v', 1, '', 'pwd')

		expect(page).to have_content "Please come up with some message"
		expect(page).to have_content "Welcome to the Kottans test task implementation!"
	end

	scenario "user should be able to read his message" do
		text = "It's the right message!"
		password = 'drowssap'
		submit_form(text, 'v', 1, '', password)

		click_link('link')

		expect(page).to have_content "Enter your password to access the message:"
		expect(page).not_to have_content "Here's your message:"

		fill_in('password', with: password)
		click_button('OK')

		expect(page).to have_content text

	end
end
