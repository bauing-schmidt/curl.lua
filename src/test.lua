
local curl = require 'curl'

curl.easyhandle(function (lib, cu)
	local code

	code = lib.curl_easy_setopt_url(cu, 'https://www.google.com')
	assert(code == 0)

	code = lib.curl_easy_perform(cu)
	assert(code == 0)
end)
