---
title: Manjaro安装与优化全记录
date: 2019-08-03 17:30:02
categories: 
- Linux
tags:
- manjaro
- linux
cover_img: /images/4a3b5.jpg
feature_img: /images/4a3b5.jpg
description: 学习安装当前较受欢迎的manjaro linux系统，并对其进行优化...
keywords: linux,manjaro,gnome
---

### 前言

之前用过一段时间的linux后，又回到了windows。最近假期又起了折腾之心，想要回到linux的怀抱，于是就尝试了一下新火的manjaro，特此记录，与大家分享。

### 安装manjaro

首先从官网下载所需镜像，我选择的是gnome版本，大家可以根据个人喜好和机器配置进行选择。

linux系统下可以直接使用dd命令，windows用户可以使用rufus软件将镜像写入U盘，具体参考百度。

U盘启动盘制作好后插入电脑，重启电脑，开机界面出现后按快捷键进入启动盘选择界面，按上下键选择U盘启动，我的联想笔记本快捷键是F12，大家可以根据自己的电脑型号自行查找快捷键。

U盘启动之后，第一步使用enter和上下键选择时区、语言，然后点击第五项Boot，进入下一步。

如果需要，可以在窗口左上角可以选择语言Chinese，选择启动安装程序，然后一直点击下一步，根据自己情况设置安装硬盘和分区。

最后等待安装完成，拔掉U盘，重启电脑即可进入焕然一新的Manjaro。

接下来我们完成基本的设置和安装一些必备软件。

### 更换源

寻找国内最快源：

```bash
sudo pacman-mirrors -c China
```

sudo nano `/etc/pacman.conf`，末尾添加两行：

```
[archlinuxcn]
Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch
```

### 更新系统

```bash
 sudo pacman -Syu
```

### 安装`archlinuxcn-keyring`:

```bash
 sudo pacman -S archlinuxcn-keyring
 sudo pacman -Syu
```

### 修改Home下的目录为英文

修改目录映射文件名；

```bash
sudo nano ~/.config/user-dirs.dirs
```

修改为以下内容：

```
XDG_DESKTOP_DIR="$HOME/Desktop"
XDG_DOWNLOAD_DIR="$HOME/Download"
XDG_TEMPLATES_DIR="$HOME/Templates"
XDG_PUBLICSHARE_DIR="$HOME/Public"
XDG_DOCUMENTS_DIR="$HOME/Documents"
XDG_MUSIC_DIR="$HOME/Music"
XDG_PICTURES_DIR="$HOME/Pictures"
XDG_VIDEOS_DIR="$HOME/Videos"
```

将Home目录下的中文目录名改为对应的中文名；

```bash
cd ~
mv 公共 Public
mv 模板 Templates
mv 视频 Videos
mv 图片 Pictures
mv 文档 Documents
mv 下载 Download
mv 音乐 Music
mv 桌面 Desktop
```

重启系统。

### 安装搜狗输入法

```bash
 sudo pacman -S fcitx-im    #全部安装
 sudo pacman -S fcitx-configtool
 sudo pacman -S fcitx-sogoupinyin
```

sudo nano ~/.xprofile`文件，加入如下内容：

```
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
```

之后，自行百度安装Chrome、QQ、Wechat、网易云音乐、WPS等，这些可网上的命令直接安装，一路顺畅没有遇到问题。

### 更换主题和图标

系统自带了gnome-tweak-tool，名字为“优化”，可以用来更换主题和进行个性化设置。

推荐在 https://www.gnome-look.org/ 下载自己喜欢的主题，下载好压缩包之后解压，然后以管理员身份打开/usr/share/themes文件夹，将解压后得到的文件夹复制进去。

打开“优化”，即可选择自己安装的主题，我使用的是Ant Dracula主题。

另外，从github中下载主题需要自行编译，不推荐。
