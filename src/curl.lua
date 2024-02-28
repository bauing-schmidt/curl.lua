
local libcurl = require 'libcurllua'

local curl = {}
setmetatable(curl, {__index = libcurl})

curl.easy = {
	init = curl.curl_easy_init,
	cleanup = curl.curl_easy_cleanup,
	reset = curl.curl_easy_reset,
	perform = curl.curl_easy_perform,
	header = curl.curl_easy_header,
	getinfo = curl.curl_easy_getinfo,
}

curl.slist = {
	append = curl.curl_slist_append,
	free_all = curl.curl_slist_free_all,
	empty = curl.curl_slist_empty,
}

function curl.assertCURLE_OK (code, ...)
	assert(code == curl.CURLcode.OK)
	return ...
end

function curl.with_easy_pcall_recv_do (recv)
	return curl.curl_easy_do (
		function (curl_easy_handler)
			return recv (function (f) return pcall (f, curl_easy_handler) end)
		end
	)
end

local function pcall_pre_post (pre, f, post)

	return function (...)
		if pre then pre (...) end

		local function recv (...) 
			post (...)
			return ... 
		end

		return recv (pcall (f, ...))
	end
end

function curl.easy.with_handle_do (handler)
	local cu = curl.easy.init()
	local o = pcall_pre_post (nil, handler, function () curl.easy.cleanup (cu) end) 
	return o (cu)
end

function curl.slist.create (tbl)

	local list = curl.slist.empty ()

	for k, v in pairs(tbl) do list = curl.slist.append(list, k .. ': ' .. v) end

	return list
end

function curl.easy.setopt(cu, tbl)

	local thunks = {}

	for k, v in pairs(tbl) do
		local setopt_k = curl['curl_easy_setopt_' .. k]
		if type(setopt_k) == 'function' then
			local r = table.pack(setopt_k(cu, v))
			thunks[k] = function () return table.unpack(r) end
		end
	end
	
	return thunks
	
end

function curl.easy.getinfo(cu, tbl)

	local thunks = {}
			
	for k, enabled in pairs(tbl) do
		if enabled then
			local getinfo_k = curl['curl_easy_getinfo_' .. k]
			if type(getinfo_k) == 'function' then
				local r = table.pack(getinfo_k(cu))
				thunks[k] = function () return table.unpack(r) end
			end
		end
	end
	
	return thunks
	
end

function curl.easy.httpheader_setopt_getinfo (tbl)

	-- handle here a new table for headers from the server.
	local headers_tbl, setopt_tbl, getinfo_tbl, response_headers = 
		tbl.httpheader or {}, 
		tbl.setopt or {}, 
		tbl.getinfo or {}, 
		tbl.response_headers or {}

	return function (cu)

		curl.easy.reset (cu)	-- reset the session handler because we have new params here.

		local headers = curl.slist.create (headers_tbl)
		setopt_tbl.httpheader = headers	-- override anything already present for the headers.
				
		local returns = curl.easy.setopt(cu, setopt_tbl)

		local pcode = curl.easy.perform(cu) -- go!

		curl.slist.free_all(headers)	-- release the memory for headers.

		local post_headers = curl.easy.header (cu, response_headers.request or 0)

		if type(returns.writefunction) == 'function' then
			local code, chunk_ptr, handler = returns.writefunction()

			if handler == true then handler = function (...) return ... end end

			local code, response, size = curl.curl_easy_getopt_writedata(chunk_ptr)
			
			function returns.writefunction () return handler (code, response, size) end
		end

		if type(returns.readfunction) == 'function' then
			local code, thread = returns.readfunction()
			
			thread = nil

			function returns.readfunction () return code end
		end

		if type(returns.readfunction_filename) == 'function' then
			local code, file = returns.readfunction_filename()
			curl.libc_fclose(file)

			function returns.readfunction_filename () return code end
		end

		if type(returns.readfunction_string) == 'function' then
			local code, thread = returns.readfunction_string()
			thread = nil	-- release the pointer to the auxiliary thread
			
			function returns.readfunction_string () return code end
		end

		local getinfos = curl.easy.getinfo(cu, getinfo_tbl)

		return returns, getinfos, post_headers
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

