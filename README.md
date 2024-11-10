# A qué huelen las nubes

Code for installation at Recorreguts Sonors 2024, Convent de Sant Agusti, Barcelona.

## Usage

### Websockets-OSC-serial bridge

Serve the serial stuff over websockets (and optionally over OSC):

```python ws.py --port /dev/ttyACM0```

Replace `<port>` with the serial port for the arduino. The port should be something like `/dev/ttyACM0`

In `config.py` you can change some parameters, for instance the OSC server IP, port and topic, as well as the websockets server and port, and the serial port timeout.

To test the OSC client, you can use `socat` with the default parameters:

```socat UDP4-RECV:5000,reuseaddr,bind=127.0.0.1 STDOUT,nonblock=1```

### Fake newspaper server

To serve the page, run the app with:

```
python main.py
```

### Arduino side

Simply plug-in the arduino to the computer. With the code provided in `hardware`, it will send some random messages as an example.

## Acknowledgment

Main code based on: https://github.com/Project-Liquid/websockets-serial

Code for rendering a fake newspaper, taken from this codepel example: https://www.codepel.com/html-css/css-newspaper-layout-template/
