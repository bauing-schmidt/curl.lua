
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

struct memory {
	lua_State *L;
	char *response;
	size_t size;
};

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

static int l_curl_easy_setopt_header(lua_State *L) {
	
	CURL *curl = (CURL *)lua_touserdata(L, -2);
	int onoff = lua_toboolean(L, -1);
		
	CURLcode code =	curl_easy_setopt(curl, CURLOPT_HEADER, onoff);

	lua_pushinteger(L, code);

	return 1;
}

static int l_curl_easy_setopt_netrc(lua_State *L) {
	
	CURL *curl = (CURL *)lua_touserdata(L, -2);
	lua_Integer level = lua_tointeger(L, -1);

	CURLcode code =	curl_easy_setopt(curl, CURLOPT_NETRC, level);

	lua_pushinteger(L, code);

	return 1;
}

static int l_curl_easy_setopt_post(lua_State *L) {
	
	CURL *curl = (CURL *)lua_touserdata(L, -2);
	int post = lua_toboolean(L, -1);

	CURLcode code =	curl_easy_setopt(curl, CURLOPT_POST, post);

	lua_pushinteger(L, code);

	return 1;
}

static int l_curl_easy_setopt_verifyhost(lua_State *L) {
	
	CURL *curl = (CURL *)lua_touserdata(L, -2);
	int post = lua_toboolean(L, -1);

	CURLcode code =	curl_easy_setopt(curl, CURLOPT_SSL_VERIFYHOST, post);

	lua_pushinteger(L, code);

	return 1;
}

static int l_curl_easy_setopt_verifypeer(lua_State *L) {
	
	CURL *curl = (CURL *)lua_touserdata(L, -2);
	int post = lua_toboolean(L, -1);

	CURLcode code =	curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, post);

	lua_pushinteger(L, code);

	return 1;
}

static int l_curl_easy_setopt_httpget(lua_State *L) {
	
	CURL *curl = (CURL *)lua_touserdata(L, -2);
	int get = lua_toboolean(L, -1);

	CURLcode code =	curl_easy_setopt(curl, CURLOPT_HTTPGET, get);

	lua_pushinteger(L, code);

	return 1;
}

static int l_curl_easy_setopt_upload(lua_State *L) {
	
	CURL *curl = (CURL *)lua_touserdata(L, -2);
	int upload = lua_toboolean(L, -1);

	CURLcode code =	curl_easy_setopt(curl, CURLOPT_UPLOAD, upload);

	lua_pushinteger(L, code);

	return 1;
}

static int l_curl_easy_setopt_upload_buffersize(lua_State *L) {
	
	CURL *curl = (CURL *)lua_touserdata(L, -2);
	lua_Integer size = lua_tointeger(L, -1);

	CURLcode code =	curl_easy_setopt(curl, CURLOPT_UPLOAD_BUFFERSIZE, size);

	lua_pushinteger(L, code);

	return 1;
}

