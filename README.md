# A qué huelen las nubes

WIP!

Instalación para Recorreguts Sonors 2024.

## Acknowledgment

Main code based on: https://github.com/Project-Liquid/websockets-serial

Code for rendering a fake newspaper, taken from this codepel example: https://www.codepel.com/html-css/css-newspaper-layout-template/

## Usage

Serve the serial stuff over websockets:

```python ws.py <port>```

Replace `<port>` with the serial port for the arduino. The port should be something like `/dev/cu.ttyACM0`.

Then run the app:

```
python main.py
```

## Arduino side

Simply plug-in the arduino to the computer. With the code provided in `hardware`, it will send some random messages as an example.