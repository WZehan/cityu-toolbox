# 城大百宝箱 · CityU Toolbox

面向香港城市大学同学的 Flutter 校园便民工具，界面遵循 Material 3 设计（支持浅色 / 深色模式）。

- 当前构建版本：1.0.6+10。
- 点击顶部右侧的语言按钮，在弹出选单中选择简体中文、繁体中文或英语，各功能页面同步切换。
- 首页：搜索栏 + 分类切换（全部 / 食在城大 / 学在城大），分类胶囊按文字自然撑开，空间不足时可横向滚动。工具以卡片网格展示，卡片高度随内容自适应，手机单列、平板及桌面多列。全景导航介绍下方常显 info 图标与 Demo 说明。
- 食在城大：AC1 / AC3 线上点餐（外部浏览器 / Web 新标签页打开），AC2 七个窗口分「线上点餐」「现场点餐」展示。AC1 使用预点餐入口 `https://csd.order.place/home/store/112870?mode=prekiosk`。
- 学在城大：图书馆资源（馆藏搜索、八校通、学术资源、往年试题）、公共资源预约、运动场馆预约、在读证明预填表（输入校验、费用参考、英文预览和复制）、[CityU 全景导航](https://cityu-panorama-navigation.wangzehan.com/)（Demo 阶段，仅供体验）。
- 添加到主屏幕指引：仅在 Web 版首页显示，三步 Safari 图文教程，截图可放大。
- 表单不上传、不持久化个人资料；本工具不提交申请或签发证明。
- 首页底部提供 GitHub 源码仓库和关于作者的导航链接，支持简体中文、繁体中文和英语。

源码：[WZehan/cityu-toolbox](https://github.com/WZehan/cityu-toolbox) · 关于作者：[Zehan Wang](https://wangzehan.com/)

## 开源许可

本项目自有代码使用 [MIT License](LICENSE)。图片及品牌素材的使用范围见 [ASSET_LICENSES.md](ASSET_LICENSES.md)，第三方软件说明见 [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)。

欢迎提交 Issue 或 Pull Request。请勿提交个人资料、访问令牌或签名密钥。安装指引第二步使用维护者提供的无联系人信息截图。

代码结构：`lib/main.dart`（应用入口与路由）、`lib/theme.dart`（Material 3 主题）、`lib/campus_tools.dart`（工具数据）、`lib/home_page.dart`、`lib/testimonial_page.dart`、`lib/ac2_canteen_page.dart`、`lib/library_resources_page.dart`、`lib/install_guide.dart`、`lib/common_widgets.dart`（页面布局组件）。版本号见 `lib/app_info.dart` 与 `pubspec.yaml`。

## 开发

Flutter 3.44.0 / Dart 3.12.0。

```sh
flutter pub get
flutter run -d chrome
flutter analyze
flutter test
flutter build web --release --no-web-resources-cdn
python3 scripts/prepare_web.py
```

已生成 Web、iOS、Android、macOS、Windows、Linux 平台工程。已构建 Web 和 Android ARM64 release APK；原生平台尚未真机验证。

ARM64 APK 构建：`flutter build apk --release --target-platform android-arm64`。
本地化文本位于 `lib/l10n/*.arb`，修改后运行 `flutter gen-l10n`。

图标原图：`assets/images/toolbox.png`。重新生成：`dart run flutter_launcher_icons`。
功能数据：`lib/campus_tools.dart`。资料依据用户于 2026-09-10 提供的功能文档；HK$60/份为文档参考费用，实际以学校最新规定为准。

## 部署

- 生产域名：https://cityu-toolbox.wangzehan.com （已验证 HTTPS 可访问）
- Cloudflare Pages：https://cityu-toolbox.pages.dev
- GitHub Actions 在 push / PR 时执行分析、测试和 Web 构建，并提供构建产物。
- 已登录 Wrangler 后执行 `./scripts/deploy.sh` 发布到 Pages。当前采用本地构建直接上传；GitHub 工作流不自动发布。

本项目为学生便民工具，并非香港城市大学官方应用。

域名配置：在 Cloudflare 的 `wangzehan.com` 区域添加 CNAME，名称 `cityu-toolbox`，目标 `cityu-toolbox.pages.dev`，开启代理（TTL 自动）。等待 Pages 自定义域名状态变为 Active 并签发 HTTPS 证书。
