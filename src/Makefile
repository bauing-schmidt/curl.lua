
linux:
	gcc -O2 -g -fPIC -Wall -shared -o libcurllua.so libcurllua.c -lcurl -llua 

macos:
	cc -O2 -g -fPIC -Wall \
		-I/usr/local/include/ \
		-I/usr/local/Cellar/curl/7.86.0/include -dynamiclib -o \
		libcurllua.dylib libcurllua.c -L/usr/local/Cellar/curl/7.86.0/lib/ -lcurl -L/usr/local/lib/ -llua 

mingw:
	gcc -O2 -g -fPIC -Wall \
		-I/usr/local/include/ \
		-I/ucrt64/include/ \
		-shared -o libcurllua.dll libcurllua.c \
		-L/usr/local/lib/ -llua54 \
		-L/ucrt64/bin/ -lcurl-4

jenkins:
	gcc -O2 -g -fPIC -Wall -shared -o libcurllua.dll libcurllua.c \
		-I../../../vm-dependencies/curl/ucrt64/include -I/usr/local/include -L../../../vm-dependencies/curl/ucrt64/bin -L/usr/local/lib \
		-llua54 -lcurl-4

install:
	mkdir -p /usr/local/lib/lua/5.4/	# just for ensuring that the dest dir exists
	mkdir -p /usr/local/share/lua/5.4/	# just for ensuring that the dest dir exists
	cp curl.lua /usr/local/share/lua/5.4/

install-linux: install
	mv libcurllua.so /usr/local/lib/lua/5.4/
	
install-macos: install
	mv libcurllua.dylib /usr/local/lib/lua/5.4/
	
install-mingw: install
	mv libcurllua.dll /usr/local/lib/lua/5.4/