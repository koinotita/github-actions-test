# github-actions-test

主要两种：
https://www.nickxu.top/2022/12/09/%E4%BD%BF%E7%94%A8GitHub-Actions%E5%AE%9E%E7%8E%B0%E7%AE%80%E5%8D%95%E7%9A%84%E8%87%AA%E5%8A%A8%E5%8C%96%E9%83%A8%E7%BD%B2/#%E7%BC%96%E5%86%99%E8%84%9A%E6%9C%AC

1. 不在虚拟机上编译，直接 ssh 连接服务器，执行命令或一个脚本文件来自动拉取最新代码，编译文件并完成替换
 - 使用 git pull 拉取最新代码
 - 运行一个自动编译与重新启动的脚本
2. 直接在 GitHub 的虚拟机上完成编译，得到二进制文件，然后把文件送到我们的服务器上（直接转送可能很慢，我看有的项目是先放到 OSS 上，然后用一个 webhook 通知守护进程，去拉取文件并完成替换）

常用的proxy
- http://proxy.golang.org：Go官方提供的module代理服务。
- http://mirrors.tencent.com/go：腾讯公司提供的module代理服务。
- http://mirrors.aliyun.com/goproxy：阿里云提供的module代理服务。
- http://goproxy.cn：开源module代理，由七牛云提供主机，是目前中国最为稳定的module代理服务。 支持一系列统计api,如服务摘要,模块趋势,下载次数等,文档
- http://goproxy.io：开源module代理，由中国Go社区提供的module代理服务。
- proxy.golang.com.cn:与http://goproxy.io同一主体提供的代理(大陆地区推荐使用)
- Athens：开源module代理，可基于该代理自行搭建module代理服务。

### 手动
```text
sudo git clone https://github.com/koinotita/github-actions-test.git
cd github-actions-test/

七牛的代理坏了，改为 export GOPROXY=https://proxy.golang.com.cn,direct

go mod tidy
go build main.go
./main

```

注册为service
https://chenhh.gitbooks.io/ubuntu-linux/content/service.html
```text 
sudo vim /etc/systemd/system/github-actions-test.service

[Unit]
Description=github-actions-test

[Service]
ExecStart=/home/ubuntu/github-actions-test/main
Restart=always


[Install]
WantedBy=multi-user.target

```

```text
sudo systemctl start github-actions-test
sudo systemctl status github-actions-test

command
systemctl start nginx
systemctl stop nginx
systemctl reload nginx
systemctl restart nginx
systemctl status nginx

开机启动
systemctl enable nginx

关闭开机自启动
systemctl enable nginx

检查自启动配置
systemctl is-enabled nginx

检查服务是否启动
systemctl is-active nginx

列出所有服务
systemctl list-units

```

### 第一种
目前已经将github-actions-test目录下的main注册为系统服务

直接在目标服务器上执行脚本命令，拉去代码构建，并重启服务
```text 
### github action.
name: BuildAndPushTo
on:
  push:
    branches:
      - main
jobs:
  build:
    name: Build
    runs-on: ubuntu-latest
    steps:
      - name: 直接在服务器执行命令
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.DEPLOY_HOST }}
          username: ${{ secrets.DEPLOY_USER }}
          password: ${{ secrets.DEPLOY_SECRET }}
          script: cd ~/github-actions-test && git pull && bash run.sh
          
### run.sh
#!/bin/sh

serviceName="github-actions-test"

# 停止服务
systemctl stop $serviceName
rm main -f

# 重新编译
#export PATH=$PATH:/usr/local/go/bin
go mod tidy
go build main.go

# 启动服务
systemctl start $serviceName
systemctl status $serviceName
```