### linux安装mysql
#### 配置好apt
 a. Go to the download page for the MySQL APT repository at https://dev.mysql.com/downloads/repo/apt/. 
 b .  Select and download the release package for your Linux distribution. 
 c. 
 ```bash
sudo dpkg -i /PATH/version-specific-package-name.deb
eg: sudo dpkg -i mysql-apt-config_w.x.y-z_all.deb
 ```
 d. During the installation of the package, you will be asked to choose the versions of the MySQL server and other components (for example, the MySQL Workbench) that you want to install. If you are not sure which version to choose, do not change the default options selected for you. You can also choose `none` if you do not want a particular component to be installed. After making the choices for all components, choose `Ok` to finish the configuration and installation of the release package.

e. Update package information from the MySQL APT repository with the following command (this step is mandatory):
```bash
sudo apt-get update
```
#### Installing MySQL with APT
```bash
sudo apt-get install mysql-server
```
#### Starting and Stopping the MySQL Server
```bash
sudo service mysql status

sudo service mysql stop

sudo service mysql start
```

docker 安装mysql
```bash
//挂载mysql得配置  设置端口导出  设置管理员密码 以及 mysql 版本
docker run --name some-mysql -v /my/custom:/etc/mysql/conf.d -p 33306:3306 -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag
```