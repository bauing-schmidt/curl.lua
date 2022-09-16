

local curl = require 'curl'

local function G (cu)

	local code

	code = curl.curl_easy_setopt_url(cu, 'https://www.google.com')
	assert(code == 0)

	code = curl.curl_easy_setopt_verbose(cu, true)
	assert(code == 0)

	code = curl.curl_easy_setopt_cainfo(cu, 'curl-ca-bundle.crt')
	assert(code == 0)

	code = curl.curl_easy_perform(cu)
	assert(code == 0)

end

local function apptivegrid (cu)

	curl.with_http_header_do({ 
			Accept = 'application/vnd.apptivegrid.hal;version=2' 
		},
		function (headers) 
			
			curl.curl_easy_setopt {
				url = 'https://app.apptivegrid.de/api/users/6315f0a9f5ca3bb794a42cb3/spaces/6315f0b667d3ac2664a44f52/grids/631ee7590cb7e1473fa4c5ee',
				verbose = true,
				cainfo = 'curl-ca-bundle.crt',
				username = 'c50898f167bbe225b0a1323e9b521ebb',
				password = '7pwzdl44ncldskvh6mdo9zj8b',
				httpheader = headers,
				writefunction = 3,
				writedata = 3,
			} (cu)
			
			code = curl.curl_easy_perform(cu)
			assert(code == 0)
		end)

end


--curl.with_easy_handle_do(G)
curl.with_easy_handle_do(apptivegrid)
