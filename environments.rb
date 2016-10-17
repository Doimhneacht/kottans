configure :development do
	set :database, 'sqlite3:db/kottans.db'
	set :show_exceptions, true
	set :key, ":b\xC9\xB1\x15\xB4-\t\xA7~\xFF\x00\x8E~\xA9n"
	set :iv, "H\xB1\xD6C\x9F\x8A{\xE9\xF7\x1E\x9Aj\xB2\xF1\xD0\xA0"
	enable :logging, :dump_errors, :raise_errors
end

configure :test do
	set :database, 'sqlite3:db/kottans-test.db'
	set :key, "pd\f\nq\xF5\xC5\xFD\xA1\xA1\xCB\xB3\xA9\xEAz\xAC"
	set :iv, "\xB8\x8B\x97O\n6\xCED\x9C\x1A\xEC\x9F`\x90\x16r"
end

configure :production do
	db = URI.parse(ENV['DATABASE_URL'] || 'postgres:///localhost/mydb')
	set :key, ":b\xC9\xB1\x15\xB4-\t\xA7~\xFF\x00\x8E~\xA9n"
	set :iv, "H\xB1\xD6C\x9F\x8A{\xE9\xF7\x1E\x9Aj\xB2\xF1\xD0\xA0"

	ActiveRecord::Base.establish_connection(
		:adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
		:host     => db.host,
		:username => db.user,
		:password => db.password,
		:database => db.path[1..-1],
		:encoding => 'utf8'
	)
end
