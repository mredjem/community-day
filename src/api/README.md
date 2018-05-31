# API Gateway vs Service Mesh

Ce post a pour but de présenter les outils permettant de simplifier la mise en place d'une architecture microservices.

## La méthode old-school

Historiquement les applications métiers étaient essentiellement des applications monolithes concentrant l'intégralité des briques logicielles au sein d'un même livrable.

Au fil du temps cette approche a entraîné des contraintes de plus en plus fortes à la maintenance du projet. La base de code grossit, se complexifie et il devient alors difficile de comprendre les interactions et les règles fonctionnelles de notre application.

Au final notre monolithe va consister en un mélange de briques techniques aux responsabilités diverses ressemblant à ça:

![monolithe](images/monolithe.png)

**Responsabilités**

Au fur et à mesure qu'un monolithe grossit, des problèmes de reponsabilités vont se poser entre les différentes équipes travaillant sur des pans applicatifs communs.

**Dette technique**

Avec un monolithe, il deviendra difficile de prévoir l'impact d'une modification d'un bout de code sur l'ensemble du système. La qualité du code risque d'en pâtir et au final la qualité de l'application également.

**Veille technologique**

Enfin la possibilité d'essayer de nouvelles technologies sur un grosse application est très compliquée sans entamer une refonte totale et coûteuse du monolithe. Cela peut être une source de frustation grandissante pour les développeurs.

## Les microservices à la rescousse

Une architecture orientée micro-services vise à scinder les monolithes en briques applicatives plus petites. Ces applications peuvent alors être gérées par une seule équipe qui a la responsabilité technique et fonctionnelle totale sur celles-ci.

Dans une architecture microservices, on pourrait arriver à ça:

![microservices](images/microservices.png)

En adoptant ce découpage technique et fonctionnel, on peut en tirer plusieurs avantages:

**Dimensionnement**

Le dimensionnement des applications peut se faire plus facilement et plus efficacement. Seuls les services pouvant se comporter comme goulot d'étranglements pourront être sizés.

**Meilleure organisation**

Les équipes sont clairement définies et connaissent le scope sur lequel elles doivent intervenir. Elles maîtrisent l'impact de leurs développement et sont libres d'intervenir sans avoir besoin de se synchroniser avec d'autres équipes.

**Abstraction de la complexité**

En distribuant les responsabilités aux bonnes équipes, il devient facile d'abstraire la complexité d'une routine via l'exposition d'un service REST par exemple.

**Tests**

En découpant les fonctionnalités par micro service, il devient plus facile de réaliser des tests complets et de qualité.

### Des systèmes distribués

Avec des microservices, l'architecture sera de facto distribuée. Bien que localement le scope est limité et plus facile à appréhender, l'ensemble est devenu bien plus complexe.

## L'approche microservices avec Kubernetes

### Passage à Docker

La première étape pour bénéficier au maximum des avantages de la contenerisation est de convertir notre monolithe en quelque chose d'exploitable pour un orchestrateur Docker.

Le `Dockerfile` ci-dessous va nous permettre de réaliser cette transition sans modifier une seule ligne de code de notre monolithe.

```docker
# BUILD PHASE
FROM maven:3.5-jdk-8
WORKDIR /app
ADD .   /app/
RUN ["mvn", "package", "-Dmaven.test.skip=true"]

# RUN PHASE
FROM openjdk:8-jre-alpine
COPY --from=0 /app/my-app.jar ./my-app/
WORKDIR /my-app
CMD ["java", "-jar", "my-app.jar"]
```

Il suffira ensuite d'intégrer la construction d'une image basée sur ce fichier `Dockerfile` et de publier le résultat sur un registre pour la rendre accessible à tous.

### Le pattern sidecar

Notre application est compréhensible par Docker, c'est un premier point positif. Par contre il est rare qu'un monolithe déjà en production n'ait plus besoin d'évoluer.

L'adoption des microservices se fait le plus souvent en découpant un monolithe existant plutôt que sur un projet créé _from scratch_. Alors comment ajouter de nouvelles fonctionnalités sans modifier le code de l'application?

