write_files:

  - path: /etc/prometheus/prometheus.yml
    owner: prometheus:prometheus
    permissions: 0644
    content: |
      global:
        scrape_interval:     30s
        evaluation_interval: 30s

      alerting:
        alertmanagers:
        - path_prefix: "/alertmanager/"
          static_configs:
          - targets:
            - 'localhost:9093'

      rule_files:
        - "/etc/prometheus/prometheus_rules.yml"

      scrape_configs:
        - job_name: 'prometheus'
          static_configs:
          - targets: ['localhost:9090','localhost:9100']

        - job_name: broker-kafka-metrics
          scrape_interval: 60s
          scrape_timeout: 30s
          metrics_path: /metrics
          scheme: http
          ec2_sd_configs:
            - region: ${region}
              port: ${prometheus_kafka_metrics_port}
              filters:
                - name: tag:Environment
                  values: [${environment}]
                - name: tag:Service
                  values: [kafka3]
                - name: tag:ServiceSubType
                  values: [kafka]
          relabel_configs:
            - source_labels: [__meta_ec2_tag_HostName]
              target_label: hostname
            - source_labels: [__meta_ec2_tag_Name]
              target_label: name
            - source_labels: [__meta_ec2_private_ip]
              target_label: private_ip

        - job_name: broker-node-metrics
          scrape_interval: 60s
          scrape_timeout: 30s
          metrics_path: /metrics
          scheme: http
          ec2_sd_configs:
            - region: ${region}
              port: ${prometheus_metrics_port}
              filters:
                - name: tag:Environment
                  values: [${environment}]
                - name: tag:Service
                  values: [kafka3]
                - name: tag:ServiceSubType
                  values: [kafka]
          relabel_configs:
            - source_labels: [__meta_ec2_tag_HostName]
              target_label: hostname
            - source_labels: [__meta_ec2_tag_Name]
              target_label: name
            - source_labels: [__meta_ec2_private_ip]
              target_label: private_ip

        - job_name: zookeeper-node-metrics
          scrape_interval: 60s
          scrape_timeout: 30s
          metrics_path: /metrics
          scheme: http
          ec2_sd_configs:
            - region: ${region}
              port: ${prometheus_metrics_port}
              filters:
                - name: tag:Environment
                  values: [${environment}]
                - name: tag:Service
                  values: [kafka3]
                - name: tag:ServiceSubType
                  values: [zookeeper]
          relabel_configs:
            - source_labels: [__meta_ec2_tag_HostName]
              target_label: hostname
            - source_labels: [__meta_ec2_tag_Name]
              target_label: name
            - source_labels: [__meta_ec2_private_ip]
              target_label: private_ip
