from lib.server import Server
from lib.serial import Serial
import asyncio
import sys

async def main():
  server = Server(port=8000)
  serial = Serial(
    #port = "/dev/cu.usbmodem142111101",
    #port = "/dev/cu.usbmodem14201",
    port="DEMO",
    baudrate = 9600,
    to_serial = server.to_serial,
    from_serial = server.from_serial
  )
  
  await asyncio.gather(
    server.start(),
    serial.start(),
  )

asyncio.run(main())
