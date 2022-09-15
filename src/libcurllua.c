
/* 
	This is a glue c file for importing delta client c functions into Lua workflow.
*/

#include <stdio.h>
#include <lua.h>
#include <lauxlib.h>
#include <curl/curl.h>

/* CURL *curl_easy_init(void); */
static int l_curl_easy_init(lua_State *L) {
	
	CURL *curl = curl_easy_init();
	
	lua_pushlightuserdata(L, (void *) curl);

	return 1;
}

/* void curl_easy_cleanup(CURL *curl); */
static int l_curl_easy_cleanup(lua_State *L) {
	
	CURL *curl = (CURL *)lua_touserdata(L, -1);
		
	curl_easy_cleanup(curl);

	return 0;
}

/* CURLcode curl_easy_perform(CURL *curl); */
static int l_curl_easy_perform(lua_State *L) {
	
	CURL *curl = (CURL *)lua_touserdata(L, -1);
		
	CURLcode code = curl_easy_perform(curl);

	lua_pushinteger(L, code);

	return 1;
}

static int l_curl_easy_setopt_url(lua_State *L) {
	
	CURL *curl = (CURL *)lua_touserdata(L, -2);
	const char *url = lua_tostring(L, -1);
		
	CURLcode code =	curl_easy_setopt(curl, CURLOPT_URL, url);

	lua_pushinteger(L, code);

	return 1;
}

static int l_curl_easy_setopt_verbose(lua_State *L) {
	
	CURL *curl = (CURL *)lua_touserdata(L, -2);
	int onoff = lua_toboolean(L, -1);
		
	CURLcode code =	curl_easy_setopt(curl, CURLOPT_VERBOSE, onoff);

	lua_pushinteger(L, code);

	return 1;
}

static int l_curl_easy_setopt_capath(lua_State *L) {
	
	CURL *curl = (CURL *)lua_touserdata(L, -2);
	const char *path = lua_tostring(L, -1);
		
	CURLcode code =	curl_easy_setopt(curl, CURLOPT_CAPATH, path);

	lua_pushinteger(L, code);

	return 1;
}

static int l_curl_easy_setopt_cainfo(lua_State *L) {
	
	CURL *curl = (CURL *)lua_touserdata(L, -2);
	const char *path = lua_tostring(L, -1);
		
	CURLcode code =	curl_easy_setopt(curl, CURLOPT_CAINFO, path);

	lua_pushinteger(L, code);

	return 1;
}


/*
	Registration phase starts
*/

static const struct luaL_Reg libcurl [] = {
	{"curl_easy_init", l_curl_easy_init},
	{"curl_easy_cleanup", l_curl_easy_cleanup},
	{"curl_easy_setopt_url", l_curl_easy_setopt_url},
	{"curl_easy_setopt_verbose", l_curl_easy_setopt_verbose},
	{"curl_easy_setopt_capath", l_curl_easy_setopt_capath},
	{"curl_easy_setopt_cainfo", l_curl_easy_setopt_cainfo},
	{"curl_easy_perform", l_curl_easy_perform},
	{NULL, NULL} /* sentinel */
};
 
int luaopen_libcurllua (lua_State *L) {
	luaL_newlib(L, libcurl);
	return 1;
}

