ngx.header.content_type = "application/json; charset=utf-8"


if not (ngx.var.request_method == 'POST') then
    ngx.say("POST method only.")
    return ngx.exit(ngx.HTTP_NOT_ALLOWED)
end


local cjson = require("cjson.safe")


-- Parse request data

ngx.req.read_body()
local data, err = cjson.decode(ngx.req.get_body_data())
if not data then
    ngx.say("Wrong data passed.")
    return ngx.exit(ngx.HTTP_BAD_REQUEST)
elseif not data.db then
    ngx.say("Redis database number missed.")
    return ngx.exit(ngx.HTTP_BAD_REQUEST)
elseif not (type(data.db) == 'number') or not (data.db%1 == 0) then
    ngx.say("Redis database number has to be an integer.")
    return ngx.exit(ngx.HTTP_BAD_REQUEST)
elseif not data.key then
    ngx.say("Data key missed.")
    return ngx.exit(ngx.HTTP_BAD_REQUEST)
elseif not (type(data.key) == 'string') then
    ngx.say("Data key has to be a string.")
    return ngx.exit(ngx.HTTP_BAD_REQUEST)
elseif not data.value then
    ngx.say("Data value missed.")
    return ngx.exit(ngx.HTTP_BAD_REQUEST)
end


local rds = require("resty.redis")


-- Connect to redis

local red = rds:new()
red:set_timeout(1000) -- 1 sec

local ok, err = red:connect("redis", 6379)
if not ok then
    ngx.log(ngx.ERR, "Failed to connect to redis.")
    ngx.log(ngx.ERR, err)
    return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end


-- Select redis db

local ok, err = red:select(data.db)
if not ok then
    ngx.log(ngx.ERR, "Failed to connect to redis db.")
    ngx.log(ngx.ERR, err)
    return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end


-- Store data to redis

local ok, err = red:set(data.key, cjson.encode(data.value))
if not ok then
    ngx.log(ngx.ERR, "Failed to set data to redis.")
    ngx.log(ngx.ERR, err)
    return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end
