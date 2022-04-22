# hazelcast-cloud-challange


## Start the minikube

`minikube start --driver=docker  --memory=8192 --cpus=4`

## Get the certificate information from minikube and add it to terraform.tfvars

`kubectl config view --minify --flatten --context=minikube`

  user.client-key-data is client_key
  user.client-certificate-data is client_certificate
  user.certificate-authority-data is cluster_ca_certificate


## unseal the vault

    $ kubectl exec vault-0 -n vault -- vault operator init -key-shares=1 -key-threshold=1 -format=json > cluster-keys.json
    VAULT_UNSEAL_KEY=$(cat cluster-keys.json | jq -r ".unseal_keys_b64[]")
    kubectl exec vault-0 -n vault -- vault operator unseal $VAULT_UNSEAL_KEY
    kubectl exec vault-1 -n vault -- vault operator unseal $VAULT_UNSEAL_KEY
    kubectl exec vault-2 -n vault -- vault operator unseal $VAULT_UNSEAL_KEY

## reach the prometheus endpoint

    kubectl get pods -n ingress-nginx
    NAME                             READY   STATUS    RESTARTS   AGE
    ingress-nginx-controller-g5h92   1/1     Running   0          2m52s
    kubectl port-forward ingress-nginx-controller-g5h92 -n ingress-nginx
    8080:80

    open your browser and enter http://localhost:8080

    The username and password is defined at MONITORING_BASIC_AUTH variable (admin/test)
