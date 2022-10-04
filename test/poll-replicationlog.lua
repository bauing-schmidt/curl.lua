
local curl = require 'curl'

-- load driver
local luasql = require "luasql.postgres"

local timestamp_pattern = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+).(%d+)"

-- create environment object
local env = assert (luasql.postgres())
-- connect to data source
local con = assert (env:connect('pdmCC', 'pdm', 'devAdmin1', "127.0.0.1", "5436"))

local cur = assert (con:execute"SELECT max(createtime) from pdm.replicationlog;")
-- print all rows, the rows will be indexed by field names
local row = cur:fetch ({}, "a")
local _, max_createtime = next(row)
cur:close()

-- adjust the initial createtime in case of an empty `replicationlog` table.
if not max_createtime then max_createtime = '2020-01-01 00:00:00.000000' end
print('Initial max CREATETIME: ' .. max_createtime)

local function apptivegrid_upload (entity_json)
		
	return function (cu)
		local returns, getinfos = curl.curl_easy_httpheader_setopt_getinfo {
			httpheader	= { 
				['Content-Type'] = 'application/json',
			},
			setopt		= {	
				url = 'https://app.apptivegrid.de/api/users/6315f0a9f5ca3bb794a42cb3/spaces/6315f0b667d3ac2664a44f52/grids/631ee7590cb7e1473fa4c5ee/entities?layout=property',
				verbose = true,
				header = false,
				postfields = entity_json,
				cainfo = 'curl-ca-bundle.crt',
				netrc = curl.opt_netrc.CURL_NETRC_OPTIONAL,
			},
			getinfo 	= { 
				response_code = true, 
			}
		} (cu)
		
		local code, response_code = getinfos.response_code()
		assert(code == curl.CURLcode.CURLE_OK)
		assert(response_code == 201)
	end
end

while true do
	os.execute 'sleep 2s'

	-- get all new rows inserted during the sleep.
	local query = "SELECT * from pdm.replicationlog WHERE createtime > '"
			.. max_createtime .. "' ORDER BY createtime ASC;"
	cur = assert (con:execute (query))

	row = cur:fetch ({}, "a")
	while row do
	  print (row.createtime)
	  if max_createtime <= row.createtime then max_createtime = row.createtime end

		local matcher = string.gmatch(row.createtime, timestamp_pattern)

		local y, M, d, h, m, s, ss = matcher()

		local entity_json = string.format([[

		  {
		    "created": "%s-%s-%sT%s:%s:%s+02:00",
		    "replicationkey": 123,
		    "locationoutgoing": 456,
		    "locationincoming":789,
		    "commandurl": [],
		    "attachmentcount": 0,
		    "status": "new",
		    "errortext": null
		  }

		]], y, M, d, h, m, s)
		
		print('Inserting: \n' .. entity_json .. '\n')
			  
	  curl.curl_easy_do (apptivegrid_upload (entity_json))

	  row = cur:fetch (row, "a")	-- go to the next row.
	end

	cur:close()	-- cleanup the cursor for the current query.
end

-- close everything
con:close()
env:close()
