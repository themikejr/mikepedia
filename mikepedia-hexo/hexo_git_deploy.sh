#!/bin/bash

echo "hexo clean"
/root/mikepedia/node_modules/hexo/bin/hexo clean
echo "hexo generate"
/root/mikepedia/node_modules/hexo/bin/hexo generate
echo "heck deploy"
/root/mikepedia/node_modules/hexo/bin/hexo deploy

echo "update git"
( cd ~/mikepedia_static; git pull --no-edit ; git push live master )
