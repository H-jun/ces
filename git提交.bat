@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
title GitHub一键提交工具
color 0A
echo ==============================================
echo          GitHub 一键提交推送脚本
echo ==============================================
echo.

:: 判断是否是git仓库
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo 【提示】当前文件夹未初始化Git仓库，将引导初始化
    echo ==============================================
    set /p "init_confirm=是否执行仓库初始化？(Y/N)："
    if /i not "!init_confirm!"=="Y" (
        echo 已取消初始化，脚本退出
        pause >nul
        exit /b
    )
    echo.
    echo 1. 初始化本地仓库 git init
    git init
    echo.
    set /p "repo_url=请粘贴GitHub仓库地址(SSH/HTTPS)："
    if not defined repo_url (
        echo 仓库地址不能为空，退出脚本
        pause >nul
        exit /b
    )
    echo.
    echo 2. 绑定远程origin仓库
    git remote add origin !repo_url!
    echo.
    echo 3. 添加所有文件并初次提交
    git add .
    git commit -m "feat: initial commit"
    echo.
    :: 获取当前默认分支名
    git symbolic-ref --short HEAD > tmp_branch.tmp
    set /p main_branch=<tmp_branch.tmp
    del tmp_branch.tmp
    echo 4. 推送初始代码并绑定上游分支
    git push -u origin !main_branch!
    echo.
    echo ==============================================
    echo 仓库初始化完成，进入正常提交流程
    echo ==============================================
    echo.
)

:: 已有仓库正常提交流程
echo [1/4] 拉取远程最新代码 git pull
git pull
echo.

set "commit_msg="
set /p "commit_msg=输入本次提交备注(例：feat:新增页面 / fix:修复报错)："
if not defined commit_msg (
    echo 提交备注不能为空，脚本结束
    pause >nul
    exit /b
)

echo [2/4] 添加全部修改文件 git add .
git add .
echo.

echo [3/4] 本地提交代码 git commit
git commit -m "!commit_msg!"
echo.

echo [4/4] 推送至远程GitHub git push
git push
echo.

echo ==============================================
echo 所有操作执行完成！
echo ==============================================
pause >nul
endlocal