**Application**

Par exemple, on souhaite passer notre bonne vieille API en HTTPS. Naïvement on pourrait modifier notre monolithe pour y ajouter la gestion du SSL, les certificats, les headers de sécurité, ...

Une meilleure solution est d'utiliser un container dit `sidecar` qui va opérer comme un reverse proxy pour convertir des appels HTTPs en appels HTTP locaux pour notre application.

![sidecar](images/sidecar.png)

Sur la figure ci-dessus, nous n'avons plus un seul container à déployer mais **deux**.

Le premier serait un container démarrant un serveur nginx dans lequel on viendrait déclarer un `proxy path` pour router tous les appels HTTPs en `my.api.com` vers notre api locale en HTTP cette fois.

Le second est notre application préalablement "dockerisée" et restée inchangée.

**Résumé**

Le gros avantage du sidecar est qu'il est facilement réutilisable. Devoir mettre à jour l'ensemble des applications d'un SI est rapidement coûteux et difficile à tester. Appliquer ce genre de pattern permet de gagner en coût de développement et en consistence.

Le défaut, car il y en a un, de ce pattern est que désormais nous devons déployer deux containers au lieu d'un seul auparavant. Nous allons voir comment faire mieux avec Istio.

### Les service mesh avec Istio

Istio est une surcouche au dessus de Kubernetes permettant, dans un premier temps, de faciliter la transition de monolithe à microservices.

De plus Istio va proposer un ensemble de fonctionnalités très utiles pour simplifier l'usage de microservices en ce qui concerne le routage, la sécurité ou encore le suivi.

Comment Istio est capable d'ajouter toutes ces fonctionnalités à nos applications? C'est très simple, en utilisant à outrage le pattern sidecar!

![istio](images/istio.png)

Envoy est un proxy haute performance codé en C++ largement utilisé par Istio. Son but est de réguler le trafic entrant et sortant de tous les service faisant partie du service mesh (ou _réseau de services_ pour les chauvins ;) ).

Ainsi un sidecar Envoy sera déployé en même temps que nos services métier. Nos services ne communiquent qu'avec leur front proxy, les aspects de routage ou de sécurité sont entièrement délégués à Istio.

## Mise en place

### Installation de Kubernetes

Sur une machine de développement, Kubernetes peut facilement être installé en utilisant les clients Docker disponibles.

**Kubernetes**

Sur Mac et avec `Docker For Mac`, il est nécessaire de switcher en version edge et dans les préférences d'activer Kubernetes:

![kubernetes](images/kubernetes.png)

Kubernetes devrait s'installer au bout de quelques minutes et lancer un cluster utilisable pour y déployer nos stacks applicatives.

**Minkube**

La création d'un cluster Kubernetes requiert en temps normal de créer un compte sur un provider cloud (de préférence GCP). Pour réaliser des POC et expérimenter Kubernetes, nous pouvons utiliser `minikube` pour créer un cluster local.

Sur Mac, `minikube` peut s'installer avec Brew:

```bash
brew cask install minikube
```

Le démarrage se fait alors avec `minikube start` et l'arrêt avec (roulement de tambour...) `minikube stop`.

```bash
$ minikube start

> Starting local Kubernetes v1.10.0 cluster...
> Starting VM...
> Downloading Minikube ISO
>  150.53 MB / 150.53 MB [============================================] 100.00% 0s
> Getting VM IP address...
> Moving files into cluster...
> Downloading kubeadm v1.10.0
> Downloading kubelet v1.10.0
> Finished Downloading kubelet v1.10.0
> Finished Downloading kubeadm v1.10.0
> Setting up certs...
> Connecting to cluster...
> Setting up kubeconfig...
> Starting cluster components...
> Kubectl is now configured to use the cluster.
> Loading cached images from config file.
```

En utilisant le client Kubernetes `kubectl`, on peut visualiser l'état du cluster fraîchement démarré:

```bash
$ kubectl get nodes

> NAME       STATUS    ROLES     AGE       VERSION
> minikube   Ready     master    33s       v1.10.0
```

Le cluster créé  avec minikube ne comprend qu'un seul noeud master que l'on va exploiter pour déployer nos containers.

### Installation d'Istio

Dans un premier temps, il est nécessaire de télécharger la dernière version d'Istio:

```bash
curl -L https://git.io/getLatestIstio | sh -
```

Cette commande va télécharger un dossier nommé par exemple `istio-0.7.1`. Cette archive contient les binaires et fichiers de déclaration nécessaires pour manipuler Istio et le déployer au sein d'un cluster Kubernetes.

Pour bénéficier du client Istio, le `.bashrc` est à mettre à jour avec la ligne suivante:

```bash
export PATH="$HOME/istio-0.7.1/bin:$PATH"
```

Istio s'installer en déployant le fichier de déclaration `istio.yaml` présent dans le dossier `install/kubernetes`:

```bash
kubectl apply -f install/kubernetes/istio.yaml
```

**Activation de l'injection automatique du proxy**

La création des certificats se fait avec le script `webhook-create-signed-cert.sh`:

```bash
./install/kubernetes/webhook-create-signed-cert.sh --service istio-sidecar-injector --namespace istio-system --secret sidecar-injector-certs
```

La création du configmap pour le sidecar injector se fait de la façon suivante:

```bash
kubectl apply -f install/kubernetes/istio-sidecar-injector-configmap-release.yaml
```

On met à jour `cabundle` avec le fichier de déclaration du sidecar injector:

```bash
cat install/kubernetes/istio-sidecar-injector.yaml | ./install/kubernetes/webhook-patch-ca-bundle.sh > install/kubernetes/istio-sidecar-injector-with-ca-bundle.yaml
```

Finalement le sidecar injector peut être installé avec:

```bash
kubectl apply -f install/kubernetes/istio-sidecar-injector-with-ca-bundle.yam
```

**Valider la bonne installation**

```bash
$ kubectl get svc -n istio-system

> NAME                     TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)                                                             AGE
> istio-ingress            LoadBalancer   10.110.18.242    <pending>     80:31911/TCP,443:31362/TCP                                          35m
> istio-mixer              ClusterIP      10.106.245.108   <none>        9091/TCP,15004/TCP,9093/TCP,9094/TCP,9102/TCP,9125/UDP,42422/TCP    35m
> istio-pilot              ClusterIP      10.100.37.90     <none>        15003/TCP,15005/TCP,15007/TCP,15010/TCP,8080/TCP,9093/TCP,443/TCP   35m
> istio-sidecar-injector   ClusterIP      10.99.172.62     <none>        443/TCP                                                             26m
```

```bash
$ kubectl get pods -n istio-system

> NAME                                      READY     STATUS    RESTARTS   AGE
> istio-ca-75fb7dc8d5-2kvsj                 1/1       Running   0          36m
> istio-ingress-577d7b7fc7-8w65p            1/1       Running   0          36m
> istio-mixer-859796c6bf-5pw5m              3/3       Running   0          36m
> istio-pilot-65648c94fb-n69t9              2/2       Running   0          36m
> istio-sidecar-injector-844b9d4f86-hffkr   1/1       Running   0          27m
```

### L'HTTPs avec Istio

## Resources

 - [Designing Distributed Systems](http://shop.oreilly.com/product/0636920072768.do)
 - [L’architecture microservices sans la hype](https://blog.octo.com/larchitecture-microservices-sans-la-hype-quest-ce-que-cest-a-quoi-ca-sert-est-ce-quil-men-faut/)
 - [Docker, Kubernetes et Istio, c'est utile pour mon monolithe?](https://www.youtube.com/watch?v=YJScBvT0bxg)
 - [Kubernetes Comics](https://cloud.google.com/kubernetes-engine/kubernetes-comic/)
 - [Istio Ingress Tutorial](https://github.com/kelseyhightower/istio-ingress-tutorial)