static int l_curl_easy_setopt_infilesize(lua_State *L) {
	
	CURL *curl = (CURL *)lua_touserdata(L, -2);
	lua_Integer size = lua_tointeger(L, -1);

	CURLcode code =	curl_easy_setopt(curl, CURLOPT_INFILESIZE, size);

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

static int l_curl_easy_setopt_postfields(lua_State *L) {
	
	CURL *curl = (CURL *)lua_touserdata(L, -2);
	const char *fields = lua_tostring(L, -1);
		
	CURLcode code =	curl_easy_setopt(curl, CURLOPT_POSTFIELDS, fields);

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


static int l_curl_easy_reset(lua_State *L) {
	
	CURL *curl = (CURL *)lua_touserdata(L, -1);
	
	curl_easy_reset(curl);

	return 0;
}

static int l_curl_easy_duphandle(lua_State *L) {
	
	CURL *curl = (CURL *)lua_touserdata(L, -1);
	
	CURL *dup = curl_easy_duphandle(curl);

	lua_pushlightuserdata(L, dup);

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

static size_t cb1(void *data, size_t size, size_t nmemb, void *userp)
{
	size_t realsize = cb(data, size, nmemb, userp);

	struct memory *mem = (struct memory *)userp;

	lua_State *L = (lua_State *) lua_touserdata(mem->L, -2);
	lua_pushvalue(mem->L, -1);	// duplicate the callback function for repeated applications of it.
	lua_xmove(mem->L, L, 1);
	lua_pushstring(L, mem->response);
	lua_pushinteger(L, realsize);
	lua_call(L, 2, 0);

	return realsize;
}

static int l_curl_easy_setopt_writefunction(lua_State *L) {
	
	CURL *curl = (CURL *)lua_touserdata(L, -2); 	// the second argument is the callback function
	int isfunction = lua_isfunction(L, -1);
	
	lua_State *S;
	CURLcode code;
	
	if (isfunction == 1) {
		S = lua_newthread (L); // such a new thread is pushed on L also.
		lua_pushlightuserdata(S, (void *) L); // put the current state itself
		lua_pushvalue(L, -2);	// duplicate the given function
		lua_xmove(L, S, 1);	// then save the doubled reference to the helper state.
		
		code =	curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, cb1);
	} else {
		S = NULL;
		code =	curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, cb);
	}
	
	struct memory *mem = (struct memory *) malloc( sizeof( struct memory ));
	mem->L = S;
	mem->response = NULL;
	mem->size = 0;
	
	CURLcode ccode = curl_easy_setopt(curl, CURLOPT_WRITEDATA,  mem);
	assert(ccode == 0);
	
	lua_pushinteger(L, code);
	lua_pushlightuserdata(L, mem);
	
	if (S != NULL) {
		lua_pushvalue(L, -3);	// duplicate the working thread
		lua_remove(L, -4);	// cleanup a doubled value
	} else {
		lua_pushnil(L);
	}

	return 3;
}

size_t read_callback(char *buffer, size_t size, size_t nitems, void *userdata) {

	assert(size == 1); // according to the documentation.

	struct memory *mem = (struct memory *)userdata;

	lua_State *L = (lua_State *) lua_touserdata(mem->L, -2);
	lua_pushvalue(mem->L, -1);	// duplicate the callback function for repeated applications of it.
	lua_xmove(mem->L, L, 1);
	lua_pushinteger(L, size * nitems-1);
	lua_call(L, 1, 1);
	const char *substr = lua_tostring(L, -1);
	lua_pop(L, 1);
	strcpy(buffer, substr);
	return strlen(substr);

}

static int l_curl_easy_setopt_readfunction(lua_State *L) {
	
	CURL *curl = (CURL *)lua_touserdata(L, -2); 	// the second argument is the callback function
	assert(lua_isfunction(L, -1));
	
	lua_State *S;
	CURLcode code;
	
	S = lua_newthread (L); // such a new thread is pushed on L also.
	lua_pushlightuserdata(S, (void *) L); // put the current state itself
	lua_pushvalue(L, -2);	// duplicate the given function
	lua_xmove(L, S, 1);	// then save the doubled reference to the helper state.
	
	code = curl_easy_setopt(curl, CURLOPT_READFUNCTION, read_callback);
	
	struct memory *mem = (struct memory *) malloc( sizeof( struct memory ));
	mem->L = S;
	mem->response = NULL;
	mem->size = 0;
	
	CURLcode ccode = curl_easy_setopt(curl, CURLOPT_READDATA,  mem);
	assert(ccode == 0);
	
	lua_pushinteger(L, code);
	lua_pushlightuserdata(L, mem);
	
	lua_pushvalue(L, -3);	// duplicate the working thread
	lua_remove(L, -4);	// cleanup a doubled value

	return 3;
}

size_t read_callback_filename(char *ptr, size_t size, size_t nmemb, void *userdata)
{
	FILE *readhere = (FILE *)userdata;
	curl_off_t nread;
	
	/* copy as much data as possible into the 'ptr' buffer, but no more than 'size' * 'nmemb' bytes! */
	size_t retcode = fread(ptr, size, nmemb, readhere);
	
	nread = (curl_off_t)retcode;
	
	fprintf(stderr, "*** We read %" CURL_FORMAT_CURL_OFF_T
			" bytes from file\n", nread);
	
	return retcode;
}

static int l_curl_easy_setopt_readfunction_filename(lua_State *L) {
	
	CURL *curl = (CURL *)lua_touserdata(L, -2);
	const char *filename = lua_tostring(L, -1);
	
	FILE *file = fopen(filename, "rb");

	CURLcode code = curl_easy_setopt(curl, CURLOPT_READFUNCTION, read_callback_filename);

	CURLcode ccode = curl_easy_setopt(curl, CURLOPT_READDATA,  file);
	assert(ccode == 0);
	
	lua_pushinteger(L, code);
	lua_pushlightuserdata(L, file);
	
	return 2;
}

size_t read_callback_string(char *ptr, size_t size, size_t nmemb, void *userdata)
{
	assert(size == 1);

	struct memory *mem = (struct memory *)userdata;

	size_t n;

	if (mem->size > 0) {

		n = mem->size < nmemb ? mem->size : nmemb;

		char *copied = strncpy(ptr, mem->response, n);

		assert(copied == ptr);	// according to the documentation

		mem->response = mem->response + n;
		mem->size = mem->size - n;

	} else {
		n = 0;
	}

	return n;
}

static int l_curl_easy_setopt_readfunction_string(lua_State *L) {
	
	CURL *curl = (CURL *)lua_touserdata(L, -2);
	const char *str = lua_tostring(L, -1);

	CURLcode code = curl_easy_setopt(curl, CURLOPT_READFUNCTION, read_callback_string);

	struct memory *mem = (struct memory *) malloc( sizeof( struct memory ));
	mem->L = L;
	mem->response = (char *) str;
	mem->size = strlen(str);

	CURLcode ccode = curl_easy_setopt(curl, CURLOPT_READDATA,  mem);
	assert(ccode == 0);
	
	lua_pushinteger(L, code);
	lua_pushlightuserdata(L, mem);
	
	return 2;
}

static int l_curl_easy_getopt_writedata(lua_State *L) {
	
	struct memory *mem = (struct memory *)lua_touserdata(L, -1);
	lua_pushstring(L, mem->response);
	lua_pushinteger(L, mem->size);
	return 2;
}

static int l_curl_easy_getinfo_response_code(lua_State *L) {
	
	CURL *curl = (CURL *)lua_touserdata(L, -1);
	
	long response_code;
	CURLcode code = curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &response_code);
	
	lua_pushinteger(L, code);
	lua_pushinteger(L, response_code);

	return 2;
}

