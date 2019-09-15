---
title: 在Manjaro Linux中安装TexLive
date: 2019-08-04 21:49:06
categories: 
- Linux
tags:
- manjaro
- latex
cover_img: /images/5605b.jpg
feature_img: /images/5605b.jpg
description: 学习在manjaro linux系统中搭建Latex写作环境...
keywords: latex,linux,manjaro
---

## 前言

最近开始尝试使用Latex进行论文写作，根据网友推荐，选择Texlive作为基本环境，windows机器上可以很方便的安装Texlive，在Manjaro Linux系统下也不算复杂，我将我的安装过程写在这里与大家分享。

## 方法一

推荐使用方法二。

### 安装Perl组件

终端运行以下命令：

```bash
sudo pacman -S perl-tk
```

### 下载iso文件

在清华大学镜像站下载：https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/Images/ 

我选择的是 texlive2019.iso，点击即开始下载，3.3G有点大。

### 加载iso文件

终端运行以下命令：

```bash
sudo mount -o loop /path/to/texlive2019-20190410.iso /mnt
```

如果提示：mount: /mnt: 警告：设备写保护，使用只读方式挂载. 忽略即可。

### 启动安装界面

终端执行以下命令：

```bash
cd /mnt
sudo ./install-tl -gui
```

出现图形化安装界面，一般不需进行个性化设置，点击安装即可，喝杯水耐心等待安装完成。

添加环境变量，运行以下命令：

```bash
sudo nano ~/.bashrc
```

在文件末尾，添加如下内容：

```bash
# texlive 2019
export MANPATH=${MANPATH}:/usr/local/texlive/2019/texmf-dist/doc/man
export INFOPATH=${INFOPATH}:/usr/local/texlive/2019/texmf-dist/doc/info
export PATH=${PATH}:/usr/local/texlive/2019/bin/x86_64-linux
```

别忘记卸载镜像：

```bash
sudo umount /mnt/
```

测试，新建test.tex文件，添加如下内容：

```latex
\documentclass{article}
\begin{document}
hello \LaTeX
\end{document}
```

然后在终端运行以下命令：

```bash
xelatex /path/to/test.tex
```

如安装成功，得到如下输出：

```bash
This is XeTeX, Version 3.14159265-2.6-0.999991 (TeX Live 2019) (preloaded format=xelatex)
 restricted \write18 enabled.
entering extended mode
(./textest.tex
LaTeX2e <2018-12-01>
(/usr/local/texlive/2019/texmf-dist/tex/latex/base/article.cls
Document Class: article 2018/09/03 v1.4i Standard LaTeX document class
(/usr/local/texlive/2019/texmf-dist/tex/latex/base/size10.clo))
No file textest.aux.
[1] (./textest.aux) )
Output written on textest.pdf (1 page).
Transcript written on textest.log.
```

## 方法二

Archlinux已经有了有关texlive的包，简单的方法就是执行以下命令直接安装：

```bash
sudo pacman -S texlive-most
```

具体可以参考：https://wiki.archlinux.org/index.php/TeX_Live 。

### 安装TexStudio

终端执行以下命令：

```bash
sudo pacman -S texstudio
```

安装完成后可以在options中设置为中文界面，以及选择默认的编译器。

用第一种方法安装，可能会导致TexStudio检索不到TexLive，推荐使用第二种方法安装。

现在就可以开始Latex文章的撰写了！
