# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

Deploy by kubernetes:

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

To scale a deployment to 3 Pods:

```
kubectl scale --replicas=3 deployment/web
```

Kubernetes dashboard:

```
kubectl port-forward kubernetes-dashboard-5569448c6d-tb7mj 8443:8443 -n kube-system
```

To check Kubernetes events:

```
kubectl get events
```

* ...
