## Ruby version
ruby 2.5.0p0 (2017-12-25 revision 61468)* System dependencies

Install ruby 2.5.0 in Ubuntu 22.04 openssl issue: https://github.com/rbenv/ruby-build/discussions/1940

## How to run the test suite

* For run all model and controller tests

```
rake test
``` 

* For run tests in a file

```
rake test <file>
```

* For run system tests

```
rails test:system
```

## Deployment for dev

* clone project

```
git clone git@github.com:phylotastic/phylotastic-portal.git
```

```
cd phylotastic-portal
```

* install Gem

```
bundle install
```

* create `config/initializers/devise.rb`

* create `config/database.yml` (see `config/database.yml.sample`)

* create `config/secrets.yml` (see `config/secrets.yml.sample`)

* create database

```
rake db:create
```

```
rake db:migrate
```

* initialize database

```
rake import:countries
```

* start server

```
rails s -b 0.0.0.0
```

## Deployment by docker and kubernetes instructions

* Deploy by kubernetes:

```
docker stack deploy --namespace portal --compose-file docker-compose.yml portal
```

```
$ kubectl get services
NAME         TYPE           CLUSTER-IP    EXTERNAL-IP   PORT(S)          AGE
db           ClusterIP      None          <none>        55555/TCP        21m
kubernetes   ClusterIP      10.96.0.1     <none>        443/TCP          35m
redis        ClusterIP      None          <none>        55555/TCP        21m
web          LoadBalancer   10.98.83.41   <pending>     3000:31016/TCP   21m

$ kubectl get deployments
NAME      DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
redis     1         1         1            1           22m
web       1         1         1            1           22m
```

* To scale a deployment to 3 Pods:

```
kubectl scale --replicas=3 deployment/web
```

Kubernetes dashboard:

```
kubectl port-forward kubernetes-dashboard-5569448c6d-tb7mj 8443:8443 -n kube-system
```

* To check Kubernetes events:

```
kubectl get events
```

* ...
