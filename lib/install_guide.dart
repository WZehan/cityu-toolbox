import 'package:flutter/material.dart';

class InstallGuidePage extends StatelessWidget {
  const InstallGuidePage({super.key});

  static const steps = [
    (
      title: '打开网站，点击分享',
      detail: '使用 Safari 打开城大百宝箱首页，点击浏览器下方的分享按钮。',
      image: 'assets/images/install/step-1.png',
    ),
    (
      title: '选择「添加到主屏幕」',
      detail: '在分享菜单中向下滑动，找到并点击「添加到主屏幕」。',
      image: 'assets/images/install/step-2.png',
    ),
    (
      title: '确认名称，点击「添加」',
      detail: '将名称设为「城大百宝箱」，点击右上角「添加」。之后就能从桌面图标直接打开。',
      image: 'assets/images/install/step-3.png',
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        '将应用添加至桌面',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1040),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.add_to_home_screen_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 36,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '校园工具，随手打开。',
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '把城大百宝箱添加到手机主屏幕，下次轻点图标即可访问。',
                    style: TextStyle(height: 1.7),
                  ),
                  const SizedBox(height: 16),
                  const SelectableText(
                    'https://cityu-toolbox.wangzehan.com',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'iPhone / iPad · Safari',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  const Text('以下为 iPhone Safari 操作示例，点击截图可放大查看。'),
                  const SizedBox(height: 20),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.maxWidth >= 800 ? 3 : 1;
                      final width =
                          (constraints.maxWidth - (columns - 1) * 20) / columns;
                      return Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: List.generate(steps.length, (i) {
                          final step = steps[i];
                          return SizedBox(
                            width: width,
                            child: Card(
                              elevation: 0,
                              margin: EdgeInsets.zero,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      child: Text('${i + 1}'),
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      step.title,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      step.detail,
                                      style: const TextStyle(height: 1.7),
                                    ),
                                    const SizedBox(height: 18),
                                    Center(
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          maxWidth: 300,
                                        ),
                                        child: Semantics(
                                          button: true,
                                          label:
                                              '放大第 ${i + 1} 步截图：${step.title}',
                                          child: InkWell(
                                            onTap: () => showDialog<void>(
                                              context: context,
                                              builder: (ctx) => Dialog.fullscreen(
                                                child: SafeArea(
                                                  child: Column(
                                                    children: [
                                                      Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: IconButton(
                                                          tooltip: '关闭截图',
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                ctx,
                                                              ),
                                                          icon: const Icon(
                                                            Icons.close,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: InteractiveViewer(
                                                          minScale: 1,
                                                          maxScale: 4,
                                                          child: Center(
                                                            child: Image.asset(
                                                              step.image,
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.asset(
                                                step.image,
                                                semanticLabel: step.title,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    '其他手机浏览器',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '使用手机原生浏览器打开上方网址，在分享或浏览器菜单中查找「添加到桌面」「添加到主屏幕」等选项，并按提示确认。不同浏览器的菜单位置和名称可能不同。',
                    style: TextStyle(height: 1.8),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
