# 导航流程

从输入URL到页面开始解析的整个过程，称为导航，整个流程如下图所示



![image-20200722202530478](https://tva1.sinaimg.cn/large/007S8ZIlgy1gh00s9xdw1j319e0ngwsx.jpg)





## 1. 用户输入

导航流程的第一步是用户输入，用户输入之后，浏览器会判断用户的输入类型

* 如果是搜索内容，浏览器会使用默认的搜索引擎，拼成完整的URL
* 如果符合URL规则，例如baidu.com，会在前面加上协议等信息拼成完整的URLhttps://www.baidu.com/

当用户按下回车之后，就进入URL请求阶段

## 2.URL请求阶段

浏览器进程会把URL发给网络进程，在网络进程进行真正的URL请求。

网络进程首先会判断有没有本地缓存存在，

* 有，直接返回

* 没有，开始网络请求

网络请求过程

* 通过DNS协议得到IP
* 如果是HTTPS协议，需要还建立TLS连接
* 通过IP和目标服务器建立TCP连接
* 构建请求行和请求头，并将Cookie等数据附加到请求头中，然后向服务器发起请求

服务器收到请求之后响应数据,数据包括：响应行、响应头和响应体,网络进程收到响应数据后，

首先会判断响应行中的状态码

如果是状态码是301或者302，需要进行重定向，拿到响应头中的Location字段的值，重定向到该地址

```shell
# 在终端中输入curl命令
curl -I http://time.geekbang.org/
# 输出如下 状态码为301,会拿到Location字段中的值，进行重定向
HTTP/1.1 301 Moved Permanently
Server: Tengine
Date: Thu, 23 Jul 2020 01:02:38 GMT
Content-Type: text/html
Content-Length: 239
Connection: keep-alive
Location: https://time.geekbang.org/
```

如果状态码是200，表示一切正常，可以继续接下来的流程。



接下来会根据响应头中的`Content-Type`字段处理响应体的数据。

`Content-Type`告诉浏览器服务器返回了什么数据类型的数据

* 如果`Content-Type`为`application/octet-stream`，即字节流类型，浏览器会按照下载类型来处理，处理方式是交给下载管理器处理，下载管理器会进行文件的下载，同时结束导航流程
* 如果`Content-Type`为`text/html`，会继续下一步：准备渲染进程

## 3. 准备渲染进程

网络进行解析响应头之后，会给浏览器进程发个消息，让它开始准备渲染进程，规则如下

* 如果是第一个打开的界面，为该界面准备一个渲染进程
* 如果不是第一个打开的界面，判断新打开的界面是不是和当前界面属于同一站点，
    * 是，共享一个渲染进程
    * 否，为新界面创建一个新的渲染进程

同一站点：协议和根域名相同。

例如，百度、百度贴吧、百度学术属于同一站点，公用一个渲染进程

```
https://www.baidu.com/
https://tieba.baidu.com/index.html
https://xueshu.baidu.com/
```

![image-20200723200805719](https://tva1.sinaimg.cn/large/007S8ZIlgy1gh15wg6ahoj31i20bcn28.jpg)



## 4.提交文档，结束导航流程

这里的文档是指响应体数据，即HTML文档。

提交文档是**浏览器进程**发起的，渲染进程收到提交文档的消息之后，会和网络进程建立传输数据的管道。

渲染进程接受完响应体数据之后，向浏览器进程回个消息，确认文档提交完成，浏览器进程收到消息后会更新页面状态，同时开始转圈圈。

导航流程至此结束，接下来进入渲染流程。



## 补充知识

导航阶段涉及到的主要是http相关的网络知识需要补充下，自顶而下依次是

* dns协议 http://111.229.14.189/#/read/mxprfcgr030/eaymrox43no
* http、https
    * 缓存
    * cookie
    * curl命令使用
* tcp与ip协议

