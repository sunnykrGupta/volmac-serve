-------------------------
-- Lua script [Middleware] to catch request and send to remote_server
-------------------------

local head = ngx.req.get_headers(); -- print ngx headers
local args = ngx.req.get_uri_args();

local url = {};
-- add if args statement
table.insert(url, "?");
for key, val in pairs(args) do
    table.insert(url, tostring(key));
    table.insert(url, tostring("="));
    table.insert(url, tostring(val));
    table.insert(url, tostring("&"));
end

table.remove(url);
local temp = table.concat(url);
-- Contains
local var_url = ngx.var.host .. ngx.var.uri .. temp;



local store_key = {};
store_key['param_1'] = "1";
store_key['param_2'] = "2";
store_key['param_3'] = "3";
store_key['param_4'] = "4";

local api_table = {};

table.insert(api_table, "{");

for k,v in pairs(store_key) do
    table.insert(api_table, '"');
    table.insert(api_table, k);
    table.insert(api_table, '" : ');
    table.insert(api_table, '"');
    table.insert(api_table, v);
    table.insert(api_table, '"');
    table.insert(api_table, " , ");
end

table.remove(api_table);
table.insert(api_table, " } ");
local json_payload = table.concat(api_table);

local req_body = ngx.req.read_body();

local rem_server_response = ngx.location.capture("/send/to/remoteserver/", { method = ngx.HTTP_POST, body = json_payload });

return
