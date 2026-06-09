# Minimal Colemak Vim

一份面向 Colemak 键盘布局的轻量 Vim 配置。它从个人完整 Neovim 配置中抽取了最常用、最稳定的文本编辑习惯，目标是在新的 Linux/macOS 环境、SSH 远程机器、开发板和临时系统中尽快恢复熟悉的编辑手感。

这份配置默认不依赖插件也能启动；如果已经安装 `vim-plug`，会额外加载一小组只和文本编辑体验相关的插件。

## 适用人群

- 使用 Colemak 键盘布局，并希望在 Vim 中使用 `u/n/e/i` 作为方向键的人。
- 经常在新 Linux 机器、开发板、服务器、SSH 环境中编辑文件的人。
- 希望保留常用 Vim 编辑增强，但不想在基础 Vim 环境里引入复杂 LSP、补全、Git UI、文件管理器或图形依赖的人。
- 已经有完整 Neovim 配置，但想准备一份更稳、更容易移植的 Vim fallback 配置的人。

## 适用平台

- Linux
- macOS
- 远程服务器
- 嵌入式 Linux / 开发板
- WSL 通常也可用

不要求 GUI，不要求 Neovim，不要求 Python、Node.js、Lua 或 language server。

## 硬件和软件要求

最低要求：

- Vim
- 一个可写的用户家目录

推荐要求：

- Vim 8 或更新版本
- `+clipboard`，用于系统剪贴板复制
- `+persistent_undo`，用于持久撤销
- `curl`，仅在需要自动安装 `vim-plug` 时使用
- `git`，仅在需要安装插件时使用

插件不是必需品。没有插件时，这份配置仍然可以正常使用 Colemak 键位、基础编辑选项、窗口管理、tab 管理和文本操作快捷键。

## 文件放置方式

Vim 在用户级配置中常见的读取优先级是：

```text
~/.vimrc
~/.vim/vimrc
~/.config/vim/vimrc
```

通常 Vim 会读取优先找到的用户配置文件。因此，如果同时存在 `~/.vimrc` 和 `~/.vim/vimrc`，一般会优先使用 `~/.vimrc`。

### 推荐方式：整个仓库作为 ~/.vim

如果你希望把整个 Vim 配置作为一个 GitHub 仓库维护，推荐仓库结构如下：

```text
.vim/
├── vimrc
├── autoload/
│   └── plug.vim
├── plugged/
└── tmp/
```

新机器上直接 clone：

```sh
git clone <your-repo-url> ~/.vim
```

这种方式下，主配置文件应该叫：

```text
~/.vim/vimrc
```

注意：这里文件名是 `vimrc`，没有前面的点。

如果目标机器已经有 `~/.vimrc`，它可能会抢先被读取。你可以选择备份它：

```sh
mv ~/.vimrc ~/.vimrc.bak
```

也可以让 `~/.vimrc` 只做一个入口：

```vim
source ~/.vim/vimrc
```

### 备用方式：单文件放到家目录

如果只想使用单个配置文件，可以把本仓库中的 `vimrc` 移动或复制到家目录，并改名为 `.vimrc`：

```sh
cp ~/.vim/vimrc ~/.vimrc
```

这种方式下，文件路径应为：

```text
~/.vimrc
```

注意：移动到家目录后，文件名需要从 `vimrc` 改成 `.vimrc`。

## 安装插件

这份配置不会在 Vim 启动时自动联网下载插件。这样做是为了保证新系统、弱网环境、开发板环境下 Vim 可以稳定打开。

首次安装 `vim-plug`：

```vim
:ColemakInstallPlug
```

然后重启 Vim，安装插件：

```vim
:PlugInstall
```

如果国内访问 GitHub 较慢，可以手动安装 `plug.vim`，或提前在本机装好后，把下面两个目录一起移植到目标机器：

```text
~/.vim/autoload/plug.vim
~/.vim/plugged/
```

## 卸载插件

先在 `vimrc` 中删除或注释对应的 `Plug '...'` 行，然后重新加载配置：

```vim
:source ~/.vim/vimrc
```

