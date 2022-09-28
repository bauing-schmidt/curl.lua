
linux:
	gcc -O2 -std=gnu99 -fPIC -Wall -g -I/usr/local/include/ -s -shared -o \
		libcurllua.so libcurllua.c -lcurl -L/usr/local/lib/ -llua 


mingw:
	gcc -O2 -std=gnu99 -fPIC -Wall -g -I/usr/local/include/ -s -shared -o libcurllua.dll libcurllua.c -lcurl -L/usr/local/lib/ -llua54
	mv libcurllua.dll /usr/local/lib/lua/5.4/
	cp curl.lua /usr/local/share/lua/5.4/

mingw1:
	gcc -O2 -std=gnu99 -fPIC -Wall -g -I/usr/local/include/ -I/d/snapshots/curl-7.85.0_1-win64-mingw/include/curl/ -s -shared -o \
		libcurllua.dll libcurllua.c -L/d/snapshots/curl-7.85.0_1-win64-mingw/bin/ -lcurl-x64 -L/usr/local/lib/ -llua54
	mv libcurllua.dll /usr/local/lib/lua/5.4/
	cp curl.lua /usr/local/share/lua/5.4/

install:
	mkdir -p /usr/local/lib/lua/5.4/	# just for ensuring that the dest dir exists
	mkdir -p /usr/local/share/lua/5.4/	# just for ensuring that the dest dir exists
	mv libcurllua.so /usr/local/lib/lua/5.4/
	cp curl.lua /usr/local/share/lua/5.4/
