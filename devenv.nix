{
  pkgs,
  lib,
  config,
  ...
}: {
  # Core tools for Kubernetes administration and homelab deployment
  packages = with pkgs; [
    git
    kubectl
    kubernetes-helm
    k9s
    fluxcd
    kustomize
  ];

  # Environment variables for the shell session
  env = {
    # KUBECONFIG = "./.kube/config"; # Uncomment to isolate local cluster state
  };

  # Local PostgreSQL instance for database schema testing (runs rootless, without Docker)
  services.postgres = {
    enable = true;
    initialDatabases = [
      {name = "homelab_dev";}
    ];
    port = 5432;
  };

  # Background tasks managed by process-compose
  processes = {
    # k8s-watch.exec = "kubectl get pods -A --watch"; # Uncomment to monitor pods in background
  };

  # Pre-commit hooks for declarative syntax validation
  git-hooks.hooks = {
    nixpkgs-fmt.enable = true;
    yamllint.enable = true;
  };

  # Welcome hook executed upon entering the shell
  enterShell = ''
    echo "============================================="
    echo "  Homelab K8s Development Shell Active       "
    echo "============================================="
    kubectl version --client --short 2>/dev/null || kubectl version --client
  '';
}
