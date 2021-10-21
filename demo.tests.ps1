# the directory of demo.tests.ps1
$script_dir = Split-Path -Parent $MyInvocation.MyCommand.Path
 
# load the script to test into memory
. "$script_dir\demo.ps1"
 
Describe 'Demo Function' {
    beforeEach {
        Mock Invoke-RestMethod { }
    }
 
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
 
    it 'the function calls my mocked declaration' {
        $params = @{
            URI     = 'https://demo'
            Message = 'This is a test'
        }
 
        $params | demo
 
        Assert-MockCalled 'Invoke-RestMethod' -Exactly 1 -Scope It
    }
 
    it 'the mocks parameters are now testable!' {
        $params = @{
            URI     = 'https://demo'
            Message = 'This is a test'
        }
 
        $params | demo
 
        Assert-MockCalled 'Invoke-RestMethod' -ParameterFilter { $URI -eq 'https://demo' } -Exactly 1 -Scope It
        Assert-MockCalled 'Invoke-RestMethod' -ParameterFilter { $Body -match 'This is a test' } -Exactly 1 -Scope It
    }
 
    it 'i can change the functionality of a mock to do pretty much anything' {
 
        # change Invoke-RestMethod to write the contents of $Body to stdout
        Mock Invoke-RestMethod {
            Write-Output $Body
        }
 
        $params = @{
            URI          = 'https://demo'
            Message      = 'This is a test'
            NewProperty1 = 'Value'
            NewProperty2 = 1
        }
 
        # store the output
        $output = $params | demo
 
        # Look, I can convert this to JSON
        $output_converted = $output | ConvertFrom-Json
 
        # and test the individual properties of the body!
        $output_converted.Message | Should Be 'This is a test'
        $output_converted.NewProperty1 | Should Be 'Value'
        $output_converted.NewProperty2 | Should Be 1
    }
 
    it 'the original mock is used' {
        $params = @{
            URI     = 'https://demo'
            Message = 'This is a test'
        }
 
        $params | demo | Should Be $null
 
        Assert-MockCalled 'Invoke-RestMethod' -ParameterFilter { $URI -eq 'https://demo' } -Exactly 1 -Scope It
        Assert-MockCalled 'Invoke-RestMethod' -ParameterFilter { $Body -match 'This is a test' } -Exactly 1 -Scope It
    }
}