# Copyright (c) <year> <copyright holders>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

FROM ubuntu:18.04

# these files are from ubuntu 20.04
ADD libdecor-0-dev_0.1.0-3build1_amd64.deb libdecor-0-0_0.1.0-3build1_amd64.deb /

# install deps
RUN apt-get update && apt-get upgrade && \
	apt-get install -y sudo ccache curl wget python3 python3-pip build-essential \
		zip unzip git cmake wayland-protocols libsdl2-dev && \
	pip3 install meson ninja

# install libdecor
RUN dpkg --force-all -i libdecor-0-dev_0.1.0-3build1_amd64.deb libdecor-0-0_0.1.0-3build1_amd64.deb

