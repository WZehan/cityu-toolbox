# 城大百宝箱 · CityU Toolbox

面向香港城市大学同学的 Flutter 校园便民工具，界面遵循 Material 3 设计（支持浅色 / 深色模式）。

- 当前构建版本：1.0.3(4)。
- 首页：搜索栏 + 分类切换（全部 / 食在城大 / 学在城大），工具以卡片网格展示，手机单列、平板及桌面多列。
- 食在城大：AC1 / AC3 线上点餐（外部浏览器 / Web 新标签页打开），AC2 七个窗口分「线上点餐」「现场点餐」展示。AC1 使用预点餐入口 `https://csd.order.place/home/store/112870?mode=prekiosk`。
- 学在城大：图书馆资源（馆藏搜索、八校通、学术资源、往年试题）、座位预约、运动场馆预约、在读证明预填表（输入校验、费用参考、英文预览和复制）。
- 添加到主屏幕指引：仅在 Web 版首页显示，三步 Safari 图文教程，截图可放大。
- 表单不上传、不持久化个人资料；本工具不提交申请或签发证明。

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

已生成 Web、iOS、Android、macOS、Windows、Linux 平台工程。仅构建和验证 Web；原生平台尚未构建或真机验证。

图标原图：`assets/images/toolbox.png`。重新生成：`dart run flutter_launcher_icons`。
功能数据：`lib/campus_tools.dart`。资料依据用户于 2026-09-10 提供的功能文档；HK$60/份为文档参考费用，实际以学校最新规定为准。

## 部署

- 生产域名：https://cityu-toolbox.wangzehan.com （已验证 HTTPS 可访问）
- Cloudflare Pages：https://cityu-toolbox.pages.dev
- GitHub Actions 在 push / PR 时执行分析、测试和 Web 构建，并提供构建产物。
- 已登录 Wrangler 后执行 `./scripts/deploy.sh` 发布到 Pages。当前采用本地构建直接上传；GitHub 工作流不自动发布。

本项目为学生便民工具，并非香港城市大学官方应用。

域名配置：在 Cloudflare 的 `wangzehan.com` 区域添加 CNAME，名称 `cityu-toolbox`，目标 `cityu-toolbox.pages.dev`，开启代理（TTL 自动）。等待 Pages 自定义域名状态变为 Active 并签发 HTTPS 证书。
