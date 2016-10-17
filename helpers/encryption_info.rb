class EncryptionInfo
	attr_reader :msg, :iv

	def initialize(msg, iv)
		@msg = msg
		@iv = iv
	end
end
