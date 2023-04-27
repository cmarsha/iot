# command for checking ports:
# sudo netstat -tulpn

sudo apt-get update &&
sudo apt-get -y upgrade &&

# НУЖНО локально ставить аргоцд??? https://yashguptaa.medium.com/application-deploy-to-kubernetes-with-argo-cd-and-k3d-8e29cf4f83ee

# Install ArgoCD locally on Debian DOESN'T WORK!!!! or maybe need to try once more ( https://argo-cd.readthedocs.io/en/stable/cli_installation/ )
# curl -sSL -o argocd-darwin-amd64 https://github.com/argoproj/argo-cd/releases/download/$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')/argocd-darwin-amd64
# sudo install -m 555 argocd-darwin-amd64 /usr/local/bin/argocd
# rm argocd-darwin-amd64
# OTHER INSTRUCTION: https://argo-cd.readthedocs.io/en/stable/cli_installation/ ) ВРОДЕ РАБОТАЕТ
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64


# Download latest stable version of kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" &&

# Download sha256 hash sum for just installed kubectl and check it
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256" &&
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check &&

# Install kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl &&

# Add autocompletion
echo "source <(k3d completion bash)" >> ~/.bashrc
source ~/.bashrc


# Install docker
curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh ./get-docker.sh &&

curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash



# Install cluster
# https://www.sokube.io/en/blog/gitops-on-a-laptop-with-k3d-and-argocd-en

sudo k3d cluster create iot && #name???
sudo kubectl create namespace argocd &&
sudo kubectl create namespace dev &&

# Install ArgoCD into argocd NAMESPACE
# https://yashguptaa.medium.com/application-deploy-to-kubernetes-with-argo-cd-and-k3d-8e29cf4f83ee

sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
sleep 10 #??? for pods gets up
# OR
# sudo kubectl wait --for=condition=Ready pods --all -n argocd

# check nodes on argocd namespace
# kubectl get pods -n argocd

# Получить пароль в декодированном виде:
# sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath={.data.password} | base64 -d ; echo