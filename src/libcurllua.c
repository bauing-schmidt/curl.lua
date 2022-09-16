
/* 
	This is a glue c file for importing delta client c functions into Lua workflow.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
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

static int l_curl_easy_setopt_username(lua_State *L) {
	
	CURL *curl = (CURL *)lua_touserdata(L, -2);
	const char *username = lua_tostring(L, -1);
		
	CURLcode code =	curl_easy_setopt(curl, CURLOPT_USERNAME, username);

	lua_pushinteger(L, code);

	return 1;
}

static int l_curl_easy_setopt_password(lua_State *L) {
	
	CURL *curl = (CURL *)lua_touserdata(L, -2);
	const char *passwd = lua_tostring(L, -1);
		
	CURLcode code =	curl_easy_setopt(curl, CURLOPT_PASSWORD, passwd);

	lua_pushinteger(L, code);

	return 1;
}

static int l_curl_easy_setopt_httpheader(lua_State *L) {
	
	CURL *curl = (CURL *)lua_touserdata(L, -2);
	struct curl_slist *list = (struct curl_slist *)lua_touserdata(L, -1);

	CURLcode code =	curl_easy_setopt(curl, CURLOPT_HTTPHEADER, list);

	lua_pushinteger(L, code);

	return 1;
}

static int l_curl_slist_append(lua_State *L) {
	
	struct curl_slist *list = (struct curl_slist *)lua_touserdata(L, -2);
	const char *header = lua_tostring(L, -1);

	list = curl_slist_append(list, header);

	lua_pushlightuserdata (L, (void *)list);

	return 1;
}

static int l_curl_slist_free_all(lua_State *L) {
	
	struct curl_slist *list = (struct curl_slist *)lua_touserdata(L, -1);

	curl_slist_free_all(list);

	return 0;
}

struct memory {
	lua_State *L;
	char *response;
	size_t size;
};
 
static size_t cb(void *data, size_t size, size_t nmemb, void *userp)
{
  assert(size == 1); // according to the documentation.
  
  size_t realsize = size * nmemb;
  
  struct memory *mem = (struct memory *)userp;

  char *ptr = realloc(mem->response, mem->size + realsize + 1);

  if(ptr == NULL)
    return 0;  

  mem->response = ptr;
  memcpy(&(mem->response[mem->size]), data, realsize);
  mem->size += realsize;
  mem->response[mem->size] = 0;

  return realsize;
}

static int l_curl_easy_setopt_writefunction(lua_State *L) {
	
	CURL *curl = (CURL *)lua_touserdata(L, -2);
	
	CURLcode code =	curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, cb);
	
	lua_pushinteger(L, code);

	return 1;
}

static int l_curl_easy_setopt_writedata(lua_State *L) {
	
	CURL *curl = (CURL *)lua_touserdata(L, -2);
	
	struct memory *mem = (struct memory *) malloc( sizeof( struct memory ));
	mem->L = L;
	mem->response = NULL;
	mem->size = 0;
	
	CURLcode code = curl_easy_setopt(curl, CURLOPT_WRITEDATA,  mem);
	
	lua_pushinteger(L, code);
	lua_pushlightuserdata(L, mem);

	return 2;
}

static int l_curl_easy_getopt_writedata(lua_State *L) {
	
	struct memory *mem = (struct memory *)lua_touserdata(L, -1);
	lua_pushstring(L, mem->response);
	return 1;
}

static int l_libc_free(lua_State *L) {
	void *p = lua_touserdata(L, -1);
	free(p);
	return 0;
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
	{"curl_easy_setopt_username", l_curl_easy_setopt_username},
	{"curl_easy_setopt_password", l_curl_easy_setopt_password},
	{"curl_easy_setopt_httpheader", l_curl_easy_setopt_httpheader},
	{"curl_easy_setopt_writefunction", l_curl_easy_setopt_writefunction},
	{"curl_easy_setopt_writedata", l_curl_easy_setopt_writedata},
	{"curl_easy_getopt_writedata", l_curl_easy_getopt_writedata},
	{"curl_easy_perform", l_curl_easy_perform},
	{"curl_slist_append", l_curl_slist_append},
	{"curl_slist_free_all", l_curl_slist_free_all},
	{"libc_free", l_libc_free},
	{NULL, NULL} /* sentinel */
};
 
int luaopen_libcurllua (lua_State *L) {
	luaL_newlib(L, libcurl);
	return 1;
}

