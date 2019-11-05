sudo hostnamectl set-hostname $(curl -s 'http://169.254.169.254/latest/meta-data/local-hostname' 2>/dev/null)
echo '======= Installing MicroK8S ======'
sudo apt-get update
sudo snap install microk8s --classic --channel=1.15/stable
sudo ufw allow in on cni0 && sudo ufw allow out on cni0
sudo ufw default allow routed
sudo microk8s.enable helm 
sudo microk8s.enable dns 
sudo microk8s.enable storage
#sudo snap install helm --classic
sudo microk8s.helm init
echo '======= Completed MicroK8S Installation ======' && sleep 30
echo '======= Configure Jenkins Build Server ======'
sudo usermod -a -G microk8s ubuntu
sudo microk8s.helm upgrade --install future-airlines-jenkins stable/jenkins -f /tmp/scripts/jenkins.yaml