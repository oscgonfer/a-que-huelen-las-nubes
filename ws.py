from lib.server import Server
from lib.serial import Serial
import asyncio
import sys
import time


async def main(server_port, serial_port):
    server = Server(port=server_port)
    serial = Serial(
        port=serial_port,
        baudrate=9600,
        to_serial=server.to_serial,
        from_serial=server.from_serial
    )

    await asyncio.gather(
        server.start(),
        serial.start(),
    )

if __name__ == "__main__":
    server_port = 8000
    if len(sys.argv) > 1:
        serial_port = sys.argv[1]
    else:
        serial_port = "/dev/cu.usbmodem142111101"
        #serial_port = "/dev/cu.usbmodem14201"

    while True:
        try:
            asyncio.run(main(server_port, serial_port))
        except OSError:
            print("WARNING: Serial disconnected. Attempting to reconnect in 1 second...")
            time.sleep(1)
