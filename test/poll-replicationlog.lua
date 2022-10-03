
-- load driver
local luasql = require "luasql.postgres"

-- create environment object
local env = assert (luasql.postgres())
-- connect to data source
local con = assert (env:connect('pdmCC', 'pdm', 'devAdmin1', "127.0.0.1", "5436"))

local cur = assert (con:execute"SELECT max(createtime) from pdm.replicationlog;")
-- print all rows, the rows will be indexed by field names
local row = cur:fetch ({}, "a")
local _, max_createtime = next(row)
cur:close()

if not max_createtime then max_createtime = '0' end

print('Initial max CREATETIME: ' .. max_createtime)

while true do
	os.execute 'sleep 1s'

	-- retrieve a cursor
	cur = assert (con:execute ("SELECT * from pdm.replicationlog WHERE createtime > '" ..
					max_createtime .. "' ORDER BY createtime ASC;"))
	-- print all rows, the rows will be indexed by field names
	row = cur:fetch ({}, "a")
	while row do
	  --print(string.format("Name: %s, E-mail: %s", row.name, row.email))
	  print (row.createtime)
	  if max_createtime <= row.createtime then max_createtime = row.createtime end

	  -- reusing the table of results
	  row = cur:fetch (row, "a")
	end
	cur:close()
end

-- close everything
con:close()
env:close()
