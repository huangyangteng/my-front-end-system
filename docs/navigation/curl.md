# CURL的简单使用

> 参考文档：[阮一峰-curl命令的使用](https://www.ruanyifeng.com/blog/2019/09/curl-reference.html)
>
> http://www.ruanyifeng.com/blog/2011/09/curl.html

curl,全称client url,是一个命令行工具，用于构建网络请求，获取并处理数据。



## 查看响应

```shell
# 查看网页源代码
curl www.baidu.com
# 查看响应头和网页源代码
curl -i www.baidu.com
# 只查看响应头
curl -I www.baidu.com

```

## 查看通信过程

```shell
# 显示通信过程 -v
curl -v www.baidu.com
# 显示更详细的通信过程 输出在output.txt中
curl --trace output.txt  www.baidu.com   # 二进制格式
curl --trace-ascii output.txt www.baidu.com  #ascii编码格式
```

## 构建Http请求

http请求包括：

* 请求行
    * HTTP动词(方法) GET POST PUT DELETE
* 请求头
* 请求体
    * Content-Type 指定发送数据的类型



### 指定HTTP动词

```shell
# -X指定HTTP方法(动词),默认是GET
curl -X POST www.baidu.com
curl -X DELETE www.baidu.com

```



### 发送不同数据类型的数据

* `Content-Type : application/x-www-form-urlencoded`

```shell
# -d 发送Content-Type为`application/x-www-form-urlencoded`的数据
curl -X POST -d 'userPhoneNumber=15064761673'   example.com/user
# -d会自动将请求转化为POST，所以-X POST可以省略
curl -d 'userPhoneNumber=15064761673'   example.com/user
# 可以读取本地文本文件的数据，向服务器发送
curl -d '@data.txt' example.com/user
```

* `Content-Type: multipart/form-data`

```shell
# -F参数用来向服务器上传二进制文件
```

## 下载文件

* -o 将服务器的回应保存为文件，等同于wget命令

```shell
# 格式：
curl -o 文件名 www.baidu.com
# 示例
curl -o sina.html www.baidu.com
# 可以和其他参数组合使用，例如只下载响应头
curl -o sina_res_header.txt -I www.baidu.com
```

* -O 将服务器的回应保存为文件，并将URL的最后部分当做文件名

```shell
curl -O https://www.baidu.com/img/dong_66cae51456b9983a890610875e89183c.gif
```

