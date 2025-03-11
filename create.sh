#!/bin/bash
export REGISTRY_ID=$(yc container registry get --name diploma-container-registry --folder-name netology-1 --format json | jq .id -r)
export CLUSTER_ID=$(yc managed-kubernetes cluster get --name diploma-cluster --folder-name netology-1 --format json | jq .id -r)
# Получение кредов для кластера
yc managed-kubernetes cluster get-credentials $CLUSTER_ID --external --force
# Создание образа и пуш в реестр
docker build container/ -t cr.yandex/$REGISTRY_ID/my-test-app:latest
docker push cr.yandex/$REGISTRY_ID/my-test-app:latest
# Установка репозиториев helm
helm repo add external-secrets https://charts.external-secrets.io
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
# Установка prometheus-operator
git clone https://github.com/prometheus-operator/kube-prometheus.git k8s/kube-prometheus
kubectl apply --server-side -f k8s/kube-prometheus/manifests/setup
kubectl wait \
    --for condition=Established \
    --all CustomResourceDefinition \
    --namespace=monitoring
kubectl apply -f k8s/kube-prometheus/manifests/
# Установка external-secrets, создание секрета и установка ingress-nginx
helm install external-secrets external-secrets/external-secrets --namespace external-secrets --create-namespace
kubectl create namespace ns
kubectl --namespace ns create secret generic yc-auth --from-file=authorized-key=.authorized_key.json
helm install ingress-nginx ingress-nginx/ingress-nginx --set controller.extraArgs.default-ssl-certificate="ns/k8s-secret"
sleep 15
# Применение манифестов приложения и Ingress. Из-за необходимости подставить ID реестра в манифесты, используется sed
kubectl apply -f k8s/
