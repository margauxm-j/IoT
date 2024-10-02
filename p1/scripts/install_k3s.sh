# Installation de K3s sur le contrôleur ou en tant qu'agent
if [ "$1" == "server" ]; then
    # Installer K3s en tant que serveur
    sudo curl -sfL https://get.k3s.io | sudo sh -

    # Modifier les permissions pour /etc/rancher/k3s/k3s.yaml
    sudo chmod 644 /etc/rancher/k3s/k3s.yaml  # Modifier les permissions du fichier
    sudo chown vagrant:vagrant /etc/rancher/k3s/k3s.yaml  # Changer le propriétaire du fichier

    # Exporter la configuration kubeconfig
    export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

    # Redémarrer K3s pour s'assurer qu'il est bien configuré
    sudo systemctl restart k3s

    # Vérifier l'état de K3s
    sudo systemctl status k3s

    # Récupérer le token et l'écrire dans un fichier partagé entre les VM
    sudo cat /var/lib/rancher/k3s/server/node-token > /vagrant/k3s_token

    # Vérifier les nœuds Kubernetes (optionnel pour tester si tout fonctionne)
    kubectl get nodes

elif [ "$1" == "agent" ]; then
    # Installer K3s en tant qu'agent
    K3S_TOKEN=$(cat /vagrant/k3s_token) # Récupérer le token depuis le fichier partagé
    sudo curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 K3S_TOKEN=$K3S_TOKEN sudo sh -

    # Modifier les permissions pour /etc/rancher/k3s/k3s.yaml après l'installation
    sudo chmod 644 /etc/rancher/k3s/k3s.yaml  # Modifier les permissions du fichier
    sudo chown vagrant:vagrant /etc/rancher/k3s/k3s.yaml  # Changer le propriétaire du fichier

    # Exporter la configuration kubeconfig
    export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
fi
