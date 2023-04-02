# websockets-serial
Python-based websockets server that relays messages through the serial port

## Requirements
This needs python >=3 and the python modules `websockets` and `serial`. Install those before proceeding.

Using pip: (note: if your `python` command is python 2, and you use `python3`, replace `python` with `python3` below)
```
python -m pip install pyserial
python -m pip install websockets
```
Or using conda: (optionally, if your python was installed with anaconda)
```
conda install -c conda-forge pyserial
conda install -c conda-forge websockets
```

Also, make sure you're using python around 3.7 or higher (this is not tested on ancient python, nor will the libraries likely work).
Please note that a websockets _client_ connection will probably require a browser that is not Google Chrome, which (justifiably) blocks unsecured websockets connections to localhost. We require an unsecured websockets connection to localhost in order to get information between the browser's virtual machine environment and the rest of the computer.

## Usage
To start the server, run: (again, if you use the `python3` command, do that)
```python ws.py <port>```

Replace `<port>` with the serial port for the arduino. The port should be something like `/dev/cu.usbmodem141111101` and can be found by running:
```
python -m serial.tools.list_ports
```
This requires you to have the `serial` python module installed (see Requirements).

To set the port for the websockets server, edit `ws.py` and replce the `server_port` variable.

## Notes
This is only the websockets server. It doesn't provide a client user interface, it just opens a serial port up to the network. It also doesn't assume anything about the device it's talking to over serial. For arduino code, see [arduino-onboard](https://github.com/Project-Liquid/arduino-onboard). For a web-based client user interface, see [control-panel-web](https://github.com/Project-Liquid/control-panel-web).

