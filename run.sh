#!/bin/sh

serviceName="github-actions-test"

# 停止服务
sudo systemctl stop $serviceName
rm main -f

# 重新编译
export GOPAHT=$HOME/go
export PATH=$PATH:$GOPAHT/bin

go mod tidy
go build main.go

# 启动服务
sudo systemctl start $serviceName
sudo systemctl status $serviceName