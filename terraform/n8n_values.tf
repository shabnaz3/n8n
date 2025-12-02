resource "helm_release" "n8n-1" {

  name       = "my-n8n-1"
  namespace  = "n8n-tem2" 
  repository = "https://community-charts.github.io/helm-charts" 
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

  set{
    name = "postgresql.enabled"
    value = "true"
  }
  set {
    name = "postgresql.auth.username"
    value ="n8n"
  }
   
  set{
    name = "postgresql.auth.password"
    value = "n8npass"
  }

  set {
    name = "postgresql.auth.database"
    value = "n8n"
  }

  set{
    name = "ingress.enabled"
    value = "true"
  }

  set {
    name  = "ingress.className"
    value = "nginx" 
  }


  set {
    name = "ingress.hosts[0].host"
    value = "ldap-dev01.in.pi-lar.net"
  }
   
  set {
    name = "ingress.hosts[0].paths[0].path" 
    value = "/"
  }

  set {
    name = "ingress.hosts[0].paths[0].pathType" 
    value = "Prefix"
  }

  set {
    name= "image.repository"
    value = "n8nio/n8n"
  }
  set{  
   name = "image.tag"
   value = "latest"  # Specify version or leave empty for appVersion
  }
  set{
    name = "image.pullPolicy"
    value = "Always"
  }

  
  set{
    name = "webhook.url"
    value = "http://ldap-dev01.in.pi-lar.net/"
  }
  
  set{
    name = "readinessProbe.httpGet.path"
    value = "/healthz/readiness"
  }

  set{
    name = "readinessProbe.httpGet.port"
    value = "http"
  }
  
  set{
    name = "readinessProbe.initialDelaySeconds"
    value = "5"
  }

  set{
    name = "readinessProbe.periodSeconds"
    value = "5"
  }

  set{
    name = "readinessProbe.timeoutSeconds"
    value = "3"
  }

  set{
    name = "readinessProbe.failureThreshold"
    value = "3"
  }
  #Liveness probe


  set{
    name = "livenessProbe.httpGet.path"
    value = "/healthz"
  }
  
  set{
    name = "livenessProbe.httpGet.port"
    value = "http"
  }
  
  set{
    name = "livenessProbe.initialDelaySeconds"
    value = "30"
  }
  set{
    name = "livenessProbe.periodSeconds"
    value = "10"
  }
  set{
   name = "livenessProbe.timeoutSeconds"
   value = "5"
  }
  set{
    name = "livenessProbe.failureThreshold"
    value = "3"
  }
  #presistance

 
  




  # auth

depends_on = [
    # any dependencies, e.g., namespace creation
  ]
}
