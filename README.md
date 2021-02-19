# Redis data manager

> Manage redis data by nginx with lua and json


## Requirements
- docker>=19.03
- docker-compose>=1.25.5


## Deploy
- `$ docker-compose up`


## Usage

### Set data
```shell
curl -d '{"db": 5, "key": "some_key", "value": {"foo": "bar"}}' -H "Content-Type: application/json" -X POST http://localhost/set_data/
```

### Get data
```shell
$ curl 'http://localhost/get_data/?db=5&key=some_key'
"{\"foo\":\"bar\"}"
```
