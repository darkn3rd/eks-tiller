resource "kubernetes_deployment" "tiller_deploy" {
  metadata {
    name      = "tiller-deploy"
    namespace = "kube-system"

    labels = {
      app = "helm"
      name = "tiller"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "helm"
        name = "tiller"
      }
    }

    template {
      metadata {
        labels = {
          app = "helm"
          name = "tiller"
        }
      }

      spec {
        container {
          name  = "tiller"
          image = "gcr.io/kubernetes-helm/tiller:${var.tiller_version}"

          port {
            name           = "tiller"
            container_port = 44134
          }

          port {
            name           = "http"
            container_port = 44135
          }

          env {
            name  = "TILLER_NAMESPACE"
            value = "kube-system"
          }

          env {
            name  = "TILLER_HISTORY_MAX"
            value = "0"
          }

          liveness_probe {
            http_get {
              path = "/liveness"
              port = "44135"
            }

            initial_delay_seconds = 1
            timeout_seconds       = 1
          }

          readiness_probe {
            http_get {
              path = "/readiness"
              port = "44135"
            }

            initial_delay_seconds = 1
            timeout_seconds       = 1
          }

          image_pull_policy = "IfNotPresent"
        }

        service_account_name            = "tiller"
        automount_service_account_token = true
      }
    }
  }

  depends_on = [kubernetes_service_account.tiller]
}