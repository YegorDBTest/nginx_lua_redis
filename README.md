# Get json data from redis by nginx with lua


## Requirements
- docker>=19.03
- docker-compose>=1.25.5


## Deploy
- `$ docker-compose up`


## Usage
Set data
```shell
$ docker-compose exec redis redis-cli -n 10 set data "{\"foo\": \"bar\"}"
OK
```
Get data
```shell
$ curl http://localhost/
{"data":{"foo": "bar"}}
```
