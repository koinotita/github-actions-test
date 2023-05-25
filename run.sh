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