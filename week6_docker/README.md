```mermaid
graph LR
U[User (Browser)]
H((Host))
U -->|HTTP :5002| H
U -->|HTTP :8080| H

subgraph H[Host]
  subgraph NET[Docker network: app_net]
    A[app (Flask)\n:5000\nHealthcheck /health]
    D[db (nginx)\n:80]
    A -->|HTTP :80| D
  end
  V[(named volume\n/usr/share/nginx/html)]
  D --- V
end
```

