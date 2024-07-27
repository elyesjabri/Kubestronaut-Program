FROM mcr.microsoft.com/powershell:latest

WORKDIR /app

ADD ["server.ps1", "/app/"]

SHELL ["pwsh","-Command"]

RUN Install-Module -Name Pode -Force

ENTRYPOINT ["pwsh","-File","/app/server.ps1"]
