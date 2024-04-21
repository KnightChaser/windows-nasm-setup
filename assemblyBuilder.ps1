# Automatic Assembly Builder Script

param (
    [Parameter(Mandatory=$true)]
    [string]$source,
    [Parameter(Mandatory=$true)]
    [string]$entry,
    [string]$leaveObjFile  # Optional parameter
)

# Check if NASM is installed
try {
    $nasmVersion = nasm -v
    if (-not $nasmVersion) {
        throw "NASM not found"
    }
} catch {
    Write-Error "NASM is not installed. Please install NASM to use the Assembly builder."
    Exit
}

# Build Assembly
nasm -f win64 $source
link /subsystem:console /entry:$entry ($source -replace "\.asm$", ".obj") kernel32.lib

# Remove the .obj file if $leaveObjFile is not provided
if ($null -eq $leaveObjFile) {
    Remove-Item ($source -replace "\.asm$", ".obj")
}

# Correct the output message to properly display the output path
$outputExe = $source -replace "\.asm$", ".exe"
Write-Output "Assembly build complete, output file: $outputExe"