static int l_curl_version(lua_State *L) {
	
	char *version =	curl_version();

	lua_pushstring(L, version);

	return 1;
}

static int l_curl_getdate(lua_State *L) {
	
	const char *datestr = lua_tostring(L, -1);
	time_t t = curl_getdate(datestr, NULL);

	lua_pushinteger(L, t);

	return 1;
}

static int l_curl_easy_escape(lua_State *L) {
	
	CURL *curl = (CURL *)lua_touserdata(L, -2);
	const char *str = lua_tostring(L, -1);
	
	char *encoded = curl_easy_escape(curl, str, 0);
	
	lua_pushstring(L, encoded);

	return 1;
}

static int l_curl_easy_unescape(lua_State *L) {
	
	CURL *curl = (CURL *)lua_touserdata(L, -2);
	const char *str = lua_tostring(L, -1);
	int size;	

	char *decoded = curl_easy_unescape(curl, str, 0, &size);
	
	lua_pushstring(L, decoded);
	lua_pushinteger(L, size);

	return 2;
}

static int l_curl_free(lua_State *L) {
	const char *str = lua_tostring(L, -1);
	curl_free((char *)str);

	return 0;
}

static int l_libc_free(lua_State *L) {
	void *p = lua_touserdata(L, -1);
	free(p);

	return 0;
}

