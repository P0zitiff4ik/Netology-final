apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${deployment_name}
  namespace: ${namespace}
spec:
  replicas: ${replicas}
  selector:
    matchLabels:
      app: ${app_label}
  template:
    metadata:
      labels:
        app: ${app_label}
    spec:
      containers:
        - name: ${container_name}
          image: cr.yandex/${registry_id}/${image_name}:${tag}
          ports:
            - containerPort: ${container_port}
          resources:
            limits:
              memory: "${limit_memory}"
              cpu: "${limit_cpu}"
            requests:
              memory: "${request_memory}"
              cpu: "${request_cpu}"
