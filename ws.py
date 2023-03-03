from lib.server import Server
from lib.serial import Serial
import asyncio
import sys

async def main():
  server = Server(port=8000)
  serial = Serial("/dev/cu.usbmodem141111101", 9600,
    to_serial = server.to_serial,
    from_serial = server.from_serial
  )
  
  await asyncio.gather(
    server.start(),
    serial.start(),
  )

asyncio.run(main())