static int l_libc_fclose(lua_State *L) {
	FILE *p = (FILE *) lua_touserdata(L, -1);
	int r = fclose(p);

	lua_pushinteger(L, r);

	return 1;
}

static int l_test(lua_State *L) {
	lua_State *S = lua_newthread (L); // such a new thread is pushed on L also.
	lua_Integer i = lua_tointeger(L, -2);
	lua_pushinteger(S, i);
	assert(lua_tointeger(S, -1) == 42);
	return 1;
}

static int l_test_func(lua_State *L) {
	lua_State *S = lua_newthread (L); // such a new thread is pushed on L also.
	lua_pushvalue(L, -2);	// duplicate the given function
	lua_xmove(L, S, 1);
	return 1; // the thread actually
}

/*
	Registration phase starts
*/

static const struct luaL_Reg libcurl [] = {
	{"curl_easy_init", l_curl_easy_init},
	{"curl_easy_cleanup", l_curl_easy_cleanup},
	{"curl_easy_reset", l_curl_easy_reset},
	{"curl_easy_duphandle", l_curl_easy_duphandle},
	{"curl_easy_setopt_url", l_curl_easy_setopt_url},
	{"curl_easy_setopt_header", l_curl_easy_setopt_header},
	{"curl_easy_setopt_netrc", l_curl_easy_setopt_netrc},
	{"curl_easy_setopt_post", l_curl_easy_setopt_post},
	{"curl_easy_setopt_verifyhost", l_curl_easy_setopt_verifyhost},
	{"curl_easy_setopt_verifypeer", l_curl_easy_setopt_verifypeer},
	{"curl_easy_setopt_upload", l_curl_easy_setopt_upload},
	{"curl_easy_setopt_upload_buffersize", l_curl_easy_setopt_upload_buffersize},
	{"curl_easy_setopt_infilesize", l_curl_easy_setopt_infilesize},
	{"curl_easy_setopt_httpget", l_curl_easy_setopt_httpget},
	{"curl_easy_setopt_verbose", l_curl_easy_setopt_verbose},
	{"curl_easy_setopt_capath", l_curl_easy_setopt_capath},
	{"curl_easy_setopt_cainfo", l_curl_easy_setopt_cainfo},
	{"curl_easy_setopt_username", l_curl_easy_setopt_username},
	{"curl_easy_setopt_password", l_curl_easy_setopt_password},
	{"curl_easy_setopt_postfields", l_curl_easy_setopt_postfields},
	{"curl_easy_setopt_httpheader", l_curl_easy_setopt_httpheader},
	{"curl_easy_setopt_writefunction", l_curl_easy_setopt_writefunction},
	{"curl_easy_setopt_readfunction", l_curl_easy_setopt_readfunction},
	{"curl_easy_setopt_readfunction_filename", l_curl_easy_setopt_readfunction_filename},
	{"curl_easy_setopt_readfunction_string", l_curl_easy_setopt_readfunction_string},
	{"curl_easy_getinfo_response_code", l_curl_easy_getinfo_response_code},
	{"curl_easy_getopt_writedata", l_curl_easy_getopt_writedata},
	{"curl_easy_perform", l_curl_easy_perform},
	{"curl_slist_append", l_curl_slist_append},
	{"curl_slist_free_all", l_curl_slist_free_all},
	{"curl_version", l_curl_version},
	{"curl_getdate", l_curl_getdate},
	{"curl_easy_escape", l_curl_easy_escape},
	{"curl_easy_unescape", l_curl_easy_unescape},
	{"libc_free", l_libc_free},
	{"libc_fclose", l_libc_fclose},
	{"curl_free", l_curl_free},
	{"test", l_test},
	{"test_func", l_test_func},
	{NULL, NULL} /* sentinel */
};
 
int luaopen_libcurllua (lua_State *L) {
	luaL_newlib(L, libcurl);
	return 1;
}

