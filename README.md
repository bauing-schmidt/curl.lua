# libcurl.lua

This repository provides a Lua module with bindings for the **curl** library, see https://curl.se/libcurl/, and its C api in particular, also see https://curl.se/libcurl/c/.

To understand what is going on start by having a look at the tutorial https://curl.se/libcurl/c/libcurl-tutorial.html which describes the upstream library. We focus on the *easy* interface, so head to https://curl.se/libcurl/c/libcurl-easy.html; for the sake of completeness, both 

- the page about options https://curl.se/libcurl/c/easy_setopt_options.html and 
- the page about info https://curl.se/libcurl/c/easy_getinfo_options.html

are really interesting readings.

## Under the hood

### `src/libcurllua.c`

It is the glue layer over the upstream C implementation. In addition to the straighforward bindings, we also provide the functions

- `curl_easy_setopt_readfunction_filename(const char *)`, that uses a `FILE *` as source in the read callback;
- `curl_easy_setopt_readfunction_string(const char *)`, that uses a string as source in the read callback,

see https://curl.se/libcurl/c/CURLOPT_READFUNCTION.html to understand such option.

### `src/curl.lua`

The `curl` Lua module offers the following functions:

- `curl.curl_easy_do(handler)`, that ensures a correct allocation and free of the C handle;
- `curl.curl_slist(tbl)`, that buils `curl` lists (for headers as example);
- `curl.curl_easy_setopt(cu, tbl)`, that sets options for the next request;
- `curl.curl_easy_getinfo(cu, tbl)`, that gets info about the last request;
- `curl.curl_easy_httpheader_setopt_getinfo (tbl)`, that performs a request using either options and infos.

## Usage

### Compilation

It is mandatory to compile with `make`, according to the following dep
```bash
sudo apt-get install libcurl4-gnutls-dev
```
and, of course, to Lua (https://www.lua.org/). After that step, please also install with `sudo make install`.

### Test

Some examples of usage can be found in the [`test`](https://github.com/massimo-nocentini/libcurl.lua/tree/master/test) subdirectory. For the sake of example, here is a very simple interaction,
```lua
local code

code = curl.curl_easy_setopt_url(cu, 'https://www.google.com')
assert(code == curl.CURLcode.CURLE_OK)

code = curl.curl_easy_setopt_verbose(cu, true)
assert(code == curl.CURLcode.CURLE_OK)

code = curl.curl_easy_setopt_cainfo(cu, 'curl-ca-bundle.crt')
assert(code == curl.CURLcode.CURLE_OK)

code = curl.curl_easy_perform(cu)
assert(code == curl.CURLcode.CURLE_OK)
```
that requests the Google's home page.
