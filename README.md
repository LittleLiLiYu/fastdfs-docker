# FastDFS Dockerfile local (本地版本)

## 生成image
 Dockerfile 本地构建镜像, docker build [options] [imageName]:[TAG] [path]
```
cd path
docker build -t fastdfs:v1 .
```

## 目录介绍
### conf 
Dockerfile 所需要的一些配置文件
当然你也可以对这些文件进行一些修改  比如 storage.conf 里面的 bast_path 等相关

### source 
FastDFS 所需要的一些需要从网上下载的包(包括 FastDFS 本身) ,因为天朝网络原因 导致 build 镜像的时候各种出错
所以干脆提前下载下来了 . 


## 使用方法
需要注意的是 你需要在运行容器的时候制定宿主机的ip 用参数 FASTDFS_IPADDR 来指定
下面有一条docker run 的示例指令

```
docker run -d --net=host --name test-fast -e FASTDFS_IPADDR=192.168.35.142 镜像id/镜像名称
```


