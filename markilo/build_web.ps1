# Generar un número de versión único basado en la fecha y hora actual
$VERSION = Get-Date -Format "yyyyMMddHHmmss"

Write-Host "Versión generada: $VERSION"

# Limpiar compilaciones anteriores
flutter clean

# Compilar la aplicación con los parámetros adicionales
flutter build web --web-renderer html --release --base-href="/markilo/" --pwa-strategy=none --no-tree-shake-icons

# Reemplazar el número de versión en build\web\index.html
$IndexContent = Get-Content build\web\index.html -Raw

# Reemplazar la versión en la meta etiqueta de app-version
$PatternMetaVersion = 'content="VERSION_POR_REEMPLAZAR"'
$ReplacementMetaVersion = 'content="' + $VERSION + '"'
$IndexContent = $IndexContent -replace $PatternMetaVersion, $ReplacementMetaVersion

# Reemplazar swVersion en build\web\index.html
$PatternSwVersion = "swVersion = 'VERSION_POR_REEMPLAZAR'"
$ReplacementSwVersion = "swVersion = '$VERSION'"
$IndexContent = $IndexContent -replace $PatternSwVersion, $ReplacementSwVersion

# Guardar el contenido actualizado en el archivo index.html
Set-Content build\web\index.html -Value $IndexContent

# Emitir un beep al finalizar
[System.Console]::Beep(800, 500)
Write-Host "`a"

pause
