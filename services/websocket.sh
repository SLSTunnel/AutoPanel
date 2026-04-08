#!/bin/bash

echo "[KING] Installing WebSocket Tunnel..."

pip3 install websockets

cat > /usr/local/bin/ws-tunnel.py <<EOF
import asyncio, websockets, socket

async def handler(ws):
    s = socket.socket()
    s.connect(("127.0.0.1",8080))

    async def ws_to_tcp():
        async for msg in ws:
            s.send(msg)

    async def tcp_to_ws():
        while True:
            data = s.recv(1024)
            if not data:
                break
            await ws.send(data)

    await asyncio.gather(ws_to_tcp(), tcp_to_ws())

asyncio.get_event_loop().run_until_complete(
    websockets.serve(handler, "127.0.0.1", 3000)
)
asyncio.get_event_loop().run_forever()
EOF

cat > /etc/systemd/system/ws.service <<EOF
[Unit]
Description=WebSocket Tunnel
After=network.target

[Service]
ExecStart=python3 /usr/local/bin/ws-tunnel.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reexec
systemctl enable ws
systemctl start ws
