
local libcurl = require 'libcurl'

local curl = {}

function curl.easyhandle(handler)
	local cu = libcurl.curl_easy_init()
	local res = pcall(handler, libcurl, cu)
	libcurl.curl_easy_cleanup(cu)
end




return curl

