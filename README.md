# HGeology

## Contribution

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
-   [Flutter camera](https://docs.flutter.dev/cookbook/plugins/picture-using-camera)
