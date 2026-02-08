# Limpiar compilaciones anteriores
flutter clean

# Compilar la aplicación con los parámetros adicionales
flutter build apk --release --no-tree-shake-icons

# Emitir un beep al finalizar
[System.Console]::Beep(800, 500)
Write-Host "`a"

pause
