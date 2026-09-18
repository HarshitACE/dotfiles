# Neovim config cheatsheet

Leader is **Space**. `?` shows buffer-local which-key mappings. Requires **Neovim 0.11+**.

Plugins are managed with [lazy.nvim](https://github.com/folke/lazy.nvim). Theme is **tokyonight-night** (transparent).

```
init.lua
lua/batman/          -- options + global maps + lazy bootstrap
lua/plugins/init.lua -- plugin specs
lua/config/dap/      -- debugger
plugin/              -- LSP, Telescope, which-key, lualine
```

`:Mason` installs extra language servers and debug adapters. `:Lazy` manages plugins.

---

## Everyday

| Keys | Action |
| --- | --- |
| `jk` | Escape (insert) |
| `<leader>e` | NetRW (`:Ex`) |
| `\` | Neo-tree reveal |
| `<leader>fs` | Save |
| `<leader>q` | Quit |
| `<leader>ff` | Find files (Telescope) |
| `<leader>fc` | Grep string (Telescope prompt) |
| `<C-p>` | Git files (Telescope) |
| `<leader>gg` | Neogit |
| `<leader><leader>` | `:source` current file |

---

## Windows and tabs

| Keys | Action |
| --- | --- |
| `<leader>ws` | Horizontal split |
| `<leader>wv` | Vertical split |
| `<leader>tt` | New tab |
| `<leader>tn` / `<leader>tp` | Next / previous tab |
| `<leader>tc` | Close tab |

---

## Harpoon

| Keys | Action |
| --- | --- |
| `<leader>a` | Add current file |
| `<C-e>` | Toggle menu |
| `<C-h>` `<C-t>` `<C-n>` `<C-s>` | Jump to file 1–4 |
| `<C-S-P>` / `<C-S-N>` | Previous / next in list |

---

## Editing

| Keys | Action |
| --- | --- |
| `<leader>cy` | Yank to system clipboard (normal/visual) |
| `<leader>cY` | Yank line to system clipboard |
| `<leader>cp` | Paste over selection without yanking (visual) |
| `<leader>x` | Delete without yanking |
| `<leader>ss` | Substitute word under cursor (prefilled) |
| `<leader>xx` | `chmod +x` current file |
| `J` | Toggle split/join (treesj) |
| `<C-a>` / `<C-x>` | Increment / decrement (dial) |
| `<leader>o` | Symbol outline |

Completion (insert): `<C-j>` / `<C-k>` next/prev, `<C-Space>` complete, `<CR>` confirm (no auto-select), `<C-e>` abort, `<C-b>` / `<C-f>` scroll docs. Snippet jumps: `<C-l>` next, `<C-h>` previous.

Command-line (`:`): path + cmdline completion. Search (`/` `?`): buffer completion.

---

## LSP (when a client is attached)

Always-on format: `<leader>vf` formats the buffer (normal) or selection (visual).

| Keys | Action |
| --- | --- |
| `gd` | Definition |
| `gi` | Implementation |
| `gu` | Incoming calls |
| `gr` / `<leader>vrr` | References |
| `K` | Hover |
| `<leader>vrn` | Rename |
| `<leader>vca` | Code action |
| `<leader>vws` | Workspace symbol |
| `<leader>vd` | Diagnostic float |
| `]d` / `[d` | Next / previous diagnostic |
| `<C-s>` | Signature help (insert) |

Mason auto-installs **lua_ls, clangd, jsonls, yamlls, bashls, marksman**. Other Mason-installed servers are enabled automatically except **grammarly**. `.vscode/launch.json` is picked up by DAP on demand.

---

## Debugger (`<leader>d…`)

Start with `<leader>ds` or `<leader>dc` (continue / start). UI opens on launch/attach and closes on exit. Virtual text shows values inline.

| Keys | Action |
| --- | --- |
| `<leader>dt` | Toggle breakpoint |
| `<leader>dC` | Conditional breakpoint |
| `<leader>dR` | Run to cursor |
| `<leader>di` `<leader>do` `<leader>du` `<leader>db` | Step into / over / out / back |
| `<leader>dp` | Pause |
| `<leader>de` | Evaluate (normal/visual) |
| `<leader>dE` | Evaluate typed expression |
| `<leader>dh` | Hover variables |
| `<leader>dS` | Scopes |
| `<leader>dr` | Toggle REPL |
| `<leader>dU` | Toggle DAP UI |
| `<leader>dd` | Disconnect |
| `<leader>dx` | Terminate |
| `<leader>dq` | Terminate + close UI |

Adapters Mason keeps installed: **cppdbg, codelldb, python (debugpy), coreclr, delve, js-debug**.

| Language | How to start | Notes |
| --- | --- | --- |
| C / C++ | Launch via **codelldb** or **cppdbg** (includes LLDB MI) | Prompt for the executable |
| Rust | **codelldb**; extra entries default to `target/debug/` | Needs a debug build |
| Python | Launch file / args / module, or attach `:5678` | Uses `$VIRTUAL_ENV`, then `venv` / `.venv` walking up from the file or cwd |
| JS / TS / Svelte | Node launch, `npx tsx`, npm script, attach, Chrome | Chrome URL defaults to `http://localhost:5173` |
| Go | Delve: package, args, test file, `go.mod` test | `--check-go-version=false` (Mason dlv vs older local Go) |
| C# | **netcoredbg** | Picks a `bin/Debug/**/*.dll` |

---

## Lists and git extras

| Keys | Action |
| --- | --- |
| `<C-j>` / `<C-k>` | Previous / next quickfix (centered) |
| `<leader>j` / `<leader>k` | Previous / next location list |
| `<leader>vs` / `<leader>vS` | Start / stop Vim With Me |

Neo-tree git pane and **git-conflict** are available when there are conflicts. Fugitive is installed; there is no `<leader>gs` map in the live config (only in `after/backups/`).

---

## Contest / C++ extras

| Keys | Action |
| --- | --- |
| `<leader>cfe` | Codeforces: `:EnterContest` (type contest id) |
| `<leader>cft` / `<leader>cfr` | Test / run current problem |
| `<leader>cfn` | Next problem |
| `<leader>cm` | cppman for word under cursor |
| `<leader>cc` | cppman search |

Codeforces files live under `~/codeforces`. C++ compile flags: `g++ -std=c++17 -O2`.

---

## Other maps and commands

| Keys / command | Action |
| --- | --- |
| `<leader>xr` | Cellular automaton rain |
| `<leader>fn` | Open a hardcoded old packer path (stale; not this repo) |
| `:MarkdownPreview` | Markdown preview (markdown buffers) |
| `:TypstPreview` | Typst preview |
| `:StartupTime` | Plugin startup profile |
| `:ThemeHub` | Theme browser (theme-hub.nvim) |
| `:Devcontainer*` | Devcontainer plugin commands |

Undotree is installed but **not mapped** in the live config.

---

## Options (short)

Relative numbers, 2-space tabs, no wrap, `colorcolumn` 120, persistent undo in `~/.vim/undodir`, no swap/backup, `scrolloff` 8, `updatetime` 50, always-on signcolumn, blinking bar cursor in insert.

---

## Useful commands when something is missing

```
:Mason
:LspInstall
:LspInfo
:DapContinue
:checkhealth
```
