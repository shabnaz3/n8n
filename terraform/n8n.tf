# resource "kubernetes_namespace" "n8n" {
#   metadata {
#     name = "n8n-temp"
#   }
# }


resource "helm_release" "n8n" {

  name       = "my-n8n"
  namespace  = "n8n-temp" 
  repository =  "https://community-charts.github.io/helm-charts" 
  chart      = "n8n"
  
# for  more complex settings, 
  # values = [ file("${path.module}/n8n-values.yaml") ]


  # set {
  #   name= "db.type"
  #   value = "sqlite"
  # }
  set {
    name  = "service.type"
    value = "ClusterIP"
  }

  # Example: enable PostgreSQL inside the chart (if you want internal DB)
  set {
    name  = "db.type"
    value = "postgresdb"
  }
  set {
    name  = "postgresql.enabled"
    value = "true"
  }
  
  # PostgreSQL (nested under postgresql)
  set {
    name  = "postgresql.enabled"
    value = "true"
  }

  set {
    name  = "postgresql.database"
    value = "n8ndb"
  }

  set {
    name  = "postgresql.username"
    value = "n8nuser"
  }

  set {
    name  = "postgresql.password"
    value = "n8npassword"
  }

  # auth

depends_on = [
    # any dependencies, e.g., namespace creation
  ]
}

resource "kubernetes_deployment" "n8n" {
  metadata {
    name      = "n8n-temp"
    namespace = "n8n-temp"
    labels = {
      app = "n8n-temp"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "n8n-temp"
      }
    }

    template {
      metadata {
        labels = {
          app = "n8n-temp"
        }
      }

      spec {
        container {
          name  = "n8n"
          image = "n8nio/n8n:latest"

          port {
            container_port = 5678
          }

          env {
            name  = "DB_TYPE"
            value = "postgres"
          }

          env {
            name  = "DB_POSTGRESDB_HOST"
            value = "postgres"
          }

          env {
            name  = "DB_POSTGRESDB_PORT"
            value = "5432"
          }

          env {
            name  = "DB_POSTGRESDB_DATABASE"
            value = "n8n"
          }

          env {
            name  = "DB_POSTGRESDB_USER"
            value = "n8n"
          }

          env {
            name  = "DB_POSTGRESDB_PASSWORD"
            value = "n8npass"
          }

          env {
            name  = "GENERIC_TIMEZONE"
            value = "Asia/Singapore"
          }

          env {
            name  = "N8N_HOST"
            value = "ldap-dev01.in.pi-lar.net"
          }

          env {
            name  = "N8N_PORT"
            value = "5678"
          }

          env {
            name  = "WEBHOOK_TUNNEL_URL"
            value = "http://<node-ip>:30081"
          }

          env {
            name  = "N8N_SECURE_COOKIE"
            value = "false"
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "n8n_service" {
  metadata {
    name      = "n8n-service-temp"
    namespace = "n8n-temp"
  }

  spec {
    selector = {
      app = "n8n-temp"
    }

    port {
      port        = 80
      target_port = 5678
      node_port   = 30081
    }

    type = "NodePort"
  }
}


