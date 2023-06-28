write_files:
  - path: /etc/systemd/system/alertmanager.service
    owner: root:root
    permissions: 0644
    content: |
      [Unit]
      Description=Alert Manager
      Wants=network-online.target
      After=network-online.target

      [Service]
      Type=simple
      User=alertmanager
      Group=alertmanager
      ExecStart=/opt/prometheus/alertmanager/alertmanager \
        --config.file=/etc/alertmanager/alertmanager.yml \
        --storage.path=/var/opt/alertmanager/data \
        --web.external-url=https://${service}-${environment}-prometheus.${load_balancer_dns_zone_name}/alertmanager \
        --web.route-prefix=/alertmanager

      Restart=always

      [Install]
      WantedBy=multi-user.target