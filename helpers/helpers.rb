require './helpers/encryption_info'
require './environments'

module Helpers
	def encrypt_text(text, password)
		cipher = OpenSSL::Cipher::AES256.new(:CBC)
		cipher.encrypt
		cipher.key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(password, 'salt', 2000, 32)
		iv = cipher.random_iv
		encrypted = cipher.update(text) + cipher.final
		EncryptionInfo.new(encrypted, iv)
	end

	def decrypt_text(encryption_info, password)
		decipher = OpenSSL::Cipher::AES256.new(:CBC)
		decipher.decrypt
		decipher.key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(password, 'salt', 2000, 32)
		decipher.iv = encryption_info.iv
		begin
			decipher.update(encryption_info.msg) + decipher.final
		rescue
			nil
		end
	end

	def encrypt_url(id)
		cipher = OpenSSL::Cipher::AES128.new(:CBC)
		cipher.encrypt
		cipher.key = Sinatra::Application.settings.key
		cipher.iv = Sinatra::Application.settings.iv
		encrypted = cipher.update(id.to_s) + cipher.final

		# return safe url, which leads to message of particular id
		Base64.urlsafe_encode64(encrypted, padding: false)
	end

	def decrypt_url(url)
		url_d = Base64.urlsafe_decode64(url)
		decipher = OpenSSL::Cipher::AES128.new(:CBC)
		decipher.decrypt
		decipher.key = Sinatra::Application.settings.key
		decipher.iv = Sinatra::Application.settings.iv

		# return message id after deciphering encoded url
		decipher.update(url_d) + decipher.final
	end

	def get_message_errors(message)
		errors = Array.new
		if message[:text].blank?
			errors << "Please come up with some message"
		end
		del = message[:del_method]
		if del != 'h' && del != 'v'
			errors << "Decide how the message should be deleted"
		end

		errors
	end
end