# Aliase Functiones

# virtualBox management alias ##
# function activate-virtualBox {
#     VBoxHeadless.exe -s "Mint20_64-20211222 1"
#     # VBoxManage.exe startvm "Mint20_64-20211222 1" --type headless
# }

# get-childitem command alias
function la {
    Get-ChildItem -Force
}

function ll {
    param ()  
    Get-ChildItem | ForEach-Object { $_.Name }
}

# git proxy setting  
function git-set-proxy {
    git config --global http.proxy http://wwwproxy.kanazawa-it.ac.jp:8080
}

function git-unset-proxy {
    git config --global --unset http.proxy
}

# pip proxy setting
function pip-set-proxy{
    pip config set global.proxy http://wwwproxy.kanazawa-it.ac.jp:8080
}

function pip-unset-proxy{
    pip config unset global.proxy
}

# npm proxy setting
function npm-set-proxy{
    npm config set proxy http://wwwproxy.kanazawa-it.ac.jp:8080
    # npm config set proxy https://wwwproxy.kanazawa-it.ac.jp:8080
}
function npm-unset-proxy{
    npm config delete proxy
}

function set-proxy-variable{
    $env:HTTP_PROXY = "http://wwwproxy.kanazawa-it.ac.jp:8080"
    $env:HTTPS_PROXY = "http://wwwproxy.kanazawa-it.ac.jp:8080"
}

function unset-proxy-variable {
    Remove-Item -Path Env:\HTTP_PROXY
    Remove-Item -Path Env:\HTTPS_PROXY
}

# for updateing "md-to-pdf" command 
## START ##
# function update-md-to-pdf {
#     $MDF="C:\Users\moyas\md-to-pdf"
#     cd 'C:\Users\moyas\md-to-pdf'
#     git pull
#     npm run build
# }

# gcc command alias
# Set-Alias -Name gcc -Value "gcc -finput-charset=utf-8 -fexec-charset-cp932 -g"
# function gcc{
#     param()
#     gcc.exe -finput-charset=utf-8 -fexec-charset=cp932 -g
# }
# Set-Alias -Name gcc -Value 'gcc.exe -finput-charset=utf-8 -fexec-charset=cp932 -g'

# Cammand Aliases
Set-Alias -Name touch -Value New-Item

# Bash like completion
Set-PSReadLineKeyHandler -Key Tab -Function Complete

# Update bash like completion app
# Install-Module -Name PSReadLine -Force

# Start bash when startup
# bash

# Import Auto complete app for git commandes
Import-Module posh-git

# Auto update when startup powershell
# もしgit command の updateをしたかったら以下のコマンドレットをコメントアウトして
# Write-Output "git command auto complete modules update ongoing"
# Update-Module -Name posh-git -AllowPrerelease
# Write-Output "process all complete!"

# Prompt settings
function prompt {
  "PS " + $(get-location) + "`n> "
}

# java command alias
function javac {
    javac.exe -encoding utf-8 $Args[0]
}

# Set-Alias -Name "javac" -Value "javac.exe -encoding utf-8"
# powershell completion for arduino-cli                          -*- shell-script -*-

# 以下のコードはarduino-cli.exeによって生成されたコマンド補完機能を提供するものである。

function __arduino-cli_debug {
    if ($env:BASH_COMP_DEBUG_FILE) {
        "$args" | Out-File -Append -FilePath "$env:BASH_COMP_DEBUG_FILE"
    }
}

filter __arduino-cli_escapeStringWithSpecialChars {
    $_ -replace '\s|#|@|\$|;|,|''|\{|\}|\(|\)|"|`|\||<|>|&','`$&'
}