如果你使用的是家目录单文件：

```vim
:source ~/.vimrc
```

再清理未使用插件：

```vim
:PlugClean
```

如果想临时禁用所有插件，可以创建 `~/.vimrc.local`：

```vim
let g:colemak_use_plugins = 0
```

## 功能亮点

- Colemak 方向键：`u/n/e/i` 对应上/左/下/右。
- 保留原 Neovim 配置中的核心肌肉记忆：`k` 插入、`l` 撤销、`S` 保存、`Q` 退出。
- 支持相对行号、当前行高亮、搜索高亮、智能大小写搜索。
- 默认 tab 宽度为 2，并保留真实 tab，不自动展开为空格。
- 自动恢复上次打开文件时的光标位置。
- 自动切换当前工作目录到当前文件所在目录。
- 开启持久撤销、备份和 swap 临时目录。
- 提供窗口分屏、tab 管理、折叠、替换、拼写检查、Markdown 辅助等常用快捷键。
- 插件可选，不安装插件也能正常工作。
- 通过 `~/.vimrc.local` 支持机器本地覆盖配置。

## 默认插件

如果安装了 `vim-plug`，会加载以下轻量文本编辑插件：

```text
tpope/vim-surround
tomtom/tcomment_vim
jiangmiao/auto-pairs
mbbill/undotree
mg979/vim-visual-multi
gcmt/wildfire.vim
junegunn/vim-after-object
godlygeek/tabular
tpope/vim-repeat
svermeulen/vim-subversive
rhysd/clever-f.vim
AndrewRadev/splitjoin.vim
theniceboy/argtextobj.vim
theniceboy/vim-move
dhruvasagar/vim-table-mode
dkarter/bullets.vim
mzlogin/vim-markdown-toc
```

这些插件主要服务于括号/引号编辑、注释、自动配对、撤销树、多光标、文本对象、表格、Markdown 列表和目录等文本操作。

## 快捷键映射

`<Leader>` 是空格键。

### 基础操作

| 快捷键 | 功能 |
| --- | --- |
| `;` | 进入命令行模式，相当于 `:` |
| `S` | 保存当前文件 |
| `Q` | 退出当前窗口 |
| `<Leader>rc` | 编辑当前 Vim 配置文件 |
| `<Leader>rv` | 编辑当前目录下的 `.vimrc` |
| `k` | 进入插入模式，相当于原生 `i` |
| `K` | 行首插入，相当于原生 `I` |
| `l` | 撤销，相当于原生 `u` |
| `Y` | 可视模式下复制到系统剪贴板 |
| `,.` | 跳转到匹配括号，相当于 `%` |
| `<Leader><CR>` | 取消搜索高亮 |
| `<Leader>dw` | 查找相邻重复单词 |
| `<Leader>tt` | 将 4 个空格替换为 tab |
| `<Leader>o` | 打开/关闭当前折叠 |
| `<C-y>` | 插入 `{}` 并进入中间新行 |

### Colemak 光标移动

| 快捷键 | 功能 |
| --- | --- |
| `u` | 上 |
| `n` | 左 |
| `e` | 下 |
| `i` | 右 |
| `U` | 向上移动 5 行 |
| `E` | 向下移动 5 行 |
| `N` | 到行首 |
| `I` | 到行尾 |
| `gu` | 按屏幕行向上移动 |
| `ge` | 按屏幕行向下移动 |
| `W` | 向后移动 5 个 word |
| `B` | 向前移动 5 个 word |
| `h` | 到当前/下一个 word 结尾 |
| `<C-U>` | 视窗向上滚动 |
| `<C-E>` | 视窗向下滚动 |

因为 `n` 被用作向左移动，所以搜索下一个/上一个结果改为：

| 快捷键 | 功能 |
| --- | --- |
| `=` | 下一个搜索结果 |
| `-` | 上一个搜索结果 |

### 命令行模式移动

