param ([String]$Path=".", [long]$MinimumSize = 0)
function Get-Docs ([string]$DocsPath=".") {
Get-ChildItem -Path $DocsPath `
-Include *.* `
-Recurse `
-ErrorAction SilentlyContinue
}
Get-Docs -DocsPath $path |
Where-Object { $_.length -ge $minimumsize } |
Select-Object FullName, LastAccessTime, Length |
Sort-Object -Descending Length |
Out-GridView