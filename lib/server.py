import websockets
from websockets.server import WebSocketServerProtocol as Socket
from websockets.asyncio.server import serve
import asyncio


class Server(object):
    def __init__(self, ip = 'localhost', port=8000):
        self.from_serial = asyncio.Queue()
        self.to_serial = asyncio.Queue()
        self.ip = ip
        self.port = port
        self.connections = set()

    async def _transmit(self):
        while True:
            message = await self.from_serial.get()
            websockets.broadcast(self.connections, message)
            self.from_serial.task_done()

    async def _listen(self, socket: Socket):
        async for message in socket:
            await self.to_serial.put(message)

    async def _handler(self, socket: Socket):
        self.connections.add(socket)
        listener = asyncio.create_task(self._listen(socket))
        try:
            await socket.wait_closed()
        finally:
            self.connections.remove(socket)
            listener.cancel()

    async def _serve(self):
        async with serve(self._handler, self.ip, self.port) as server:
            print(f"Server started on {self.ip}:{self.port}.")
            await server.serve_forever()

    async def start(self):
        asyncio.gather(self._serve(), self._transmit())
