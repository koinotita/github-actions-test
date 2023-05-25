


将程序注册为服务
```text
cd /etc/systemd/system/
nano github-actions-test.service

```

然后写入以下代码
```text
[Unit]
Description=github-actions-test

[Service]
ExecStart=/root/github-actions-test/main
Restart=always

[Install]
WantedBy=multi-user.target
```
使用命令行查看
```text
systemctl start github-actions-test
systemctl status github-actions-tes

```