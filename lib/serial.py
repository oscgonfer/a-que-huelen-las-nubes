import asyncio
import serial
import time, random
import sys

class Demo(object):
  def __init__(self):
    self.count = 150
  def readline(self):
    self.count += random.randint(-int(self.count), 255-int(self.count)) / 10.
    time.sleep(0.1)
    if random.random() < 0.1:
        return "FIB" + f"Rare B message at count {int(self.count)}"
    return f"FIA{int(self.count)}"
  #def readline(self) -> str:
  #  return input()
  def write(self, data):
    if data[:3] == "LOG":
        print(f"DEMO Log: {data[3:]}")
    elif data[:3] == "ERR":
        print(f"DEMO Error: \033[31m{data[3:]}\033[0m")
    elif data[:3] == "POK":
        print(f"INFO: Client just poked me. Not sure what to do about this.")
    elif data[:3] == "EXT":
        print("Remote shutdown requested. Sabotaging self...")
        sys.exit(0)
    else:
        print(f"Warning: got invalid data '{data}'")

class Serial(object):
  def __init__(self, port, baudrate, to_serial: asyncio.Queue, from_serial: asyncio.Queue, timeout=1):
    self.to_serial = to_serial
    self.from_serial = from_serial
    self.timeout = timeout
    if port == "DEMO":
      self.serial = Demo()
    else:
      self.serial = serial.Serial(port, baudrate, timeout=timeout)
  def _readline_blocking(self) -> str:
    while self.serial.in_waiting == 0: time.sleep(self.timeout)
    return self.serial.readline().decode("utf-8")
  async def listen(self):
    while True:
      message = await asyncio.get_event_loop().run_in_executor(None, self._readline_blocking)
      print(f"Got: {message}")
      await self.from_serial.put(message)
  async def relay(self):
    while True:
      message = await self.to_serial.get()
      if message[-1] != '\n':
        message += '\n'
      self.serial.write(message.encode("utf-8"))
      self.to_serial.task_done()
  async def start(self):
    with self.serial:
      await asyncio.gather(
        self.relay(),
        self.listen()
      )
