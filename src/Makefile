
linux:
	gcc -O2 -std=gnu17 -fPIC -Wall -shared -o libcurllua.so libcurllua.c -lcurl -llua 

macos:
	cc -O2 -std=c11 -fPIC -Wall \
		-I/usr/local/include/ \
		-I/usr/local/Cellar/curl/7.86.0/include -dynamiclib -o \
		libcurllua.dylib libcurllua.c -L/usr/local/Cellar/curl/7.86.0/lib/ -lcurl -L/usr/local/lib/ -llua 

mingw:
	gcc -O2 -std=c11 -fPIC -Wall \
		-I/c/msys64/usr/local/include/ \
		-I/d/snapshots/curl-7.85.0_1-win64-mingw/include/ \
		-s -shared -o libcurllua.dll libcurllua.c \
		-L/d/snapshots/curl-7.85.0_1-win64-mingw/bin/ -lcurl-x64 \
		-L/c/msys64/usr/local/lib/ -llua54

install:
	mkdir -p /usr/local/lib/lua/5.4/	# just for ensuring that the dest dir exists
	mkdir -p /usr/local/share/lua/5.4/	# just for ensuring that the dest dir exists
	mv libcurllua.so /usr/local/lib/lua/5.4/
	cp curl.lua /usr/local/share/lua/5.4/

install-macos:
	mkdir -p /usr/local/lib/lua/5.4/	# just for ensuring that the dest dir exists
	mkdir -p /usr/local/share/lua/5.4/	# just for ensuring that the dest dir exists
	mv libcurllua.dylib /usr/local/lib/lua/5.4/
	cp curl.lua /usr/local/share/lua/5.4/

install-mingw:
	mkdir -p /usr/local/lib/lua/5.4/	# just for ensuring that the dest dir exists
	mkdir -p /usr/local/share/lua/5.4/	# just for ensuring that the dest dir exists
	mv libcurllua.dll /usr/local/lib/lua/5.4/
	cp curl.lua /usr/local/share/lua/5.4/
