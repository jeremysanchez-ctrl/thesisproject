Set WshShell = CreateObject("WScript.Shell")

' 1. Start Next.js App Server on port 3000 (hidden)
WshShell.Run "powershell -ExecutionPolicy Bypass -WindowStyle Hidden -Command ""npm run dev""", 0, False

' Wait 4 seconds for Next.js to initialize
WScript.Sleep 4000

' 2. Start Ngrok Tunnel targeting domain trapezoid-perjury-courier.ngrok-free.dev (hidden)
WshShell.Run "powershell -ExecutionPolicy Bypass -WindowStyle Hidden -Command ""ngrok http --url=trapezoid-perjury-courier.ngrok-free.dev 3000""", 0, False

' Wait 2 seconds for tunnel connection
WScript.Sleep 2000

' 3. Open Admin Login in browser
WshShell.Run "cmd /c start http://localhost:3000/admin/login", 0, False
