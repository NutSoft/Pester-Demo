function demo {
    [CmdletBinding()]
    param(
      [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [Object]$Config
    )
   
    # every config object should contain uri & message keys
    if (-not ($config.keys.contains('URI'))) { Throw 'Missing URI Key'}
    if (-not ($config.keys.contains('Message'))) { Throw 'Missing Message Key'}
   
    Write-Output 'All Good!'
  }