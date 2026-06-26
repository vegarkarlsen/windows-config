# windows-config / powershell

Thin stub `$PROFILE` -> repo `profile.ps1` -> dot-sourced `profile.d/*` fragments.
No symlinks required, no module ceremony. Everything is just files that load in order.

## Layout

```
windows-config/
├── install.ps1                 # RUN ONCE per machine: stub $PROFILE, junction WT fragments,
│                               #   install PSGallery modules. Idempotent.
└── powershell/
    ├── profile.ps1             # entry point (dot-sourced by the stub). Sets $ConfigRoot /
    │                           #   $env:WINCONFIG, loads profile.d/* in order, starts prompt.
    ├── profile.d/              # dot-sourced EVERY session, in filename order
    │   ├── 00-env.ps1          #   EDITOR, PATH (idempotent Add-ToPath), STARSHIP_CONFIG
    │   ├── 10-modules.ps1      #   Import-Module (eager: prompt/keys/icons), PSReadLine vi
    │   ├── 20-aliases.ps1      #   real aliases only (n, e, open, activate, vim)
    │   ├── 30-overrides.ps1    #   built-in overrides (cd, ls, la, ll, cd.., Env:)
    │   ├── 40-unix-compat.ps1  #   Unix shims (grep, sed, touch, which, export, pkill, df...)
    │   ├── 50-functions.ps1    #   utility functions (Get-PubIP, Find-File, uptime, ln, unzip...)
    │   └── 60-quick-edit.ps1   #   Edit-* helpers, malias, Load-Tools (lazy loader)
    ├── bin/                    # standalone .ps1 tools, runnable by bare name if bin/ is on PATH
    │   └── hello.ps1
    ├── lazy/                   # situational tool sets, pulled in via  Load-Tools <name>
    │   └── example.ps1
    └── local-profile.example.ps1   # copy to local-profile.ps1 (gitignore) for per-machine paths
```

## Mental model

- **profile.d/** = everything, dot-sourced eagerly in order. Overrides, aliases, env, module
  imports, utility functions. Numeric prefixes control order; drop in a file and it loads.
- **bin/** = standalone scripts run by bare name (Linux `~/.local/bin` style). Put bin/ on PATH.
- **lazy/** = heavy/situational function sets you opt into with `Load-Tools`.

The module was removed deliberately: for this volume of small functions it was overkill, and
the line between "module functions" and "profile.d functions" wasn't meaningful. If a genuine
reusable, versioned library emerges later, `50-functions.ps1` is the thing to lift into a module.

## Linking without symlinks

This environment has no symlink rights, so:

| Thing | Mechanism | Why |
|-------|-----------|-----|
| `$PROFILE` (a file) | **stub** that dot-sources repo `profile.ps1` | no rights needed, editor-proof |
| WT Fragments (a dir) | **junction** | no admin needed, transparent to filesystem |
| nvim config etc. (dirs) | **junction** | same |
| Start Menu / app search | **shortcut (.lnk)** | how Windows Search discovers apps |
| a file in two places | **hardlink** (same volume) | last resort; some editors sever it on save |

## Install on a new machine

```powershell
git clone <repo> "$HOME\Documents\PowerShell\windows-config"
cd "$HOME\Documents\PowerShell\windows-config"
.\install.ps1
winget install Starship.Starship   # prompt, installed separately
# open a NEW shell
```

## Startup speed

The cost is in the eager module imports (Terminal-Icons, PSFzf, posh-git) and `starship init`,
NOT in the dot-sourced functions. Measure before optimizing:

```powershell
foreach ($m in 'Terminal-Icons','PSFzf','posh-git','git-aliases-plus') {
    "{0,-18} {1} ms" -f $m, [int](Measure-Command { Import-Module $m }).TotalMilliseconds
}
"starship init {0} ms" -f [int](Measure-Command { Invoke-Expression (&starship init powershell) }).TotalMilliseconds
```

If one or two modules dominate, defer those (e.g. load posh-git/PSFzf on first prompt) rather
than splitting functions into a module for lazy-loading.

## Key fixes vs the old config

- `$ConfigRoot` / `$env:WINCONFIG` single source of truth - fixes the
  `WindowsPowerShell`-vs-`PowerShell` STARSHIP_CONFIG path bug.
- `Add-ToPath` only appends if missing - no more PATH duplication on re-source.
- `install.ps1` is idempotent, targets `$PROFILE.CurrentUserAllHosts` explicitly, and writes a
  stub instead of a hardlink (no editor-severing).
- Bug fixes: `cd` uses `$HOME` not `$env:HOMEPATH`; `ln` `$targe` typo fixed; `unzip` works;
  `uptime` uses `Get-CimInstance` (PS7-safe); editor calls use `& $env:EDITOR` (handles spaces).

## .gitignore

```
local-profile.ps1
*.bak-*
```
