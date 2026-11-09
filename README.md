# yshm'blog 源工程

https://yyydssm.github.io/ 的 Hexo 源码。旧站（2022 年那版）仓库里只有生成后的静态文件，无法增改文章，所以在这里重建了可维护的工程。

- Hexo 8 + Fluid 1.9.9，主题已从 node_modules 复制到 `themes/fluid` 并在此改配置（升级主题时注意重新复制）
- 语言 zh-CN，时区 Asia/Shanghai，permalink `:year/:month/:day/:title/`
- 文章保留旧站地址：`2022/07/13/Conwaylife康威生命游戏/`、`2022/07/13/B站up整理/`（用 front-matter 的 `permalink` 固定）

## 写文章：双击三个文件就够了

工程根目录下有三个双击即用的入口，不用记命令：

| 文件 | 作用 |
|---|---|
| **新建文章.bat** | 弹窗问你标题 → 自动在 `source/_posts/` 生成带日期的 Markdown，并用 VS Code 打开 → 直接写正文 |
| **本地预览.bat** | 起本地服务并自动开浏览器 `http://127.0.0.1:4000`，在自己电脑上看效果（不联网） |
| **发布上线.bat** | 重新生成站点并推送到 GitHub Pages，几十秒后 https://yyydssm.github.io/ 就是最新的 |

流程就三步：**新建文章.bat → 写完保存 → 本地预览.bat 看效果 → 发布上线.bat 上线**。

`tools/node/node.exe` 是随工程带的 Node 运行时，双击方式不依赖你电脑装没装 Node，也不依赖 PATH。

### 想手写也行

直接在 `source/_posts/` 里新建 `.md`，开头必须有这段（`permalink` 决定网址，可以照抄格式改标题）：

```markdown
---
title: "文章标题"
date: 2026-11-09 21:00:00
permalink: 2026/11/09/文章标题/
categories: FPGA
tags:
---

正文……（`<!-- more -->` 之前的内容会显示在首页摘要里）
```

写好后双击 **发布上线.bat** 即可。

## 命令行走法（进阶）

```powershell
node node_modules\hexo\bin\hexo server -p 4000     # 本地预览
node node_modules\hexo\bin\hexo new post "标题"    # 新建文章
node node_modules\hexo\bin\hexo clean
node node_modules\hexo\bin\hexo generate           # 只生成不发布
.\deploy.ps1                                       # 生成 + 发布
```

**发布一定要用 `deploy.ps1`（或 发布上线.bat），不要用 `hexo deploy`。** 本机 hexo-deployer-git 在 `.deploy_git` 里建不起独立 git 仓库，会把源码 commit 误推到 master（已踩过一次，靠备份分支恢复）。

## 目录说明

| 路径 | 内容 |
|---|---|
| `新建文章.bat` `本地预览.bat` `发布上线.bat` | 双击入口 |
| `deploy.ps1` | 生成 + 发布脚本（三个 bat 的实际逻辑都在这里和 `tools/` 里） |
| `tools/new-post.ps1` | 新建文章的提示与模板逻辑 |
| `tools/node/node.exe` | 随工程携带的 Node 运行时（不入库） |
| `_config.yml` | 站点配置（标题、url、permalink、deploy） |
| `themes/fluid/_config.yml` | 主题配置（banner、slogan、关于页、社交图标） |
| `source/_posts/` | 文章（`conwaylife.md`、`bilibili-ups.md`，均迁自旧站） |
| `source/about/` `source/tags/` `source/categories/` | 页面 |
| `source/img/` | 头像与 banner（`head.png` 沿用旧站），文中图片在 `img/posts/` |
| `_raw/`、`_shots/` | 迁移中间文件与预览截图，不入库 |

## 远端分支

- `master`：生成后的站点（GitHub Pages 从这里发布）
- `source`：本工程的源码（含本 README）
- `site-backup-2022`：重建前的旧静态站整份快照，需要回退时可用
