# EagleEye架构设计说明书


## 文档概述


### 文档版本

v0.1（草稿）


### 项目背景

在软件开发测试以及项目管理过程中产生越来越多的数据，目前在管理与查看分析这些数据时主要依靠Office类的软件。这需要了解相关软件高级使用方法，编辑多图表集合时不是很方便。另外，多人想查看同一份图表时，需要通过相互拷贝文件的方式。


### 项目目标

我们希望提供一个平台，它能够收集并解析这些数据。

我们希望提供一个客户端，实现数据可视化。它允许用户配置图表和图表集合，与平台数据通过数据交互生成可视化的图表。


## 名词解释

平台：EagleEye Platform。

客户端： EagleEye App，web客户端。

图表： 平台内的单个图表（Chart）。

图表集: 图表集合（Chart Set），由平台内零个或多个图表组成。

Not in scope: 不计划在系统的第一个版本里包含此功能。


## 整体架构

平台负责文件及数据解析，数据持久化，权限管理，搜索以及提供一套完整的REST API供客户端使用。

客户端提供友好的UI供用户配置和浏览图表及图表集。客户端严格通过平台REST API与平台进行数据交互。


## 逻辑架构


### 平台


#### 图表类型管理模块

图表类型多种多样，比如有：Line, Pie, Column 和 Bar 等。目前阶段计划实现三种：Line, Column 和 Bar。但是此模块要有良好的可扩展性，为未来支持更多图表类型提供便利。


#### 数据存储模块

存储单个图表配置信息，图表集合配置信息，图表模版，图表关联的数据。


#### 文件解析模块

解析上传的`.csv`，`.xls`等文件格式，它们的内容是图表数据。


#### REST API 模块

实现平台REST API接口。


#### 日志模块

*Not in scope.*

平台操作日志。


#### 通知模块

*Not in scope.*

邮件通知相关用户平台的关键操作日志信息。


#### 用户权限模块

*Not in scope.*

用户及权限管理。由于项目的特殊性，因此目前暂不考虑实现此模块。


#### 定时任务模块

*Not in scope.*

类似 cron job， 平台可以配置定时任务主动调用某API或读取相关文件去获取数据并解析生成图表。


### 客户端


#### Dashboard模块

#/dashboard

客户端主页


#### 浏览单个图表模块

#/charts/:id

只查看单个图表。


#### 浏览图表集合模块

#/charts

查看某个图表集合。


#### 新建图表模块

#/charts/new

新建一个图表。


#### 更新图表模块

#/charts/:id/settings

更新某个图表。


#### 上传图表数据文件模块

#/charts/:id/settings

允许用户选择文件上传。


#### 查看图表集合模块

#/chart-sets

查看图表集合。


#### 查看单个图表集合模块

#/chart-sets/id

查看单个图表集合。


#### 新建图表集合模块

#/chart-sets/new

新建一个图表集合。


#### 更新图表集合模块

#/chart-sets/:id/settings

更新某个图表集合。


## 接口设计

[REST API](../rest-api/rest-api.md)


## 数据架构

采用NoSQL数据库存。

主要数据表：

* charts
* chart_sets
* chart_data


## 技术架构


### Front-end

* AngularJS v1.5.6 (https://angularjs.org/)
* Angular Material v1.1.0-rc4 (https://material.angularjs.org/latest/)
* Google Charts (https://developers.google.com/chart/)
* Yeoman (https://github.com/yeoman/generator-angular#readme)
* Grunt - The JavaScript Task Runner (http://gruntjs.com/)
* Sass (http://sass-lang.com/)
* AngularJS ui-router (https://github.com/angular-ui/ui-router)


#### UI/UX

* Material Design (https://www.google.com/design/spec/material-design/introduction.html)


### Web Service

* REST API


### Database

* MongoDB (NoSQL) (https://www.mongodb.com/)


### Backend

* Express framework v4.13.4 (http://expressjs.com/)
* Node.js v4.4.5 (https://nodejs.org/dist/v4.4.5/node-v4.4.5-x64.msi)


## 部署架构


### 平台

Node.js + Express


### 客户端

Express for now.


## 其他说明

TBD.
