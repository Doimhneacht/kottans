ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'rspec'
require 'sinatra'

require File.expand_path '../../app.rb', __FILE__

class TestHelpers
	include Helpers
end

describe 'helpers tests' do
	let(:helpers) { TestHelpers.new }
	
	it "should encrypt url" do
		expect(helpers.encrypt_url('13')).to eq "_0_MKPSGTM5KtkojOcJLmA"
	end

	it "should decrypt url" do
		expect(helpers.decrypt_url("kvUC4bbTNwiBCNTDMhpbGA")).to eq '42'
	end

	it "should decrypt encrypted url" do
		srand = 1234
		id = rand(1000).to_s
		expect(helpers.decrypt_url(helpers.encrypt_url(id))).to eq id
	end

	it "should decrypt encrypted text" do
		text = "Wibbly-wobbly timey-wimey"
		password = "WHO"
		decrypted = helpers.decrypt_text(helpers.encrypt_text(text, password), password)
		expect(decrypted).to eq text
	end
		
	it "should get no message errors for a valid input" do
		message = Message.new(text: 'text', del_method: 'v')
		expect(helpers.get_message_errors(message)).to be_empty
	end

	it "should get error when message is empty" do
		invalid_text = ['', nil, '   ']
		invalid_text.each do |text|
			empty_message = Message.new(text: text, del_method: 'v')
			expect(helpers.get_message_errors(empty_message)).to eq ['Please come up with some message']
		end
	end

	it "should get error when message has no deletion method" do
		invalid_del = ['', nil, '   ', 'random', 1, -5, [], {}]
		invalid_del.each do |del|
			invalid_message = Message.new(text: 'text', del_method: del)
			expect(helpers.get_message_errors(invalid_message)).to eq ['Decide how the message should be deleted']
		end
	end

	it "should return all message errors" do
		m1 = Message.new(text: '', del_method: nil)
		m2 = Message.new(text: '  ', del_method: 1)
		m3 = Message.new(text: nil, del_method: 'sda')
		[m1, m2, m3].each do |m|
			expect(helpers.get_message_errors(m)).to eq ['Please come up with some message', 'Decide how the message should be deleted']
		end
	end
end
