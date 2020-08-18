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

red:select(10) -- select 10th db


-- Get data from redis

local data, err = red:get("data")
if not data then
    ngx.log(ngx.ERR, "Failed to get data from redis.")
    ngx.log(ngx.ERR, err)
    return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end


-- Return json data

ngx.header.content_type = "application/json; charset=utf-8"
ngx.say('{"data":', data, '}')