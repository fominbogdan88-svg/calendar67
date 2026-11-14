# Создаёт ярлык на рабочем столе. Путь определяется автоматически — папка может лежать где угодно.
$ws = New-Object -ComObject WScript.Shell
$desktop = [Environment]::GetFolderPath('Desktop')
$link = $ws.CreateShortcut("$desktop\Raspisanie.lnk")
$link.TargetPath = Join-Path $PSScriptRoot 'start-app.bat'
$link.WorkingDirectory = $PSScriptRoot
$link.WindowStyle = 7
$link.Description = 'Raspisanie online-urokov'
$link.Save()
Write-Host "Yarlyk sozdan: $desktop\Raspisanie.lnk"
