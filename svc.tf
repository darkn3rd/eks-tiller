resource "kubernetes_service" "tiller_deploy" {
  metadata {
    name      = "tiller-deploy"
    namespace = "kube-system"

    labels = {
      app = "helm"
      name = "tiller"
    }
  }

  spec {
    port {
      name        = "tiller"
      port        = 44134
      target_port = "tiller"
    }

    selector = {
      app = "helm"
      name = "tiller"
    }

    type = "ClusterIP"
  }
}