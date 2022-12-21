
local libcurl = require 'libcurllua'

local curl = {}
setmetatable(curl, {__index = libcurl})

function curl.assertCURLE_OK (code, ...)
	assert(code == curl.CURLcode.CURLE_OK)
	return ...
end

function curl.curl_easy_do(handler)
	local cu = curl.curl_easy_init()
	local tbl = table.pack(pcall(handler, cu))
	curl.curl_easy_cleanup(cu)
	return table.unpack (tbl)
end

function curl.curl_slist(tbl)

	local list = curl.NULL

	for k, v in pairs(tbl) do
		local h = k .. ': ' .. v
		list = curl.curl_slist_append(list, h)
	end

	return list
end

function curl.curl_easy_setopt(cu, tbl)

	local returns = {}
			
	for k, v in pairs(tbl) do
		local setopt_k = curl['curl_easy_setopt_' .. k]
		if type(setopt_k) == 'function' then
			local r = table.pack(setopt_k(cu, v))
			returns[k] = function () return table.unpack(r) end
		end
	end
	
	return returns
	
end

function curl.curl_easy_getinfo(cu, tbl)

	local getinfos = {}
			
	for k, enabled in pairs(tbl) do
		if enabled then
			local getinfo_k = curl['curl_easy_getinfo_' .. k]
			if type(getinfo_k) == 'function' then
				local r = table.pack(getinfo_k(cu))
				getinfos[k] = function () return table.unpack(r) end
			end
		end
	end
	
	return getinfos
	
end

function curl.curl_easy_httpheader_setopt_getinfo (tbl)

	local headers_tbl, setopt_tbl, getinfo_tbl = 
		tbl.httpheader, tbl.setopt, tbl.getinfo
	
	headers_tbl = headers_tbl or {}
	setopt_tbl = setopt_tbl or {}
	getinfo_tbl = getinfo_tbl or {}

	return function (cu)

		local headers = curl.curl_slist(headers_tbl)
		setopt_tbl.httpheader = headers	-- override anything already present for the headers.
				
		local returns = curl.curl_easy_setopt(cu, setopt_tbl)

		local pcode = curl.curl_easy_perform(cu) -- go!
		assert(pcode == curl.CURLcode.CURLE_OK)

		curl.curl_slist_free_all(headers)	-- release the memory for headers.

		if type(returns.writefunction) == 'function' then
			local code, thread = returns.writefunction()
			assert(code == curl.CURLcode.CURLE_OK)
		
			local response, size = curl.curl_easy_getopt_writedata(thread)
			thread = nil	-- to let the GC to reclaim such thread.

			assert(#response == size)
			function returns.writefunction () return code, response, size end
		end

		if type(returns.readfunction) == 'function' then
			local code, thread = returns.readfunction()
			assert(code == curl.CURLcode.CURLE_OK)

			thread = nil

			function returns.readfunction () return code end
		end

		if type(returns.readfunction_filename) == 'function' then
			local code, file = returns.readfunction_filename()
			assert(code == curl.CURLcode.CURLE_OK)
			curl.libc_fclose(file)

			function returns.readfunction_filename () return code end
		end

		if type(returns.readfunction_string) == 'function' then
			local code, thread = returns.readfunction_string()
			assert(code == curl.CURLcode.CURLE_OK)
			thread = nil	-- release the pointer to the auxiliary thread
			
			function returns.readfunction_string () return code end
		end

		local getinfos = curl.curl_easy_getinfo(cu, getinfo_tbl)
		
		return returns, getinfos
	end
end

function curl.chunked (str, callback)

	callback = callback or function (...) end
	local i = 1	-- the index that remembers the next character to copy from payload
	local step = 1

	return function (atmost)
		
		local chunk = string.sub(str, i, i + atmost - 1)

		callback(step, atmost, chunk)	-- just inform about the current chunk.

		step = step + 1
		i = i + atmost
		return chunk
	end
end


return curl

