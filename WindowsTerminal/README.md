# Windows Terminal Settings

Windows terminal settings can be configured partially in fragment files. The
Fragments folder needs to be located in `$ENV:LOCALAPPDATA\Windows Terminal\`.

The fragments files needs to be placed under a namespace folder such that an
`schemes.json` needs to be placed in `Fragments\<namespace>\schemes.json` in
order to load properly. The `<namspace>`s name does not matter.

More information about Windows Terminal fragment files can be found on [learn.microsoft.com](https://learn.microsoft.com/en-us/windows/terminal/json-fragment-extensions).

## Install

To install the config, the recommended way is to use Junction:

```ps1
New-Item -ItemType Junction -Path "$ENV:LOCALAPPDATA\Windows Terminal\Fragments" -Target 'Fragments'
```


