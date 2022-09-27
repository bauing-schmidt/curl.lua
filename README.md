# libcurl.lua

This repository provides a Lua module with bindings for the **curl** library, see https://curl.se/libcurl/, and its C api in particular, also see https://curl.se/libcurl/c/.

To understand what is going on start by having a look at the tutorial https://curl.se/libcurl/c/libcurl-tutorial.html which describes the upstream library. We focus on the *easy* interface, so head to https://curl.se/libcurl/c/libcurl-easy.html; for the sake of completeness, both the page about options https://curl.se/libcurl/c/easy_setopt_options.html and about info https://curl.se/libcurl/c/easy_getinfo_options.html are really interesting.

## Usage

### Compilation

It is mandatory to compile with `make`, according to the following dep
```bash
sudo apt-get install libcurl4-gnutls-dev
```
and, of course, to Lua (https://www.lua.org/). After that step, please also install with `sudo make install`.
