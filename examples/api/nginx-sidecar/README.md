# nginx-sidecar

## Prérequis

 - docker
 - docker-compose

## Lancer

```sh
docker-compose up
```

## Tester

```sh
$ curl -i -k -X GET https://127.0.0.1:443

> HTTP/1.1 200 OK
> Server: nginx/1.13.12
> Date: Sun, 27 May 2018 19:29:46 GMT
> Content-Length: 18
> Connection: keep-alive
>
> Hello from my-api!
```
