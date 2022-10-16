# K3S Cluster
 //TODO
## Install k3s cluster without default LB and without traefik
//TODO - for now check first reference

## Install Helm
//TODO - for now check second reference

## Install MetalLB
error metalLB need check config
 ```
 helm repo add metallb https://metallb.github.io/metallb
 helm install metallb metallb/metallb --namespace metallb-system --create-namespace
 kubectl apply -f MetalLB/values.yaml 
 ```
## Install nginx ingress controller
```
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace
```

## Cert-Manager
(maybe do a doc for setup DNS at cloudflare before this step)

```
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.9.1 \
  --set installCRDs=true
```
<configurar issuer>

# LocalPath provisioner

```
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.22/deploy/local-path-storage.yaml
```

# References
- https://greg.jeanmart.me/2020/04/13/install-and-configure-a-kubernetes-cluster-w/
- https://helm.sh/docs/intro/using_helm/
- https://metallb.universe.tf/usage/
- https://cert-manager.io/docs/installation/helm/
- https://github.com/rancher/local-path-provisioner
- https://github.com/Renegade-Master/zomboid-dedicated-server