
local libcurl = require 'libcurllua'

local curl = {}
setmetatable(curl, {__index = libcurl})

-- NETRC options
curl.opt_netrc = {
	CURL_NETRC_IGNORED = 0,
	CURL_NETRC_OPTIONAL = 1,
	CURL_NETRC_REQUIRED = 2,
}

function curl.curl_easy_do(handler)
	local cu = libcurl.curl_easy_init()
	local res, v = pcall(handler, cu)
	assert(res)
	libcurl.curl_easy_cleanup(cu)
	return v
end

function curl.curl_slist(tbl)

	local list = nil

	for k, v in pairs(tbl) do
		local h = k .. ': ' .. v
		list = curl.curl_slist_append(list, h)
	end

	return list
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

function curl.curl_easy_setopt(cu, tbl)

	local returns = {}
			
	for k, v in pairs(tbl) do
		local setopt_k = curl['curl_easy_setopt_' .. k]
		if type(setopt_k) == 'function' then
			local r = table.pack(setopt_k(cu, v))
			local code = r[1]
			assert(code == 0)
			returns[k] = function () return table.unpack(r) end
		end
	end
	
	return returns
	
end

function curl.curl_easy(options)

	curl.with_easy_handle_do(function (cu)
		
	end)
	
end

function curl.curl_easy_httpheader_setopt (tbl)

	local headers_tbl, setopt_tbl = tbl.httpheader, tbl.setopt

	return function (cu)

		local headers = curl.curl_slist(headers_tbl)
				
		local returns = curl.curl_easy_setopt(cu, setopt_tbl)

		local has_writefunction = false
		local code, memory, thread
		if type(returns.writefunction) == 'function' then
			code, memory, thread = returns.writefunction()
			assert(code == 0)
			
			has_writefunction = true
		end

		local pcode = curl.curl_easy_perform(cu) -- go!
		assert(pcode == 0)

		curl.curl_slist_free_all(headers)	-- release the memory for headers.

		if has_writefunction then
			local response, size = curl.curl_easy_getopt_writedata(memory)
			
			thread = nil	-- allows the GC to reclaim the working thread.
			curl.libc_free(memory)
			
			assert(#response == size)
			returns.writefunction = function () return code, response, size end
		end
		
		return returns
	end
end

return curl