Register-ArgumentCompleter -CommandName 'arduino-cli' -ScriptBlock {
    param(
            $WordToComplete,
            $CommandAst,
            $CursorPosition
        )

    # Get the current command line and convert into a string
    $Command = $CommandAst.CommandElements
    $Command = "$Command"

    __arduino-cli_debug ""
    __arduino-cli_debug "========= starting completion logic =========="
    __arduino-cli_debug "WordToComplete: $WordToComplete Command: $Command CursorPosition: $CursorPosition"

    # The user could have moved the cursor backwards on the command-line.
    # We need to trigger completion from the $CursorPosition location, so we need
    # to truncate the command-line ($Command) up to the $CursorPosition location.
    # Make sure the $Command is longer then the $CursorPosition before we truncate.
    # This happens because the $Command does not include the last space.
    if ($Command.Length -gt $CursorPosition) {
        $Command=$Command.Substring(0,$CursorPosition)
    }
	__arduino-cli_debug "Truncated command: $Command"

    $ShellCompDirectiveError=1
    $ShellCompDirectiveNoSpace=2
    $ShellCompDirectiveNoFileComp=4
    $ShellCompDirectiveFilterFileExt=8
    $ShellCompDirectiveFilterDirs=16

	# Prepare the command to request completions for the program.
    # Split the command at the first space to separate the program and arguments.
    $Program,$Arguments = $Command.Split(" ",2)
    $RequestComp="$Program __completeNoDesc $Arguments"
    __arduino-cli_debug "RequestComp: $RequestComp"

    # we cannot use $WordToComplete because it
    # has the wrong values if the cursor was moved
    # so use the last argument
    if ($WordToComplete -ne "" ) {
        $WordToComplete = $Arguments.Split(" ")[-1]
    }
    __arduino-cli_debug "New WordToComplete: $WordToComplete"


    # Check for flag with equal sign
    $IsEqualFlag = ($WordToComplete -Like "--*=*" )
    if ( $IsEqualFlag ) {
        __arduino-cli_debug "Completing equal sign flag"
        # Remove the flag part
        $Flag,$WordToComplete = $WordToComplete.Split("=",2)
    }

    if ( $WordToComplete -eq "" -And ( -Not $IsEqualFlag )) {
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go method.
        __arduino-cli_debug "Adding extra empty parameter"
        # We need to use `"`" to pass an empty argument a "" or '' does not work!!!
        $RequestComp="$RequestComp" + ' `"`"'
    }

    __arduino-cli_debug "Calling $RequestComp"
    #call the command store the output in $out and redirect stderr and stdout to null
    # $Out is an array contains each line per element
    Invoke-Expression -OutVariable out "$RequestComp" 2>&1 | Out-Null


    # get directive from last line
    [int]$Directive = $Out[-1].TrimStart(':')
    if ($Directive -eq "") {
        # There is no directive specified
        $Directive = 0
    }
    __arduino-cli_debug "The completion directive is: $Directive"

    # remove directive (last element) from out
    $Out = $Out | Where-Object { $_ -ne $Out[-1] }
    __arduino-cli_debug "The completions are: $Out"

    if (($Directive -band $ShellCompDirectiveError) -ne 0 ) {
        # Error code.  No completion.
        __arduino-cli_debug "Received error from custom completion go code"
        return
    }

    $Longest = 0
    $Values = $Out | ForEach-Object {
        #Split the output in name and description
        $Name, $Description = $_.Split("`t",2)
        __arduino-cli_debug "Name: $Name Description: $Description"

        # Look for the longest completion so that we can format things nicely
        if ($Longest -lt $Name.Length) {
            $Longest = $Name.Length
        }

        # Set the description to a one space string if there is none set.
        # This is needed because the CompletionResult does not accept an empty string as argument
        if (-Not $Description) {
            $Description = " "
        }
        @{Name="$Name";Description="$Description"}
    }


    $Space = " "
    if (($Directive -band $ShellCompDirectiveNoSpace) -ne 0 ) {
        # remove the space here
        __arduino-cli_debug "ShellCompDirectiveNoSpace is called"
        $Space = ""
    }

    if ((($Directive -band $ShellCompDirectiveFilterFileExt) -ne 0 ) -or
       (($Directive -band $ShellCompDirectiveFilterDirs) -ne 0 ))  {
        __arduino-cli_debug "ShellCompDirectiveFilterFileExt ShellCompDirectiveFilterDirs are not supported"

        # return here to prevent the completion of the extensions
        return
    }

    $Values = $Values | Where-Object {
        # filter the result
        $_.Name -like "$WordToComplete*"

        # Join the flag back if we have an equal sign flag
        if ( $IsEqualFlag ) {
            __arduino-cli_debug "Join the equal sign flag back to the completion value"
            $_.Name = $Flag + "=" + $_.Name
        }
    }

    if (($Directive -band $ShellCompDirectiveNoFileComp) -ne 0 ) {
        __arduino-cli_debug "ShellCompDirectiveNoFileComp is called"

        if ($Values.Length -eq 0) {
            # Just print an empty string here so the
            # shell does not start to complete paths.
            # We cannot use CompletionResult here because
            # it does not accept an empty string as argument.
            ""
            return
        }
    }

    # Get the current mode
    $Mode = (Get-PSReadLineKeyHandler | Where-Object {$_.Key -eq "Tab" }).Function
    __arduino-cli_debug "Mode: $Mode"

    $Values | ForEach-Object {

        # store temporary because switch will overwrite $_
        $comp = $_

        # PowerShell supports three different completion modes
        # - TabCompleteNext (default windows style - on each key press the next option is displayed)
        # - Complete (works like bash)
        # - MenuComplete (works like zsh)
        # You set the mode with Set-PSReadLineKeyHandler -Key Tab -Function <mode>

        # CompletionResult Arguments:
        # 1) CompletionText text to be used as the auto completion result
        # 2) ListItemText   text to be displayed in the suggestion list
        # 3) ResultType     type of completion result
        # 4) ToolTip        text for the tooltip with details about the object

        switch ($Mode) {

            # bash like
            "Complete" {

                if ($Values.Length -eq 1) {
                    __arduino-cli_debug "Only one completion left"

                    # insert space after value
                    [System.Management.Automation.CompletionResult]::new($($comp.Name | __arduino-cli_escapeStringWithSpecialChars) + $Space, "$($comp.Name)", 'ParameterValue', "$($comp.Description)")

                } else {
                    # Add the proper number of spaces to align the descriptions
                    while($comp.Name.Length -lt $Longest) {
                        $comp.Name = $comp.Name + " "
                    }

                    # Check for empty description and only add parentheses if needed
                    if ($($comp.Description) -eq " " ) {
                        $Description = ""
                    } else {
                        $Description = "  ($($comp.Description))"
                    }

                    [System.Management.Automation.CompletionResult]::new("$($comp.Name)$Description", "$($comp.Name)$Description", 'ParameterValue', "$($comp.Description)")
                }
             }

            # zsh like
            "MenuComplete" {
                # insert space after value
                # MenuComplete will automatically show the ToolTip of
                # the highlighted value at the bottom of the suggestions.
                [System.Management.Automation.CompletionResult]::new($($comp.Name | __arduino-cli_escapeStringWithSpecialChars) + $Space, "$($comp.Name)", 'ParameterValue', "$($comp.Description)")
            }

            # TabCompleteNext and in case we get something unknown
            Default {
                # Like MenuComplete but we don't want to add a space here because
                # the user need to press space anyway to get the completion.
                # Description will not be shown because thats not possible with TabCompleteNext
                [System.Management.Automation.CompletionResult]::new($($comp.Name | __arduino-cli_escapeStringWithSpecialChars), "$($comp.Name)", 'ParameterValue', "$($comp.Description)")
            }
        }

    }
}

