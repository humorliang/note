 ### 安装gitlab
 1. 参考官方的安装教程
 ```
https://about.gitlab.com/install/#ubuntu
 ```
 2. 安装docker版本
 ```bash
#  1. 设置环境变量
vim .bashrc
export GITLAB_HOME="/opt/gitlab"
source .bashrc

# 2. 运行容器 （22 端口可能会冲突 云服务器）
sudo docker run --detach --hostname gitlab.example.com --publish 443:443 --publish 80:80 --publish 2222:22  --name gitlab --restart always --volume $GITLAB_HOME/config:/etc/gitlab --volume $GITLAB_HOME/logs:/var/log/gitlab --volume $GITLAB_HOME/data:/var/opt/gitlab gitlab/gitlab-ee:latest


# 修改gitlab配置防止冲突
47.101.59.75
external_url '47.101.59.75' # 改成你的域名或者 IP，如果你的端口映射不是 80，那也不能在这里加端口
gitlab_rails['gitlab_shell_ssh_port'] = 2222 # 防止和本机 22 端口冲突
 ```