| 快捷键 | 功能 |
| --- | --- |
| `<C-a>` | 到命令行开头 |
| `<C-e>` | 到命令行结尾 |
| `<C-p>` | 上一条命令 |
| `<C-n>` | 下一条命令 |
| `<C-b>` | 左移 |
| `<C-f>` | 右移 |
| `<M-b>` | 向左跳一个词 |
| `<M-w>` | 向右跳一个词 |

### 窗口管理

| 快捷键 | 功能 |
| --- | --- |
| `<Leader>w` | 切换到下一个窗口 |
| `<Leader>u` | 切到上方窗口 |
| `<Leader>e` | 切到下方窗口 |
| `<Leader>n` | 切到左侧窗口 |
| `<Leader>i` | 切到右侧窗口 |
| `qf` | 只保留当前窗口 |
| `su` | 向上创建水平分屏 |
| `se` | 向下创建水平分屏 |
| `sn` | 向左创建垂直分屏 |
| `si` | 向右创建垂直分屏 |
| `<Up>` | 增加窗口高度 |
| `<Down>` | 减少窗口高度 |
| `<Left>` | 减少窗口宽度 |
| `<Right>` | 增加窗口宽度 |
| `sh` | 将窗口改为上下布局 |
| `sv` | 将窗口改为左右布局 |
| `srh` | 旋转为上下布局 |
| `srv` | 旋转为左右布局 |
| `<Leader>q` | 关闭当前窗口下方的窗口 |

### Tab 管理

| 快捷键 | 功能 |
| --- | --- |
| `tu` | 新建 tab |
| `tU` | 当前窗口复制到新 tab |
| `tn` | 上一个 tab |
| `ti` | 下一个 tab |
| `tmn` | 当前 tab 左移 |
| `tmi` | 当前 tab 右移 |

### 文本和 Markdown

| 快捷键 | 功能 |
| --- | --- |
| `<Leader><Leader>` | 跳到下一个 `<++>` 占位符并编辑 |
| `<Leader>sc` | 开关拼写检查 |
| `` ` `` | 切换大小写，相当于原生 `~` |
| `<C-c>` | 当前行居中 |
| `\s` | 快速进入全文替换 |
| `<Leader>sw` | 开关自动换行 |
| `\p` | 显示当前文件完整路径 |
| `<Leader>tm` | 开关 Table Mode，需要插件 |
| `ga` | 可视模式下按正则对齐，需要 Tabular 插件 |
| `<Leader>cn` | 注释，需要 tcomment 插件 |
| `<Leader>cu` | 取消注释，需要 tcomment 插件 |
| `L` | 打开撤销树，需要 undotree 插件 |
| `<C-b>` | wildfire 快速选择，需要 wildfire 插件 |

## 本地覆盖配置

如果某台机器需要额外设置，不建议直接改主配置。可以创建：

```text
~/.vimrc.local
```

例如禁用插件：

```vim
let g:colemak_use_plugins = 0
```

例如关闭终端闪屏/视觉铃：

```vim
set noerrorbells
set novisualbell
set t_vb=
if exists('&belloff')
  set belloff=all
endif
```

## 设计取舍

这份配置刻意不包含：

- LSP
- 代码补全框架
- Treesitter
- Git UI
- 文件管理器
- 终端 UI
- Node.js / Python / Lua remote plugin 依赖
- 语言专用大型 IDE 插件

如果你需要完整代码补全和 IDE 体验，更适合使用单独的 Neovim 配置。这个 Vim 配置的定位是：新机器上快速可用、低依赖、好移植、文本操作手感稳定。

## 总结

这是一份以 Colemak 键位为核心的轻量 Vim 配置。它适合被放进 GitHub 仓库作为 `~/.vim` 整体移植，也可以作为单文件 `.vimrc` 使用。没有插件时，它是稳定的基础编辑环境；有插件时，它提供更舒服的文本对象、注释、括号、Markdown 和撤销树体验。

推荐日常仓库形态：

```text
~/.vim/vimrc
```

推荐新机器安装方式：

```sh
git clone <your-repo-url> ~/.vim
```

如果家目录中已有 `~/.vimrc`，请先备份、删除，或让它显式 `source ~/.vim/vimrc`。
