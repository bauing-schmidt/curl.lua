

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

	local code

	code = curl.curl_easy_setopt_url(cu, 'https://app.apptivegrid.de/api/users/6315f0a9f5ca3bb794a42cb3/spaces/6315f0b667d3ac2664a44f52/grids/631ee7590cb7e1473fa4c5ee')
	assert(code == 0)

	code = curl.curl_easy_setopt_verbose(cu, true)
	assert(code == 0)

	code = curl.curl_easy_setopt_cainfo(cu, 'curl-ca-bundle.crt')
	assert(code == 0)

	code = curl.curl_easy_setopt_username(cu, '')
	assert(code == 0)

	code = curl.curl_easy_setopt_password(cu, '')
	assert(code == 0)

	code = curl.curl_easy_perform(cu)
	assert(code == 0)

end

--curl.with_easy_handle_do(G)
curl.with_easy_handle_do(apptivegrid)
