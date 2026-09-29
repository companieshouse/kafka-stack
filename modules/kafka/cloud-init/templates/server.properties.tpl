write_files:
  - path: ${kafka_home}/config/server.properties
    owner: ${kafka_service_user}:${kafka_service_group}
    permissions: 0644
    content: |
      advertised.listeners=PLAINTEXT://${hostname}:9092
      auto.create.topics.enable=false
      broker.rack=${rack_id}
      controller.listener.names=CONTROLLER
      controller.quorum.voters=${controller_quorum_voters}
      delete.topic.enable=true
      group.initial.rebalance.delay.ms=0
      listeners=PLAINTEXT://:9092,CONTROLLER://:${kafka_kraft_port}
      log.cleaner.enable=true
      log.dirs=${kafka_data_directory}
      log.retention.check.interval.ms=300000
      log.retention.hours=168
      log.segment.bytes=1073741824
      min.insync.replicas=${min_insync_replicas}
      node.id=${node_id}
      num.io.threads=8
      num.network.threads=3
      num.partitions=1
      num.recovery.threads.per.data.dir=1
      offsets.topic.replication.factor=${offsets_topic_replication_factor}
      process.roles=broker,controller
      share.coordinator.state.topic.min.isr=2
      share.coordinator.state.topic.num.partitions=3
      share.coordinator.state.topic.replication.factor=3
      socket.receive.buffer.bytes=102400
      socket.request.max.bytes=104857600
      socket.send.buffer.bytes=102400
      transaction.state.log.min.isr=2
      transaction.state.log.replication.factor=3
