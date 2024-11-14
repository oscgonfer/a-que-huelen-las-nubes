import mido
from os import environ
from pythonosc import udp_client


OSC_HOST = environ["OSC_HOST"]
OSC_PORT = int(environ["OSC_PORT"])

MIDI_CONTROLLER_NAME="EV-XS USB MIDI Controller:EV-XS USB MIDI Controller MIDI  28:0"
MIDI_CHANNEL=0
MIDI_CC=9

client = udp_client.SimpleUDPClient(OSC_HOST, OSC_PORT)
with mido.open_input(MIDI_CONTROLLER_NAME) as input:
    for message in input:
        if message.channel == MIDI_CHANNEL and message.control == MIDI_CC:
            key = "/nubes/user_threshold"
            value= message.value / 127.0
            print(key, value)
            client.send_message(key, value)
        if message.channel == MIDI_CHANNEL and message.control == 1:
            key = "/sck/light"
            value= message.value / 127.0 * 15000
            print(key, value)
            client.send_message(key, value)
