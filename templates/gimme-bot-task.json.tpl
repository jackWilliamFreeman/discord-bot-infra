[
    {
      "name": "${name}",
      "image": "${ecr_repo}",
      "essential": true,
      "memory": 200,
      "cpu": 0,
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
                "name": "BOT_TOKEN",
                "valueFrom": "${token}"
            }
        ]
    }
]