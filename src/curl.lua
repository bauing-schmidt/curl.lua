
local libcurl = require 'libcurllua'

local curl = {}
setmetatable(curl, {__index = libcurl})


-- NETRC options
curl.opt_netrc = {
	CURL_NETRC_IGNORED = 0,
	CURL_NETRC_OPTIONAL = 1,
	CURL_NETRC_REQUIRED = 2,
}

function curl.with_easy_handle_do(handler)
	local cu = libcurl.curl_easy_init()
	local res = pcall(handler, cu)
	assert(res)
	libcurl.curl_easy_cleanup(cu)
end

function curl.with_http_header_do(tbl, recv)

	local list = nil

	for k, v in pairs(tbl) do
		local h = k .. ': ' .. v
		list = curl.curl_slist_append(list, h)
	end

	pcall(recv, list)

	curl.curl_slist_free_all(list)

end

function curl.curl_easy_setopt(tbl)

	return function (cu)
		
		for k, v in pairs(tbl) do
			local flag, code = pcall(curl['curl_easy_setopt_' .. k], cu, v)
			assert(flag)
			assert(code == 0)
		end
	
	end

end

return curl

