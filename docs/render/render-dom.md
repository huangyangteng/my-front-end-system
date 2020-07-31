# 渲染流程

渲染进程收到网络进行的文档之后，就会进行文档解析和子资源加载。渲染的整个流程称为渲染流水线，大概包括以下过程：

* DOM解析
* 样式计算
* 布局计算
* 构建图层树
* 生成绘制指令
* 栅格化
* 合成与显示

真个过程执行顺序如下图所示：

![image-20200724120815874](https://tva1.sinaimg.cn/large/007S8ZIlgy1gh1xnfotwqj314s0sw7cx.jpg)



## DOM树构建

### 什么是DOM

浏览器不能理解HTML结构，所以需要把html转化为浏览器能理解的DOM结构。

DOM是HTML数据的结构化表示，有以下几个作用

1. DOM展示了HTML在内存中基本结构
2. DOM提供给JavaScript脚本操作的接口，通过这些接口，JavaScript可以对DOM结构进行访问，从而改变文档的内容和样式。

### DOM树如何生成

渲染引擎有个HTMLParser的模块，用来解析HTML字节流，解析过程是**边收数据边进行解析**的，而不是等数据都收到了之后再进行进行解析。

解析可分为三个阶段

* 分词，生成Token
* 生成节点
* 生成DOM树

其中生成节点和生成DOM同步进行

#### 分词

HTML解析器首先会做词法分析，把html解析成一个个的token，这个过程是边接收数据边解析的，就像你听别人说话一样，边听大脑边处理信息

先来看一个最简单的例子：

```html
<html>
    <body>
        <div>1</div>
        <div>test</div>
    </body>
</html>
```

以上代码分词之后结果如下：

![image-20200724223946781](https://tva1.sinaimg.cn/large/007S8ZIlgy1gh2fwj3slbj315k06o76s.jpg)

如图所示，HTMLParser把上面的html分成三种Token,分别是 StartTag  EndTag和普通文本，当然实际情况下会更多。你可以点击这个链接，查看token种类

#### 生成节点和生成DOM

分词之后，每个token会生成一个节点并插入到DOM树中。

在这个过程中，HTMLParser会维护一个栈结构，用来处理DOM节点之间的父子管理。对于上面的几种token的处理规则如下：

* 如果是StartTag，入栈，然后新建DOM节点，插入到DOM树中，它的父节点就是栈中相邻元素生成的节点
* 如果是文本Token，新建一个文件节点，插入到DOM树中，它的父节点是栈顶元素。注意：文本节点不入栈
* 如果是EndTag,看一眼栈顶元素是不是与之对应的StartTag，例如<div>对应</div>，如果是，栈顶元素出栈，代表该DOM元素解析完成



注意：在解析时，HTML解析器会默认创建一个名为document的空DOM元素，并放入栈底，然后再开始解析其他Token。

### JavaScript是如何影响DOM生成的

JavaScript可以操作DOM节点，修改DOM结构，所以在DOM解析过程中遇到JavaScript会暂停DOM解析，开始执行JavaScript，执行完成之后继续DOM解析。



举个例子1：下面这段代码，在解析到script标签时，HTML解析器会判断这个一段脚本，所以会暂停DOM解析，因为这段脚本可能会修改已经解析完成的DOM结构，等脚本执行完成之后，再继续DOM的解析。

```html
<!DOCTYPE html>
<html lang="en">
<body>
    <div>hello</div>
    <script>
        document.querySelector('div').innerHTML='hi'
    </script>
</body>
</html>
```

举个例子2：下面这段代码，解析到script标签时，会暂停DOM解析，然后渲染进程会通知网络进程下载`1.js`，下载完成之后执行JavaSCript代码，执行完成之后继续DOM解析。

```html
<!DOCTYPE html>
<html lang="en">
<body>
    <div>hello</div>
    <script src="1.js"></script>
</body>
</html>
```

如果脚本中没有修改DOM的代码，可以把脚本设置为异步加载，标记为 `async`或者`defer`即可。它们的区别如下：

* async  异步,下载完成后立即执行
* defer 推迟,等到`DOMContentLoaded(HTML解析完成)`之后再执行





### 



















