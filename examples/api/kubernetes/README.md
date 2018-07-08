# kubernetes

## Prérequis

 - docker
 - kubernetes
 - minikube

## Lancer

```sh
kubetcl apply -f myapi-pod.yaml
```

## Tester

```sh
kubetcl port-forward myapi 8080:8080
```

Dans un autre terminal:

```sh
$ curl -i -k -X GET http://127.0.0.1:8080
```
