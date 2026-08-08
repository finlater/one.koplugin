# one.koplugin

在 KOReader 上离线阅读「ONE · 一个」（wufazhuce.com）每日更新的内容。

每天只为你准备一张图片、一篇文字和一个问答。复杂世界，一个就够！

## 安装

把整个 `one.koplugin` 目录放到 KOReader 的 `plugins/` 下，重启 KOReader。
入口挂在 **顶部菜单 → 工具（Tools）标签 → ONE · 一个**（书架与书内均可进入）。

后续可在 **ONE · 一个 → 设置 → 更新管理** 中手动检查更新，或开启“每天自动检查一次”。更新会显示发布说明和下载进度，安装前校验发布包的 SHA-256，并保留上一版目录作为回滚备份；安装完成后重启 KOReader 即可生效。更新默认优先使用代理，代理不可用时会自动回退 GitHub 直连，也可在更新设置中关闭代理优先。

## 功能

| 主菜单 | 快捷菜单 | 最近 7 天 |
|:---:|:---:|:---:|
| ![主菜单](design/one_main_menu.png) | ![快捷菜单](design/quick_menu.png) | ![最近 7 天](design/recent_7_days.png) |

| 图文 | 文章 | 问答 |
|:---:|:---:|:---:|
| ![图文](design/one_picture.png) | ![文章](design/one_article.png) | ![问答](design/one_question.png) |

## SimpleUI / ZenUI 集成

插件提供统一的 “ONE · 最近 7 天” 入口，可固定到 SimpleUI 或 ZenUI 的主屏幕底栏；点击后直接显示最近七天页面。需要安装支持插件快捷操作的新版 SimpleUI 或 ZenUI。

- **SimpleUI**：进入 `快捷操作` 新建操作，类型选择 `插件 → ONE · 一个`，再把该操作加入主屏幕快捷操作或底部栏。若要使用项目图标，把 `icons/one-seven-days.svg` 复制到 KOReader 设置目录下的 `simpleui/custom_icons/`，再到快捷操作的图标选择器中选择它。
- **ZenUI 底栏**：进入 `控件 → 按钮 → ➕ → 插件 → ONE · 一个`，再将其放入底栏。插件启动时会把 `one-seven-days.svg` 同步到 KOReader 用户图标目录，供 ZenUI 自动匹配或手动选择。
- **ZenUI 主屏幕**：ONE 会注册一个可选的“ONE · 最近 7 天”组件。插件不会擅自修改、添加或启用用户的 Tab/底栏配置。

## 声明

本项目仅供个人学习使用，不得用于商业用途，请遵守「ONE · 一个」的用户协议与相关法律法规。
