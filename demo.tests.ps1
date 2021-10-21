# the directory of demo.tests.ps1
$script_dir =  Split-Path -Parent $MyInvocation.MyCommand.Path
 
# load the script to test into memory
. "$script_dir\demo.ps1"
 
Describe 'Demo Function' {
  it 'throws an error when $config does not contain a URI key' {
    $params = @{
      notmykey = 'value'
    }
    { $params | demo } | Should Throw 'Missing URI Key'
  }
 
  it 'throws an error when $config does not contain a Message key' {
    $params = @{
      URI = 'https://demo'
    }
 
    { $params | demo } | Should Throw 'Missing Message Key'
  }
 
  it 'passes validation' {
    $params = @{
      URI = 'https://demo'
      Message = 'This is a test'
    }
 
    $params | demo | Should Be "All Good!"
  }
}