# Installation script for NASM(Netwide Assembler) on Windows

# 1. Installation  NASM
#    Skip this if NASM is already installed
$installedNasm = winget list NASM.NASM
if ($installedNasm -like "*NASM*") {
    Write-Output "NASM is already installed, skipping winget installation..."
} else {
    Write-Output "Installing NASM via winget..."
    winget install --id=NASM.NASM
}

# 2. Add NASM to PATH
$env:Path += ";%USERPROFILE%\AppData\Local\bin\NASM\"
Write-Output "NASM has been added to PATH."

# 3. Check if Visual Studio 2022 is installed
$vsInstances = Get-CimInstance MSFT_VSInstance -Namespace root/cimv2/vs -ErrorAction SilentlyContinue
$vs2022 = $vsInstances | Where-Object { $_.ElementName -match "Visual Studio (Community|Enterprise) 2022" }
if ($vs2022) {
    foreach ($instance in $vs2022) {
        $vsPath = $instance.InstallationPath
        Write-Output "Visual Studio 2022 has been detected at $vsPath."
    }
} else {
    Write-Error "Visual Studio 2022 is not installed. Please install Visual Studio 2022 to use the C/C++ compiler."
    Exit
}

# 4. Check if $vsInstance is either Community or Enterprise
#    Then, register it to the $PATH
if ($vs2022.ElementName -match "Community") {
    $vsEdition = "Community"
} elseif ($vs2022.ElementName -match "Enterprise") {
    $vsEdition = "Enterprise"
}

$env:Path += ";C:\Program Files\Microsoft Visual Studio\2022\$vsEdition\VC\Tools\MSVC\14.34.31933\bin\Hostx64\x64"
Write-Output "Visual Studio 2022 $vsEdition's MSVC toolkit has been added to $$PATH."

# 5. Register $LIB
$env:LIB = "C:\Program Files\Microsoft Visual Studio\2022\$vsEdition\VC\Tools\MSVC\14.34.31933\lib\x64;" +
           "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22000.0\ucrt\x64;" +
           "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22000.0\um\x64"
Write-Output "Visual Studio 2022 $vsEdition's MSVC toolkit has been added to $$LIB."

Write-Output "Installation complete. Please restart your terminal to apply changes and try your Assembly journey! >_<"