require 'sinatra'
require 'sinatra/activerecord'
require './environments'
require './helpers/helpers'
require './helpers/encryption_info'
require 'sinatra/base'

class Message < ActiveRecord::Base
	validates :text, presence: true
	validates :del_method, presence: true, inclusion: { in: %w(v h) }
	validates :iv, presence: true

	def is_outdated?
		Time.now > (self[:created_at] + self[:h] * 3600)
	end

	def is_overvisited?
		self[:visits] == 0
	end
end

class Kottans < Sinatra::Base

	helpers do
		include Helpers
	end

	get "/" do
		@message = Message.new
		erb :new
	end

	post "/submit" do
		@message = Message.new(params[:message].except("key"))

		@errors = get_message_errors(@message)

		if @errors.empty?
			# do the backend encryption and save to the table
			encryption_info = encrypt_text(@message[:text], params[:message][:key])
			@message[:text] = encryption_info.msg
			@message[:iv] = encryption_info.iv
			puts @message.inspect
			@message.save
			@link = "/" + encrypt_url(@message[:id])
			erb :success
		else
			@params = params[:message]
			erb :new
		end
	end

	get "/:message_id" do
		id = decrypt_url(params[:message_id])
		message = Message.find_by_id(id)
		unless message.nil?
			if message[:del_method] == 'h' && message.is_outdated?
				message.destroy
				erb :wrong_url
			else
				erb :show
			end
		else
			erb :wrong_url
		end
	end

	post "/:message_id" do
		id = decrypt_url(params[:message_id])
		message = Message.find_by_id(id)
		if message.nil?
			erb :wrong_url
		else
			encryption_info = EncryptionInfo.new(message[:text], message[:iv])
			@text = decrypt_text(encryption_info, params[:password])
			if @text.nil?
				@error = "Oops, the password is wrong. Try again."
			else
				message[:visits] -= 1
				message.save
				puts message[:visits]
				if message[:del_method] == 'v' && message.is_overvisited?
					message.destroy
				end
			end
			erb :show
		end
	end
end
