# github-actions-test

主要两种：
1. 不在虚拟机上编译，直接 ssh 连接服务器，执行命令或一个脚本文件来自动拉取最新代码，编译文件并完成替换
 - 使用 git pull 拉取最新代码
 - 运行一个自动编译与重新启动的脚本
2. 直接在 GitHub 的虚拟机上完成编译，得到二进制文件，然后把文件送到我们的服务器上（直接转送可能很慢，我看有的项目是先放到 OSS 上，然后用一个 webhook 通知守护进程，去拉取文件并完成替换）


```text
sudo git clone https://github.com/koinotita/github-actions-test.git
cd github-actions-test/

```