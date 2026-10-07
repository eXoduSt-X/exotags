function Resolve-Symlinks {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string] $Path
    )

    if ([string]::IsNullOrWhiteSpace($Path)) {
        Write-Error "Resolve-Symlinks: path vacío"
        exit 1
    }

    [string] $separator = '/'
    [string[]] $parts = $Path.Split($separator)

    [string] $realPath = ''
    foreach ($part in $parts) {
        if ($realPath -and !$realPath.EndsWith($separator)) {
            $realPath += $separator
        }
        $realPath += $part
        try {
            $item = Get-Item -LiteralPath $realPath -ErrorAction Stop
            if ($item.Target) {
                $target = $item.Target
                if ($target -is [array]) { $target = $target[0] }
                $realPath = $target.Replace('\', '/')
            }
        } catch {
            # Segmento no encontrado / no es symlink / error de permisos:
            # seguimos construyendo el path tal cual.
        }
    }
    $realPath
}

$path = Resolve-Symlinks -Path $args[0]
Write-Host $path