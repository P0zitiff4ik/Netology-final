apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ${ingress_name}
  namespace: ${namespace}
spec:
  tls:
    - hosts:
        - ${tls_host}
        - "*.${tls_host}"
      secretName: ${secret_name}
  ingressClassName: ${ingress_class}
  rules:
    - host: ${rule_host}
      http:
        paths:
          - path: ${path}
            pathType: Prefix
            backend:
              service:
                name: ${service_name}
                port:
                  number: ${service_port}
