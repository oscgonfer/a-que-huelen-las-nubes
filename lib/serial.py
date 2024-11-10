import asyncio
import serial
import time
import random
import sys
import datetime
from pythonosc import udp_client

class Serial(object):
    def __init__(self, port, baudrate,
        to_serial: asyncio.Queue, from_serial: asyncio.Queue,
        timeout=0.001, osc_server= (None, None, None)):
        # Queues for communicating with server
        self.to_serial = to_serial
        self.from_serial = from_serial
        self.timeout = timeout  # serial timeout
        self.recording = False  # whether currently recording
        self.recorded_data = []  # holds buffered data between file writes
        self.recording_buffer_size = 30  # lines per file write
        self.filename = "REC_nodate.txt"
        if port == "DEMO":
            self.serial = Demo()
        else:
            self.serial = serial.Serial(port, baudrate, timeout=timeout)


        if any([param is None for param in osc_server]):
            print('No OSC started')
            self.osc_client = None
        else:
            self.osc_client = udp_client.SimpleUDPClient(osc_server[0], osc_server[1])
            self.osc_topic = osc_server[2]
            self.osc_client.send_message(self.osc_topic, "hello")

    def _readline_blocking(self) -> str:
        while self.serial.in_waiting == 0:
            time.sleep(self.timeout)
        return self.serial.readline().decode("utf-8").strip("\r\n")

    async def listen(self):
        while True:
            message = await asyncio.get_event_loop().run_in_executor(None, self._readline_blocking)
            print(f"Serial message: {message}")
            await self.from_serial.put(message)

            if self.osc_client is not None:
                self.osc_client.send_message(self.osc_topic, message+"\n")

            if self.recording:
                self.recorded_data.append(message)
                if len(self.recorded_data) > self.recording_buffer_size:
                    self.write_recording()

    def write_recording(self):
        try:
            with open("recordings/" + self.filename, 'a+') as f:
                for line in self.recorded_data:
                    f.write(line)
        except Exception as e:
            print(f"ERROR in file write: {e}")
        else:
            self.recorded_data = []

    def start_recording(self):
        self.filename = datetime.datetime.now().strftime(r"REC_%m-%d-%y_%H-%M-%S_%f.txt")
        self.recording = True

    def end_recording(self):
        self.write_recording()
        self.recording = False

    async def serverside_cmd(self, cmd):
        if (cmd == "NEW_REC"):
            if self.recording:
                await self.from_serial.put("ERRAlready recording!")
            else:
                self.start_recording()
                print(f"New recording: {self.filename}")
            await self.from_serial.put("SERREC_ON")
            await self.from_serial.put("SERREC_FILE=" + self.filename)
        elif (cmd == "END_REC"):
            if not self.recording:
                await self.from_serial.put("ERRNo in-progress recording to stop")
            else:
                print(f"End recording: {self.filename}")
                self.end_recording()
            await self.from_serial.put("SERREC_OFF")

        #print("SERVERSIDE: " + cmd)

    async def intercept_internal(self, message):
        if message.startswith("SER") and len(message) > 3:
            await self.serverside_cmd(message[3:])
            return True

    async def relay(self):
        # Gets data from the to_serial queue and sends it to the serial
        while True:
            message = await self.to_serial.get()
            if not await self.intercept_internal(message):
                # If not an internal message, send it to the serial
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


class Demo(object):
    def __init__(self):
        self.count = 150
        self.in_waiting = 1
    # def readline(self):
    #  self.count += random.randint(-int(self.count), 255-int(self.count)) / 10.
    #  time.sleep(0.1)
    #  if random.random() < 0.1:
    #      return "FIB" + f"Rare B message at count {int(self.count)}"
    #  return f"FIA{int(self.count)}"

    def readline(self) -> str:
        return input().encode('utf-8')

    def write(self, data):
        print(f"DEMO_MODE: {data}")
        # if data[:3] == "LOG":
        #    print(f"DEMO Log: {data[3:]}")
        # elif data[:3] == "ERR":
        #    print(f"DEMO Error: \033[31m{data[3:]}\033[0m")
        # elif data[:3] == "POK":
        #    print(f"INFO: Client just poked me. Not sure what to do about this.")
        # elif data[:3] == "EXT":
        #    print("Remote shutdown requested. Sabotaging self...")
        #    sys.exit(0)
        # else:
        #    print(f"Warning: got invalid data '{data}'")

    def __enter__(self): return self
    def __exit__(self): pass
