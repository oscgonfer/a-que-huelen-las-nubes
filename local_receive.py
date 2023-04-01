import asyncio
import websockets
import time

async def receive(websocket):
    while True:
        message = await websocket.recv()
        print(message)
        time.sleep(0.1)

#async def heartbeat(websocket):
    #while True:
    #    time.sleep(1)
    #    await websocket.send("LOG")

async def handle():
    uri = "ws://localhost:8000"
    async with websockets.connect(uri) as websocket:
        while True:
            message = await websocket.recv()
            print(message)
            time.sleep(0.1)


if __name__ == "__main__":
    asyncio.run(handle())
