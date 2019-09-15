---
title: Centos下搭建Django网站环境
date: 2019-04-20 13:32:14
categories: 
- Django
tags:
- django
- web服务器
cover_img: /images/59e5c5.jpg
feature_img: /images/59e5c5.jpg
description: 在Centos7中，结合nginx和uwsgi，搭建一个完整的django网站服务器...
keywords: django,nginx,uwsgi,server
---

### 前言

作为django网站开发的学习者，这是我在搭建Centos-Django-Nginx-Uwsgi服务器时留下的笔记。在搭建过程中，参考了大量的网上教程，但是没有一篇能完整地带我正确地走过全部流程，大坑小坑不计其数，因此在这里和大家分享一下我搭建过程中的整个流程，希望对学习者有所帮助。

### 安装Python3.6

- 安装依赖工具

  ```
  sudo yum install openssl-devel bzip2-devel expat-devel gdbm-devel readline-devel sqlite-devel mysql-devel gcc gcc-devel python-devel
  ```

- 下载python3.6.8

  ```
  wget https://www.python.org/ftp/python/3.6.8/Python-3.6.8.tgz
  ```

- 解压

  ```
  tar -zxvf Python-3.6.8.tgz
  ```

- 将python移动至规范的软件安装目录

  ```
  sudo mv Python-3.6.8 /usr/local
  ```

- 编译安装python

  ```
  cd /usr/local/Python-3.6.8/
  ./configure
  make
  sudo make install
  ```

### 安装虚拟环境

- 安装virtualenvwrapper

  ```
  # update pip
  sudo /usr/local/bin/pip3 install --upgrade pip
  sudo /usr/local/bin/pip3 install virtualenv
  sudo /usr/local/bin/pip3 install virtualenvwrapper
  ```

- 创建目录存放虚拟环境

  ```
  mkdir $HOME/.virtualenvs
  ```

- 修改~/.bashrc文件

  ```
  sudo vim~/.bashrc
  # 添加下面的内容
  export WORKON_HOME=$HOME/.virtualenvs
  export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3.6
  source /usr/local/bin/virtualenvwrapper.sh
  ```

- 运行

  ```
  source ~/.bashrc
  ```

- 创建并进入虚拟环境

  ```
  mkvirtualenv myenv
  ```

### 安装Django并创建项目

- 虚拟环境下安装Django==1.11.20

  ```
  pip install django==1.11.20
  ```

- 创建项目

  ```
  # 进入放置项目的文件夹
  cd /home/root/pydj
  sudo /home/admin/.virtualenvs/myenv/bin/django-admin startproject mysite
  ```

- 获取文件夹权限，防止runserver时数据库出错

  ```
  sudo chmod -R 777 /home/root/pydj
  ```

- 将你的服务器ip添加到settings.py，避免外网访问错误

  ```
  ALLOWED_HOSTS = ['myip']
  ```

- 试运行项目，不指定0.0.0.0外网访问会出错

  ```
  python manage.py runserver 0.0.0.0:8000
  ```

  访问：http://myip:8000 可以看到：

  ```
  It worked!
  Congratulations on your first Django-powered page.
  Next, start your first app by running python manage.py startapp [app_label].
  You're seeing this message because you have DEBUG = True in your Django settings file and you haven't configured any URLs. Get to work!
  ```

### uWSGI的安装和配置

- 虚拟环境下安装uWSGI

  ```
  pip install uwsgi
  ```

- 测试

  创建一个test.py文件，内容如下：

  ```
  def application(env, start_response):
      start_response('200 OK', [('Content-Type','text/html')])
      return [b"Hello World"] # python3
      #return ["Hello World"] # python2
  ```

  运行uWSGI:

  ```
  uwsgi --http :8000 --wsgi-file test.py
  ```

  访问 http://myip:8000 可以看到：Hello World

- 使用uWSGI运行Django项目

  ```
  uwsgi --http :8000 --module mysite.wsgi
  ```

### nginx的安装和配置

- 安装nginx

  ```
  # 安装nginx源
  sudo rpm -ivh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
  安装nginx
  yum install -y nginx
  ```

- 测试

  ```
  sudo nginx
  ```

  浏览器打开ip地址可以看到Welcome to nginx!

