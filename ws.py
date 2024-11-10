from lib.server import Server
from lib.serial import Serial
import asyncio
import sys
import time
from lib.config import *

async def main(websockets_server_port, serial_port):
    server = Server(port=websockets_server_port)
    serial = Serial(
        port=serial_port,
        baudrate=9600,
        to_serial=server.to_serial,
        osc_server=(SUPERCOLLIDER_IP, SUPERCOLLIDER_PORT, SUPERCOLLIDER_TOPIC)
    )

    await asyncio.gather(
        server.start(),
        serial.start(),
    )

if __name__ == "__main__":
    websockets_server_port = WEBSOCKETS_PORT

    if len(sys.argv) > 1:
        serial_port = sys.argv[1]
    else:
        serial_port = "/dev/cu.usbmodem142111101"
        #serial_port = "/dev/cu.usbmodem14201"

    while True:
        try:
            asyncio.run(main(websockets_server_port, serial_port))
        except OSError:
            print("WARNING: Serial disconnected. Attempting to reconnect in 1 second...")
            time.sleep(1)
