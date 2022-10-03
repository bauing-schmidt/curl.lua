
--[[

This file should be placed under the `Commands` directory of the `documaps` repository.

--]]

require 'GetPostgresPassword'
local luasql = require "luasql.postgres"


function withConnectionDo (params, handler, ok_f, error_f)
	local dbEnv = assert (luasql.postgres())
	local dbPassword = GetPostgresPassword4(params.DbHost, params.DbPort, params.DbName, params.DbUser)
	local dbConn = assert (dbEnv:connect(params.DbName, params.DbUser, dbPassword, params.DbHost, params.DbPort))
	print(string.format("Logged in as user '%s'", params.DbUser))
	
	local function recv(status, ...)
		local f
		if status then f = ok_f else f = error_f end
		return f(...)
	end
	
	local value = recv(pcall(handler, dbConn))
	
	dbConn:close()
	dbEnv:close()
	
	return value
	
end

do

	local function insert_replication_upload (dbConn)
		local dbCursor = assert(dbConn:execute [[
			select * from pdm.insert_replication_upload((select min(cchistoryid) from pdm.replicationlog))
		]])
		local row = dbCursor:fetch({}, "a")
		
		dbCursor:close()
	end

	local function update_transfer_urls (urls, dbConn)
	
		local str = "'{" .. table.concat(urls, ', ') .. "}'"
	
		local dbCursor = assert(dbConn:execute (
			'select * from pdm.update_transfer_urls((select min(cchistoryid) from pdm.replicationlog), ' 
			.. str 
			.. '::text[])'))
		local row = dbCursor:fetch({}, "a")
		dbCursor:close()			
		
	end
	
	local function transferUrl(i)
		return 'https://aaa.com'
	end
	
	withConnectionDo ({ 
			DbHost = 'localhost', --'127.0.0.1'
			DbPort = '5436',
			DbName = 'pdmCC',
			DbUser = 'replicationServer',
		}, 
		function (dbConn)  
			local n = insert_replication_upload (dbConn)
			
			Urls = {}
			
			for i=1, n do
				table.insert(Urls, transferUrl(i)) 
			end
			
			update_transfer_urls (Urls, dbConn)
		end, 
		function (...) return ... end, 	-- on success
		print 							-- on failure
	)

end
