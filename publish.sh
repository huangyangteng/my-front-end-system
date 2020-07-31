#/bin/bash

# 将代码发布到服务器
local=/Users/best9/github/my-front-end-system
remote=root@111.229.14.189:/root/webapps

rsync -v   --progress --stats -r -t -p -l -z -e 'ssh -p 22'  $local $remote