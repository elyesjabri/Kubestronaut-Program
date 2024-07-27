Start-PodeServer -ScriptBlock {
  Add-PodeEndpoint -Address 0.0.0.0 -Port 80 -Protocol Http

  Add-PodeRoute -Method Get -Path /home -ScriptBlock {
    Write-ProbeHtmlResponse -Value 'Hello from web application'
 }
}
