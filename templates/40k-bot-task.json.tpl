[
    {
      "name": "${name}",
      "image": "${ecr_repo}",
      "essential": true,
      "memory": 512,
      "cpu": 256,
      "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "${name}",
            "awslogs-region": "ap-southeast-2",
            "awslogs-stream-prefix": "ecs",
            "awslogs-create-group": "true"
          }
        },
      "secrets": [
            {
                "name": "CHANNEL_ID",
                "valueFrom": "${channel_id}"
            },
            {
                "name": "TOKEN",
                "valueFrom": "${token}"
            }
        ]
    }
]