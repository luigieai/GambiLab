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
  --namespace ingress-nginx --create-namespace \
  --set "controller.extraArgs.enable-ssl-passthrough="
```

## Cert-Manager

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
## External and Internal Domain
My goal for the homelab is to have external and internal domain with SSL, that means the external domain can receive requests from internet, and internal domain can only be accessible from LAN or VPN trusted user. If you don't want to expose externally any service, just skip external domain.
### External Domain
For cert configuration, I follow [cloudflare tutorial,](https://cert-manager.io/docs/configuration/acme/dns01/cloudflare/), but you should follow your domain provider tutorial for best result.
It's prefereed that you issue via DNS01 challenge, so you can make wildcard certificate. Following steps for cloudlfare:

- go to ./cert-manager/external/ folder
- Copy secrets.example as yaml file (ex: secrets.yaml) and replace yourCloudflareToken to your token. 
- Replace your@email at issuer-cluster.yaml

You can test creating a ingress for a test service:
```
helm repo add ealenn https://ealenn.github.io/charts
helm repo update
helm upgrade -i echo ealenn/echo-server --namespace echo --force

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-echo
  namespace: echo
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: "letsencrypt-prd"
    cert-manager.io/private-key-rotation-policy: "Always"
    cert-manager.io/duration: "2160h" #90d
    cert-manager.io/renew-before: "720h" #30d before SSL will expire, renew it
spec:
  tls:
  - hosts:
    - home.marioverde.com
    secretName: marioverde-tls
  rules:
    - host: home.marioverde.com.br
      http:
        paths:
        - path: /
          pathType: Prefix
          backend:
            service:
              name: echo-echo-server
              port:
                number: 80
```
### Internal domain
https://cert-manager.io/docs/configuration/selfsigned/

## LocalPath provisioner

```
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.22/deploy/local-path-storage.yaml
```
## Longhorn provisioner
```
kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/v1.3.2/deploy/longhorn.yaml --namespace longhorn-system

```
## ArgoCS
```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
Apply ingress in ./argocd/ingress.yaml
Get initial admin password and delete after:
```
 kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
 After annotating the output:
 kubectl -n argocd delete secret argocd-initial-admin-secret
```

# References
- https://greg.jeanmart.me/2020/04/13/install-and-configure-a-kubernetes-cluster-w/
- https://helm.sh/docs/intro/using_helm/
- https://metallb.universe.tf/usage/
- https://cert-manager.io/docs/installation/helm/
- https://medium.com/devops-techable/install-cert-manager-to-setup-ssl-with-lets-encrypt-and-cloudflare-dns-with-automatic-renewal-81477bb08423
- https://github.com/rancher/local-path-provisioner
