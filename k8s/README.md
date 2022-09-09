# K3S Cluster
 //TODO
## Install k3s cluster without default LB and without traefik
//TODO - for now check first reference

## Install Helm
//TODO - for now check second reference

## Install MetalLB
error metalLB need check config
 ```
 kubectl create ns metallb-system
 helm repo add metallb https://metallb.github.io/metallb
 helm install metallb metallb/metallb --namespace metallb-system
 kubectl apply -f MetalLB/values.yaml 
 ```
## Install nginx ingress controller
```
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace
```
# References
- https://greg.jeanmart.me/2020/04/13/install-and-configure-a-kubernetes-cluster-w/
- https://helm.sh/docs/intro/using_helm/
- https://metallb.universe.tf/usage/
