# 城大百宝箱 · CityU Toolbox

面向香港城市大学同学的 Flutter 校园便民工具，使用分类宫格集合校园服务。

- 食在城大：AC1 / AC2 / AC3 线上点餐，点击后在外部浏览器（Web 新标签页）打开。
- 当前构建版本：1.0.1(2)。AC1 使用预点餐入口 `https://csd.order.place/home/store/112870?mode=prekiosk`。
- 学在城大：应用内在读证明预填表，包含 8 个基本字段及联系地址、授课语言两个可选项，支持输入校验、费用参考、英文预览和复制。
- 自适应手机、平板和桌面；手机单列卡片显示食堂名称、位置、营业时间；分类筛选及搜索；使用提供的工具箱图标。
- 应用内添加桌面指引：三步 Safari 图文教程，截图可放大，并说明其他手机浏览器的操作入口。
- 表单不上传、不持久化个人资料。资料只在当前页面内存中保留；本工具不提交申请或签发证明。

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
功能数据及界面入口：`lib/main.dart`。资料依据用户于 2026-09-10 提供的功能文档；HK$60/份为文档参考费用，实际以学校最新规定为准。

## 部署

- 生产域名：https://cityu-toolbox.wangzehan.com （已验证 HTTPS 可访问）
- Cloudflare Pages：https://cityu-toolbox.pages.dev
- GitHub Actions 在 push / PR 时执行分析、测试和 Web 构建，并提供构建产物。
- 已登录 Wrangler 后执行 `./scripts/deploy.sh` 发布到 Pages。当前采用本地构建直接上传；GitHub 工作流不自动发布。

本项目为学生便民工具，并非香港城市大学官方应用。

域名配置：在 Cloudflare 的 `wangzehan.com` 区域添加 CNAME，名称 `cityu-toolbox`，目标 `cityu-toolbox.pages.dev`，开启代理（TTL 自动）。等待 Pages 自定义域名状态变为 Active 并签发 HTTPS 证书。
