# README

## 【必读】仓库clone后应执行操作

本项目中绝大多数导入的第三方库都已经加入到.gtignore文件，所以导入后应进行相关pod操作，重新集成项目工作区

执行命令：`pod install --verbose --no-repo-update`

解释：

- `pod install`：根据Podfile中描述需要引入的第三方库以及Podfile.lock文件中描述的第三方库版本导入第三方库
- `--verbose`：加上可以显示详细的检测过程，出错时会有详细的错误信息
- `--no-repo-update`：可以禁止更新本地的repos库文件,进而提高pod update速度.

## 版本对应内容【线上版本】

### 6.2.9

- 修复因token失效导致积分商城数组越界的闪退
- 修复积分商城的滑动卡死问题
- 修复版本更新提示
- 修复退出登录失败、闪退的问题

