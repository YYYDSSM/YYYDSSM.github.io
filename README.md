# yshm'blog 源工程

https://yyydssm.github.io/ 的 Hexo 源码。旧站（2022 年那版）仓库里只有生成后的静态文件，无法增改文章，所以在这里重建了可维护的工程。

- Hexo 8 + Fluid 1.9.9，主题已从 node_modules 复制到 `themes/fluid` 并在此改配置（升级主题时注意重新复制）
- 语言 zh-CN，时区 Asia/Shanghai，permalink `:year/:month/:day/:title/`
- 文章保留旧站地址：`2022/07/13/Conwaylife康威生命游戏/`、`2022/07/13/B站up整理/`（用 front-matter 的 `permalink` 固定）

## 常用命令

```powershell
# 本地预览（http://127.0.0.1:4000）
node node_modules\hexo\bin\hexo server -p 4000

# 新建文章
node node_modules\hexo\bin\hexo new post "标题"

# 生成静态文件
node node_modules\hexo\bin\hexo clean
node node_modules\hexo\bin\hexo generate

# 发布上线（重要：用它，不要用 hexo deploy）
.\deploy.ps1
```

`deploy.ps1` 会自己组装 `.deploy_git` 目录并强制推送到 `YYYDSSM.github.io` 的 `master`。本机 `hexo deploy` 不可用：hexo-deployer-git 在 `.deploy_git` 里建不起独立 git 仓库，会把源码 commit 误推到 master（已踩过一次，靠备份分支恢复）。

## 目录说明

| 路径 | 内容 |
|---|---|
| `_config.yml` | 站点配置（标题、url、permalink、deploy） |
| `themes/fluid/_config.yml` | 主题配置（banner、slogan、关于页、社交图标） |
| `source/_posts/` | 文章（`conwaylife.md`、`bilibili-ups.md`，均迁自旧站） |
| `source/about/` `source/tags/` `source/categories/` | 页面 |
| `source/img/` | 头像与 banner（`head.png` 沿用旧站），文中图片在 `img/posts/` |
| `deploy.ps1` | 生成 + 发布脚本 |
| `_raw/`、`_shots/` | 迁移中间文件与预览截图，不入库 |

## 远端分支

- `master`：生成后的站点（GitHub Pages 从这里发布）
- `source`：本工程的源码（含本 README）
- `site-backup-2022`：重建前的旧静态站整份快照，需要回退时可用
