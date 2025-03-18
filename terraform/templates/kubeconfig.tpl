apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: "${ca_cert}"
    server: "${endpoint}"
  name: yandex
contexts:
- context:
    cluster: yandex
    user: yandex-cloud
  name: default
current-context: default
kind: Config
preferences: {}
users:
- name: yandex-cloud
  user:
    token: "${k8s_token}"