- 进入django项目文件夹，创建uwsgi_params文件，添加如下内容：

  ```
  uwsgi_param  QUERY_STRING       $query_string;
  uwsgi_param  REQUEST_METHOD     $request_method;
  uwsgi_param  CONTENT_TYPE       $content_type;
  uwsgi_param  CONTENT_LENGTH     $content_length;
  
  uwsgi_param  REQUEST_URI        $request_uri;
  uwsgi_param  PATH_INFO          $document_uri;
  uwsgi_param  DOCUMENT_ROOT      $document_root;
  uwsgi_param  SERVER_PROTOCOL    $server_protocol;
  uwsgi_param  REQUEST_SCHEME     $scheme;
  uwsgi_param  HTTPS              $https if_not_empty;
  
  uwsgi_param  REMOTE_ADDR        $remote_addr;
  uwsgi_param  REMOTE_PORT        $remote_port;
  uwsgi_param  SERVER_PORT        $server_port;
  uwsgi_param  SERVER_NAME        $server_name;
  ```

- 在 /etc/nginx/ 文件夹下创建 sites-enabled 文件夹，并在其下创建nginx.conf，添加如下内容：

  ```
  # nginx.conf
  
  # the upstream component nginx needs to connect to
  upstream django {
      # server unix:///path/to/your/mysite/mysite.sock; # for a file socket
      server 127.0.0.1:8001; # for a web port socket (we'll use this first)
  }
  
  # configuration of the server
  server {
      # the port your site will be served on
      listen      80;
      # the domain name it will serve for
      server_name .example.com; # substitute your machine's IP address or FQDN
      charset     utf-8;
  
      # max upload size
      client_max_body_size 75M;   # adjust to taste
  
      # Django media
      location /media  {
          alias /path/to/your/mysite/media;  # your Django project's media files - amend as required
      }
  
      location /static {
          alias /path/to/your/mysite/static; # your Django project's static files - amend as required
      }
  
      # Finally, send all non-media requests to the Django server.
      location / {
          uwsgi_pass  django;
          include     /path/to/your/mysite/uwsgi_params; # the uwsgi_params file you installed
      }
  }
  ```

- 修改/etc/nginx/nginx.conf，在http下添加：

  ```
  include /etc/nginx/sites-enabled/*;
  ```

- 部署静态文件

  在运行nginx之前，你必须收集所有的Django静态文件到静态文件夹里。首先，必须编辑mysite/settings.py，添加:

  ```
  STATIC_ROOT = os.path.join(BASE_DIR, "static/")
  ```

  然后运行

  ```
  python manage.py collectstatic
  ```

- 重启nginx

  ```
  sudo /usr/sbin/nginx -s reload
  ```

  此时打开 ip:8000 会出现502错误，因为nginx与uwsgi的socket通信还没开始。

  虚拟环境下运行：

  ```
  uwsgi --socket :8001 --wsgi-file test.py
  ```

  此时，打开ip:8000可以看到Hello World。

### 使用Unix sockets代替端口

编辑sites-enabled文件夹下的nginx.conf文件，修改如下：

```
server unix:///path/to/your/mysite/mysite.sock; # for a file socket  
# server 127.0.0.1:8001; # for a web port socket (we'll use this first)
```

重启nginx。

重新运行uWSGI：

```
uwsgi --socket mysite.sock --wsgi-file test.py --chmod-socket=666
```

### 使用uWSGI和Nginx运行django项目

```
uwsgi --socket mysite.sock --module mysite.wsgi --chmod-socket=666
```

现在uwsgi和nginx应该在服务你的Django应用，而不是hello world。

### 配置uWSGI的ini文件

- 项目文件夹下创建django_uwsgi.ini，添加以下内容：

  ```
  # django_uwsgi.ini file
  [uwsgi]
  
  # Django-related settings
  # the base directory (full path)
  chdir           = /path/to/your/project  
  # Django's wsgi file
  module          = project.wsgi  
  # the virtualenv (full path)
  #home            = /path/to/virtualenv
  
  # process-related settings
  # master
  master          = true  
  # maximum number of worker processes
  processes       = 10  
  # the socket (use the full path to be safe
  socket          = mysite.sock  
  # ... with appropriate permissions - may be needed
  chmod-socket    = 666
  # clear environment on exit
  vacuum          = true
  ```

  使用如下命令运行：

  ```
  uwsgi --ini django_uwsgi.ini
  ```

### 附

- 让uwsgi在后台运行：

  ```
  uwsgi --ini mysite_uwsgi.ini --logto mysite.log &
  ```

- 查看uwsgi进程

  ```
  ps aux|grep uwsgi
  ```

- 杀死uwsgi进程

  ```
  #停止进程
  uwsgi --stop uwsgi.pid
  #kill pid会发送SIGTERM，只会导致重启，而不是结束掉。需要发送SIGINT或SIGQUIT，对应着是INT才可以
  killall -s INT uwsgi
  ```

以上就是在服务器中部署Django项目的所有过程，如有不当之处请指正。
