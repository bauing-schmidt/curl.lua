

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

curl.with_easy_handle_do(G)
