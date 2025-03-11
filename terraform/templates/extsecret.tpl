apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: ${extsecret_name}
  namespace: ${namespace}
spec:
  refreshInterval: ${refresh_interval}
  secretStoreRef:
    name: ${secret_store_name}
    kind: ${secret_store_kind}
  target:
    name: ${target_name}
    template:
      type: ${target_type}
  data:
    - secretKey: ${secret_key_crt}
      remoteRef:
        key: ${certificate_id}
        property: ${property_chain}
    - secretKey: ${secret_key_key}
      remoteRef:
        key: ${certificate_id}
        property: ${property_private}
