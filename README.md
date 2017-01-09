# FastPod

使用 FastPod 可以帮助你快速地完成 CocoaPods ```pod update``` 操作，无论你处于『墙外』或是『墙内』。

## 使用方法
1. 下载 [fastpod](https://github.com/PonyCui/FastPod/raw/master/bin/fastpod) 文件，复制到 /usr/local/bin 目录下。
2. cd 到需要执行 ```pod update``` 的目录下，执行 ```fastpod``` 命令即可。
3. 如果需要使用国内镜像，则执行 ```fastpod --use-mirror``` 命令。

## 原理
1. 通过分析 Podfile 文件，在服务器直接计算需要使用的 podspec.json 并返回至 Cli 程序。
2. 程序会自动将 podspec.json 替换至 ~/.cocoapods/repos/master 目录下。
3. 将 podspec.json 中的 source 替换为 GitHub ZIP 或者 墙内 ZIP。
4. 程序自动执行 ```pod update --no-repo-update``` 以完成 ```pod update``` 等效操作。

## 风险
* 将 podspec.json 内容替换存在代码被注入风险，这些风险来自于 FastPod 服务器被攻破或是 HTTP 中间人注入。
* FastPod 只作研究使用，不承担这些风险。
* 你可以自行下载 [Server](https://github.com/PonyCui/FastPod-Server) 端的代码进行本地部署，Fork FastPod 客户端代码，修改其中的 apiBase 地址，重新 Build 后使用，以保障安全。
