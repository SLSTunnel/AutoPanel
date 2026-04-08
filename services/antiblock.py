import socket
s=socket.socket()
s.bind(('0.0.0.0',8080))
s.listen(5)
while True:
 c,a=s.accept()
 c.send(b"HTTP/1.1 200 OK\n\nOK")
 c.close()
