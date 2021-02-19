ngx.header.content_type = "application/json; charset=utf-8"


if not (ngx.var.request_method == 'GET') then
    ngx.say("GET method only.")
    return ngx.exit(ngx.HTTP_NOT_ALLOWED)
end


-- Parse uri args

local args = ngx.req.get_uri_args()
if not args.db then
    ngx.say("Redis database number missed.")
    return ngx.exit(ngx.HTTP_BAD_REQUEST)
elseif not (type(tonumber(args.db)) == 'number') or not (tonumber(args.db)%1 == 0) then
    ngx.say("Redis database number has to be an integer.")
    return ngx.exit(ngx.HTTP_BAD_REQUEST)
elseif not args.key then
    ngx.say("Data key missed.")
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

local ok, err = red:select(args.db)
if not ok then
    ngx.log(ngx.ERR, "Failed to connect to redis db.")
    ngx.log(ngx.ERR, err)
    return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end


-- Get data from redis

local data, err = red:get(args.key)
if not data then
    ngx.say(data)
else
    local cjson = require("cjson.safe")
    ngx.say(cjson.encode(data))
end