## ここまでがarduino-cli.exeの設定である

# powershell profile
# powershell -File C:\Users\moyas\OneDrive\ドキュメント\WindowsPowerShell\Microsoft.PowerShell_profile.ps1

# chcp 932
chcp 65001


# Set-Alias -Name gcc -Value "gcc -finput-charset=utf-8 -fexec-charset-cp932 -g"

# virtualenvが使いにくいのでその起動用のスクリプト

# pipが最新かどうか判定する関数,最新の時はTrueを返す

function Is-PipUpToDate {
    $currentPipVersion = pip --version | Out-String
    $latestPipVersion = (pip list -o | Select-Object -First 1).Version

    if ($currentPipVersion -match $latestPipVersion) {
        return $true
    } else {
        Write-Host "pip is old version. Installed version: $currentPipVersion, Latest version: $latestPipVersion"
        return $false
    }
}

function activate-venv {
    if (-Not (Test-Path .\.venv)) {
        uv venv
    }
    .\.venv\Scripts\activate
}


# virtualenv aliases
function va {
    activate-venv
}
function da {
    deactivate
}

# set proxy git and pip

function set-proxy {
    git-set-proxy
    pip-set-proxy
    npm-set-proxy
    set-proxy-variable
}

function unset-proxy {
    git-unset-proxy
    pip-unset-proxy
    npm-unset-proxy
    unset-proxy-variable
}

# Install from PowerShell Gallery
# Install-Module DockerCompletion -Scope CurrentUser
# Import
Import-Module DockerCompletion

# Pythonのエンコーディングをutf-8に指定
$env:PYTHONIOENCODING = "utf-8"

# oh-my-poshの設定
# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/craver.omp.json" | Invoke-Expression

# Powershellの出力値をutf-8に修正
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
