function send-sms {
<#
.SYNOPSIS

.DESCRIPTION

.PARAMETER

.INPUTS
Nothing can be piped directly into this function

.EXAMPLE

.EXAMPLE

.OUTPUTS

.NOTES
NAME: 
AUTHOR: 
LASTEDIT: 
KEYWORDS:

.LINK
http://www.messagenet.com.au/

#>
[CMDLetBinding()]
param
(
  [Parameter(mandatory=$true)] [String] $Username,
  [Parameter(mandatory=$true)] [String] $Password,
  [Parameter(mandatory=$true)] [String] $PhoneNumber,
  [Parameter(mandatory=$true)] [String] $Message,
  [System.Net.IWebProxy] $WebProxy,
  [String] $MessagenetAPIURL = 'http://www.messagenet.com.au/dotnet/Lodge.asmx/LodgeSMSMessage'
)

#check if we can access the upload values method
if ((Get-Command Send-WebPage -ErrorAction silentlycontinue) -eq $null) 
{
	throw "Could not find the function Send-WebPage"
}

if ($message.length -gt 140)
{
	throw "message greater than 140 characters!"
}

#collection containing the parameters we will be sending
$reqparams = New-Object System.Collections.Specialized.NameValueCollection

#add the mandatory parameters (token, user identifier and the message)
$reqparams.Add("Username",$Username)
$reqparams.Add("Pwd",$Password)
$reqparams.Add("PhoneNumber",$PhoneNumber)
$reqparams.Add("PhoneMessage",$Message)


$headers = New-Object System.net.webheadercollection
$headers.Add("Content-Type", "application/x-www-form-urlencoded")

#send the request to the pushover server, capture the response, throw any error
try 
{
	Write-Verbose "Sending message: $message, to mobile $phonenumber"
	$response = Send-WebPage -URL $MessagenetAPIURL -Values $reqparams -Headers $headers -WebProxy $WebProxy
} 
catch 
{
	throw $_
}

#write the response in full for vebose output
Write-Verbose " Writing response:"
Write-Verbose "--------------------"
Write-Verbose "$response"
Write-Verbose "--------------------"

#convert response to xml
$xmlresponse = [xml]$response

#return response code 
return $xmlresponse.string.'#text'

}
