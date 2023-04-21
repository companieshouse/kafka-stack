write_files:
  - path: /etc/alertmanager/alertmanager.yml
    owner: alertmanager:alertmanager
    permissions: 0644
    content: |
      global:
        resolve_timeout: 5m

      route:
        group_by: ['alertname']
        group_wait: 30s
        group_interval: 5m
        repeat_interval: 10m
        receiver: 'email'
      receivers:
      - name: 'email'
        email_configs:
        - to: '${email_to}'
          from: '${email_from}'
          smarthost: ${smarthost}:${smarthost_port}
          auth_username: ""
          auth_identity: ""
          auth_password: ""
          require_tls: false
          send_resolved: true
      inhibit_rules:
        - source_match:
            severity: 'critical'
          target_match:
            severity: 'warning'
          equal: ['alertname', 'dev', 'instance']
