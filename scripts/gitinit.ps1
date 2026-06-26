
$default_gitignore = "
venv
"

Set-Content -Path "$PWD/.gitignore" -Value $default_gitignore
