
local curl = require 'curl'
local op = require 'operator'

local function G (cu)

	local code

	code = curl.curl_easy_setopt_url(cu, 'https://www.google.com')
	assert(code == curl.CURLcode.CURLE_OK)

	code = curl.curl_easy_setopt_verbose(cu, true)
	assert(code == curl.CURLcode.CURLE_OK)

	code = curl.curl_easy_setopt_cainfo(cu, 'curl-ca-bundle.crt')
	assert(code == curl.CURLcode.CURLE_OK)

	code = curl.curl_easy_perform(cu)
	assert(code == curl.CURLcode.CURLE_OK)

end

--------------------------------------------------------------------------------
print('cURL version: ' .. curl.curl_version() .. '\n')
--------------------------------------------------------------------------------

-- curl.curl_easy_do(G)

local flag, returns, getinfo, headers = curl.curl_easy_do (
	curl.curl_easy_httpheader_setopt_getinfo {
		httpheader = {
			
		},
		setopt = {
			-- verbose = true,
			-- cainfo = 'curl-ca-bundle.crt',
			url = 'https://www.google.com',
			writefunction = true,
		},
		getinfo = {
			response_code = true,
		},
	}
)



for k, v in pairs(headers) do
	print ('*****', k, v)
end