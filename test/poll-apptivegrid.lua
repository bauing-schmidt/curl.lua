
local curl = require 'curl'
local json = require 'json'
local luasql = require "luasql.postgres"

local env = assert (luasql.postgres())
local con = assert (env:connect('pdmCC', 'pdm', 'devAdmin1', "127.0.0.1", "5437"))	-- the replication database instance.

-- 2022-09-14T09:31:00+00:00
local timestamp_pattern = "(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+).+"

local function apptivegrid (cu)

	local returns = curl.curl_easy_httpheader_setopt_getinfo {
		httpheader	= { 
			Accept = 'application/vnd.apptivegrid.hal;version=2' 
		},
		setopt		= {	
			url = 'https://app.apptivegrid.de/api/users/6315f0a9f5ca3bb794a42cb3/spaces/6315f0b667d3ac2664a44f52/grids/631ee7590cb7e1473fa4c5ee/entities?layout=property',
			verbose = false,
			header = false,
			cainfo = 'curl-ca-bundle.crt',
			netrc = curl.opt_netrc.CURL_NETRC_OPTIONAL,
			writefunction = true,
		}
	} (cu)

	local code, response, size = returns.writefunction()
	assert(code == curl.CURLcode.CURLE_OK)
	--print('\n'..response)
	return response
end

while true do

	os.execute 'sleep 2s'	-- sleeping.

	local response = curl.curl_easy_do(apptivegrid)	-- get the json.
	local tbl = json.decode(response)		-- then read it.

	for _, item in ipairs(tbl.items) do
		local matcher = string.gmatch(item.created, timestamp_pattern)
		local y, M, d, h, m, s = matcher()
		--print(item._id, y, M, d, h, m, s)
		local createtime = string.format('%s-%s-%s %s:%s:%s.000000', y, M, d, h, m, s)
		local query_insert = string.format([[

			INSERT INTO pdm.replicationlog(
				cchistoryid, createtime, applytime, applyduration, command)
				VALUES (%s, '%s', NULL, NULL, '{}'::jsonb);

		]], item.replicationkey, createtime)

		--print('INSERT: ' .. query_insert)

		local cur = con:execute (query_insert)	-- try the insertion
		if cur then print (string.format ('ApptiveGrid entity %s replicated.', item._id)) end
	end
end

-- close everything
con:close()
env:close()
