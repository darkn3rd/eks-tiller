resource "kubernetes_cluster_role_binding" "tiller_admin_binding" {
  metadata {
    name = "tiller-admin-binding"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "tiller"
    namespace = "kube-system"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  depends_on = [kubernetes_service_account.tiller]
}