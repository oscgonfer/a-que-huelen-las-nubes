from lib.server import Server
from lib.serial import Serial
import asyncio
import sys
import time
import argparse
from lib.config import *

async def main(websockets_server_port, serial_port, baudrate):
    server = Server(port=websockets_server_port)
    serial = Serial(
        port=serial_port,
        baudrate=baudrate,
        to_serial=server.to_serial,
        from_serial=server.from_serial,
        timeout=SERIAL_TIMEOUT,
        osc_server=(OSC_IP, OSC_PORT, OSC_TOPIC)
    )

    await asyncio.gather(
        server.start(),
        serial.start(),
    )

if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument(
        "--port", type=str, default=SERIAL_PORT, help="Serial port"
    )

    parser.add_argument(
        "--baudrate", type=int, default=SERIAL_BAUDRATE, help="Serial port baudrate"
    )

    args = parser.parse_args()

    while True:
        try:
            asyncio.run(main(WEBSOCKETS_PORT, args.port, args.baudrate))
        except OSError:
            print("WARNING: Serial disconnected. Attempting to reconnect in 1 second...")
            time.sleep(1)
