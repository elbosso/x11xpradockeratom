# x11xpradockeratom

<!---
[![start with why](https://img.shields.io/badge/start%20with-why%3F-brightgreen.svg?style=flat)](http://www.ted.com/talks/simon_sinek_how_great_leaders_inspire_action)
--->
[![GitHub release](https://img.shields.io/github/release/elbosso/x11xpradockeratom/all.svg?maxAge=1)](https://GitHub.com/elbosso/x11xpradockeratom/releases/)
[![GitHub tag](https://img.shields.io/github/tag/elbosso/x11xpradockeratom.svg)](https://GitHub.com/elbosso/x11xpradockeratom/tags/)
[![GitHub license](https://img.shields.io/github/license/elbosso/x11xpradockeratom.svg)](https://github.com/elbosso/x11xpradockeratom/blob/master/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/elbosso/x11xpradockeratom.svg)](https://GitHub.com/elbosso/x11xpradockeratom/issues/)
[![GitHub issues-closed](https://img.shields.io/github/issues-closed/elbosso/x11xpradockeratom.svg)](https://GitHub.com/elbosso/x11xpradockeratom/issues?q=is%3Aissue+is%3Aclosed)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/elbosso/x11xpradockeratom/issues)
[![GitHub contributors](https://img.shields.io/github/contributors/elbosso/x11xpradockeratom.svg)](https://GitHub.com/elbosso/x11xpradockeratom/graphs/contributors/)
[![Github All Releases](https://img.shields.io/github/downloads/elbosso/x11xpradockeratom/total.svg)](https://github.com/elbosso/x11xpradockeratom)
[![Website elbosso.github.io](https://img.shields.io/website-up-down-green-red/https/elbosso.github.io.svg)](https://elbosso.github.io/)

This repository actually combines some ideas I had recently about docker, X11, and xpra:
It shows the basic skeleton for putting X11 applications into docker containers.

The repository here demonstrates this using the editor atom as the application in question.

You can either start it with a managed window like so:

```
ssh -p <ssh-port-of-container> user@dockerhost.docker.lab bash -l -c "atom"&
xpra --ssh="ssh -p <ssh-port-of-container>" attach ssh:user@dockerhost.docker.lab:100
```

or you can start a small an lightweight X-Server like blackbox or the like and go and use it for example like this:

```
ssh -p <ssh-port-of-container> user@dockerhost.docker.lab "Xephyr -ac -br -noreset -screen 1280x1024 :200" &
ssh -p <ssh-port-of-container> user@dockerhost.docker.lab DISPLAY=:200 blackbox &
ssh -p <ssh-port-of-container> user@dockerhost.docker.lab DISPLAY=:200 bash -l -c "xterm" &
xpra --ssh="ssh -p <ssh-port-of-container>" attach ssh:user@dockerhost.docker.lab:100
```

A window will open with a started xterm - you can use it to start any application installed - here for example atom.

One important thing: The container has password authentication disabled for ssh - so you need a keypair to log in. 
Fortunately, the _.ssh_ directory is exported as a volume so you can just copy an appropriate _authorized_keys_ there and 
you are all set up!

The users home directory is managed as a volume so you can save your work in your home directory without the fear to lose it
after container restart or image rebuild...
