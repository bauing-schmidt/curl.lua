
local libcurl = require 'libcurllua'

local curl = {}
setmetatable(curl, {__index = libcurl})

-- NETRC options
curl.opt_netrc = {
	CURL_NETRC_IGNORED = 0,
	CURL_NETRC_OPTIONAL = 1,
	CURL_NETRC_REQUIRED = 2,
}

-- CURLcode enum
curl.CURLcode = {
	CURLE_OK = 0,
	CURLE_UNSUPPORTED_PROTOCOL = 1,
	CURLE_FAILED_INIT = 2,
	CURLE_URL_MALFORMAT = 3,
	CURLE_NOT_BUILT_IN = 4,
	CURLE_COULDNT_RESOLVE_PROXY = 5,
	CURLE_COULDNT_RESOLVE_HOST = 6,
	CURLE_COULDNT_CONNECT = 7,
	CURLE_WEIRD_SERVER_REPLY = 8, 
	CURLE_REMOTE_ACCESS_DENIED = 9, 
	CURLE_FTP_ACCEPT_FAILED = 10,
	CURLE_FTP_WEIRD_PASS_REPLY = 11,
	CURLE_FTP_ACCEPT_TIMEOUT = 12,
	CURLE_FTP_WEIRD_PASV_REPLY = 13,
	CURLE_FTP_WEIRD_227_FORMAT = 14,
	CURLE_FTP_CANT_GET_HOST = 15,
	CURLE_HTTP2 = 16,
	CURLE_FTP_COULDNT_SET_TYPE = 17,
	CURLE_PARTIAL_FILE = 18,
	CURLE_FTP_COULDNT_RETR_FILE = 19,
	--Obsolete error = 20,
	CURLE_QUOTE_ERROR = 21,
	CURLE_HTTP_RETURNED_ERROR = 22,
	CURLE_WRITE_ERROR = 23,
	--Obsolete error = 24,
	CURLE_UPLOAD_FAILED = 25,
	CURLE_READ_ERROR = 26,
	CURLE_OUT_OF_MEMORY = 27,
	CURLE_OPERATION_TIMEDOUT = 28,
	--Obsolete error = 29,
	CURLE_FTP_PORT_FAILED = 30,
	CURLE_FTP_COULDNT_USE_REST = 31,
	--Obsolete error = 32,
	CURLE_RANGE_ERROR = 33,
	CURLE_HTTP_POST_ERROR = 34,
	CURLE_SSL_CONNECT_ERROR = 35,
	CURLE_BAD_DOWNLOAD_RESUME = 36,
	CURLE_FILE_COULDNT_READ_FILE = 37,
	CURLE_LDAP_CANNOT_BIND = 38,
	CURLE_LDAP_SEARCH_FAILED = 39,
	--Obsolete error = 40,
	CURLE_FUNCTION_NOT_FOUND = 41,
	CURLE_ABORTED_BY_CALLBACK = 42,
	CURLE_BAD_FUNCTION_ARGUMENT = 43,
	--Obsolete error = 44,
	CURLE_INTERFACE_FAILED = 45,
	--Obsolete error = 46,
	CURLE_TOO_MANY_REDIRECTS = 47,
	CURLE_UNKNOWN_OPTION = 48,
	CURLE_SETOPT_OPTION_SYNTAX = 49,
	--Obsolete errors = 50-51,
	CURLE_GOT_NOTHING = 52,
	CURLE_SSL_ENGINE_NOTFOUND = 53,
	CURLE_SSL_ENGINE_SETFAILED = 54,
	CURLE_SEND_ERROR = 55,
	CURLE_RECV_ERROR = 56,
	--Obsolete error = 57,
	CURLE_SSL_CERTPROBLEM = 58,
	CURLE_SSL_CIPHER = 59,
	CURLE_PEER_FAILED_VERIFICATION = 60,
	CURLE_BAD_CONTENT_ENCODING = 61,
	--Obsolete error = 62,
	CURLE_FILESIZE_EXCEEDED = 63,
	CURLE_USE_SSL_FAILED = 64,
	CURLE_SEND_FAIL_REWIND = 65,
	CURLE_SSL_ENGINE_INITFAILED = 66,
	CURLE_LOGIN_DENIED = 67,
	CURLE_TFTP_NOTFOUND = 68,
	CURLE_TFTP_PERM = 69,
	CURLE_REMOTE_DISK_FULL = 70,
	CURLE_TFTP_ILLEGAL = 71,
	CURLE_TFTP_UNKNOWNID = 72,
	CURLE_REMOTE_FILE_EXISTS = 73,
	CURLE_TFTP_NOSUCHUSER = 74,
	--Obsolete error = 75-76,
	CURLE_SSL_CACERT_BADFILE = 77,
	CURLE_REMOTE_FILE_NOT_FOUND = 78,
	CURLE_SSH = 79,
	CURLE_SSL_SHUTDOWN_FAILED = 80,
	CURLE_AGAIN = 81,
	CURLE_SSL_CRL_BADFILE = 82,
	CURLE_SSL_ISSUER_ERROR = 83,
	CURLE_FTP_PRET_FAILED = 84,
	CURLE_RTSP_CSEQ_ERROR = 85,
	CURLE_RTSP_SESSION_ERROR = 86,
	CURLE_FTP_BAD_FILE_LIST = 87,
	CURLE_CHUNK_FAILED = 88,
	CURLE_NO_CONNECTION_AVAILABLE = 89,
	CURLE_SSL_PINNEDPUBKEYNOTMATCH = 90,
	CURLE_SSL_INVALIDCERTSTATUS = 91,
	CURLE_HTTP2_STREAM = 92,
	CURLE_RECURSIVE_API_CALL = 93,
	CURLE_AUTH_ERROR = 94,
	CURLE_HTTP3 = 95,
	CURLE_QUIC_CONNECT_ERROR = 96,
	CURLE_PROXY = 97,
	CURLE_SSL_CLIENTCERT = 98,
	CURLE_UNRECOVERABLE_POLL = 99,
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
			returns[k] = function () return table.unpack(r) end
		end
	end
	
	return returns
	
end

function curl.curl_easy_getinfo(cu, tbl)

	local getinfos = {}
			
	for _, k in ipairs(tbl) do
		local getinfo_k = curl['curl_easy_getinfo_' .. k]
		if type(getinfo_k) == 'function' then
			local r = table.pack(getinfo_k(cu))
			getinfos[k] = function () return table.unpack(r) end
		end
	end
	
	return getinfos
	
end

function curl.curl_easy_httpheader_setopt_getinfo (tbl)

	local headers_tbl, setopt_tbl, getinfo_tbl = tbl.httpheader, tbl.setopt, tbl.getinfo
	
	headers_tbl = headers_tbl or {}
	setopt_tbl = setopt_tbl or {}
	getinfo_tbl = getinfo_tbl or {}

	return function (cu)

		local headers = curl.curl_slist(headers_tbl)
		setopt_tbl.httpheader = headers	-- override anything already present for the headers.
				
		local returns = curl.curl_easy_setopt(cu, setopt_tbl)

		local has_writefunction = type(returns.writefunction) == 'function'	-- because we use thunks to get results
		local code, memory, thread
		if has_writefunction then
			code, memory, thread = returns.writefunction()
			assert(code == curl.CURLcode.CURLE_OK)
		end

		local pcode = curl.curl_easy_perform(cu) -- go!
		assert(pcode == curl.CURLcode.CURLE_OK)

		curl.curl_slist_free_all(headers)	-- release the memory for headers.

		if has_writefunction then
			local response, size = curl.curl_easy_getopt_writedata(memory)
			
			thread = nil	-- allows the GC to reclaim the working thread.
			curl.libc_free(memory)
			
			assert(#response == size)
			returns.writefunction = function () return code, response, size end
		end

		if type(returns.readfunction) == 'function' then
			local code, memory, thread = returns.readfunction()
			assert(code == curl.CURLcode.CURLE_OK)
			curl.libc_free(memory)
			thread = nil

			function returns.readfunction () return code, nil, nil end
		end

		local getinfos = curl.curl_easy_getinfo(cu, getinfo_tbl)
		
		return returns, getinfos
	end
end



return curl

