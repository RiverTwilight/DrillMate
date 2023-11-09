# ClipMemo

## Contribution

### Before Submitting for Review...

-   Make sure change all sandbox API to production
-   Make sure add limitation for free account
-   Make sure remove test features

### Run Builder

```bash
dart run build_runner build
```

### Generate icon set

```bash
flutter pub run flutter_launcher_icons
```

### Switch to China mirror

```bash
flutter config --enable-mirrors=true
flutter config --no-enable-mirrors

# Temporaray
export PUB_HOSTED_URL=https://pub.flutter-io.cn
```

### Troubleshooting

```
Unable to load contents of file list: '/Target Support Files/Pods-Runner/Pods-Runner-frameworks-Release-input-files.xcfilelist'
```

https://stackoverflow.com/questions/56160460/error-unable-to-load-contents-of-file-list-target-support-files-pods-xx-pods

---

```
Waiting for another flutter command to release the startup lock
```

https://stackoverflow.com/questions/51679269/waiting-for-another-flutter-command-to-release-the-startup-lock

## Reference

-   [in_app_purchase](https://pub.dev/packages/in_app_purchase/example)
-   [share_handler](https://pub.dev/packages/share_handler)
-   [App Store IAP](https://stackoverflow.com/questions/73035526/how-to-get-a-unique-identifier-for-in-app-purchases-in-flutter-which-stays-alway)
-   [Use iOS API detect file speech](https://developer.apple.com/documentation/speech/sfspeechurlrecognitionrequest)
-   [iOS widget for flutter app](https://www.youtube.com/watch?v=NoTc1D26HAo)
-   [flutter with iCloud](https://pub.dev/packages/icloud_storage)

## Test Notes

各位共建者，TalkReel 首个内测版本已经上线。开启快速上线流程。需要测试内容如下：

-   中文翻译
-   注册功能
-   登陆功能
-   购买订阅（登陆后购买）
-   购买终生会员（二选一）
-   从 Bilibili 客户端分享导入
-   从 Bilibili 网站链接分享导入
-   从 YouTube 网站链接分享导入
-   从相册导入
-   从外部 app 分享文件导入
-   自动生成字幕（仅限本地文件。任意语言）
-   每日回顾（积累至少 5 个书签以测试）
-   导入大文件、数量很多的文件（已知存在速度较慢的问题）
-   编辑书签
-   书签的标签系统（增删）
-   全局搜索功能
-   iCloud 备份功能
-   夜间模式配色
-   主题配色有无存在对比度低的位置
-   单个视频超过 15 个书签的性能
-   iPad 上有无无法使用的功能（响应式）
-   拔掉网线或者设备电池后，再打开 App
-   联系客服流程
-   提交反馈流程
-   媒体库文件多的情况下的性能
-   老旧设备下视频播放页面的性能（2018 年前机型）
-   修改账户密码
-   删除账户
-   抹除本地数据

请在 8 月 30 号之前完成测试，期间会不断迭代 TestFlight 内测，请注意更新版本。
