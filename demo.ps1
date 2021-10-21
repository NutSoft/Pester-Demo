function demo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Object]$Config
    )
   
    # every config object should contain uri & message keys
    if (-not ($config.keys.contains('URI'))) { Throw 'Missing URI Key' }
    if (-not ($config.keys.contains('Message'))) { Throw 'Missing Message Key' }
   
    # I'm just going to build a json body with the message in it.
    $body = @{
        Message = $Config.Message
    }
   
    # $config can have additional/optional properties
    # tack them to the body
    if ($Config.Keys.Count -gt 2) {
        $Config.Keys.Where({ $_ -ne 'URI' -and $_ -ne 'Message' }) |
        ForEach-Object { $body.add($_, $Config["$_"]) }
    }
   
    Invoke-RestMethod -Uri $Config.URI -Method Post -Body $($body | ConvertTo-Json -Depth 99) -UseBasicParsing
}