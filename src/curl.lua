
local libcurl = require 'libcurllua'

local curl = {}
setmetatable(curl, {__index = libcurl})

function curl.with_easy_handle_do(handler)
	local cu = libcurl.curl_easy_init()
	local res = pcall(handler, cu)
	libcurl.curl_easy_cleanup(cu)
end

return curl

