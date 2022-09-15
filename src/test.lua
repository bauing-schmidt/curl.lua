

local libcurllua = require 'libcurllua'

local code

local cu = libcurllua.curl_easy_init()

code = libcurllua.curl_easy_setopt_url(cu, 'https://www.google.com')
assert(code == 0)

code = libcurllua.curl_easy_setopt_verbose(cu, true)
assert(code == 0)

code = libcurllua.curl_easy_setopt_cainfo(cu, 'curl-ca-bundle.crt')
assert(code == 0)

code = libcurllua.curl_easy_perform(cu)
assert(code == 0)

libcurllua.curl_easy_cleanup(cu)
