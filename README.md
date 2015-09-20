# Nginx Lua Script for proxy request
----------------

### Overview
Nginx plugin is designed leveraging power of `ngx_lua` module, a 3rd party module used for customizing nginx web server. Script designed to catch incoming http request to web server and pass as subrequest to any remote server.


### Intregrate
- `nginx.conf` : a sample config file that describes a use case of plugin.
- `subreq_catcher.lua` : lua access handler 

#### 2. Configuration
Nginx plugin requires `ngx_lua` module (a 3rd party). If you are using `openresty` then `ngx_lua` is already configured. 
> Note : `ngx_lua` : [http://wiki.nginx.org/HttpLuaModule#Installation](http://wiki.nginx.org/HttpLuaModule#Installation)

### 3. Setting files
Copy `subreq_catcher.lua` into `/lua` folder where all your `conf/` and other nginx folder resides.

### 4. Setting Web server 

- Configure your main `nginx.conf` file, inside `http` block as below:
> see `nginx.conf` file for example and set accordingly.
```
    #------ mention the lua script path ------#
    lua_package_path "./lua/?.lua;;";

    #---  proxy upstream details
    upstream remoteserver{
       #server   IP or hostname;
    }
```
- Include below `location` block at the end of `server` block 
```
        #------ Proxy_pass the request to Remote Server
        location /send/to/remoteserver/ {
            internal;
            resolver 8.8.8.8;
            proxy_set_header HOST $host;
            proxy_pass   http://remoteserver;
            proxy_connect_timeout 100ms;
        }
```
> This above location block will make a proxy call to our remote server API with some body set in lua script.

- Include below lines to each location block to catch request and pass to remote server.
```
        location /some/route/ {
            #----- call module at beginning of block -----#
            set $sspid '';
            access_by_lua_file  ./lua/subreq_catcher.lua;


            #---- server logic here ------#
            echo  "Hello Nginx";

        }
```
- Now, reload the configuration and everything is set.
