#!/bin/bash
read -r -p "请输入更新内容: " m
echo 更新日志中...
System=$(uname -s)
if [ "$System" == "Darwin" ]; then
    echo "Use MacOS"
    sed -i '' "1a\\
####  $(date '+%Y-%m-%d %H:%M:%S %A') \\
    $m
    " ChangeLog.md
elif [ "$System" == "Linux" ]; then
    echo "Use Linux"
    sed -i "2 i #### $(date '+%Y-%m-%d %H:%M:%S %A') \n $m" ChangeLog.md
else
    echo "Other OS: $System"
fi
# 获取当前分支名
branch=$(git symbolic-ref --short -q HEAD)
echo "当前分支：$branch"
git add .
git commit -m "$m"
# 循环远程仓库
for i in $(git remote -v | awk '{print $2}' | grep -v '\(fetch\|push\)'); do
    if [[ $i == *"KevinYouu"* ]]; then
        # 推送当前仓库
        echo "更新 $i 仓库"
        git push "$i" "$branch"
    fi
done
