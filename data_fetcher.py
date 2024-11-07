from collections import defaultdict
from datetime import datetime, timedelta
from os import environ
import asyncio
import requests
from pythonosc import udp_client

SC_URL = environ["SC_URL"]
GENE_URL = environ["GENE_URL"]
GENE_STATION_NAME = environ["GENE_STATION_NAME"]
OSC_HOST = environ["OSC_HOST"]
OSC_PORT = int(environ["OSC_PORT"])
SC_WAIT_TIME=int(environ["SC_WAIT_TIME"])
GENE_WAIT_TIME=int(environ["GENE_WAIT_TIME"])


async def get_sc_data(client):
    while True:
        json = requests.get(SC_URL).json()
        for sensor in json["data"]["sensors"]:
            key = "/sck/%s" % sensor["default_key"]
            value = sensor["value"]
            print(key, value)
            client.send_message(key, value)
        await asyncio.sleep(SC_WAIT_TIME)

async def get_gene_data(client):
    while True:
        hours = range(1,25)
        json = requests.get(GENE_URL).json()
        stats = defaultdict(list)
        for row in json:
            if row["nom_estacio"] == GENE_STATION_NAME:
                for hour in hours:
                    hour_col = "h%02d" % hour
                    if hour_col in row and row[hour_col] is not None:
                        dt = datetime.fromisoformat(row["data"]) + timedelta(hours=int(hour))
                        value = row[hour_col]
                        stats[row["contaminant"].lower()].append({"hora": dt, "valor": float(value) })
        for contaminant in stats:
            time_series = sorted(stats[contaminant], key=lambda row: row["hora"])
            key = "/gene/%s" % contaminant
            value = time_series[-1]["valor"]
            print(key, value)
            client.send_message(key, value)
        await asyncio.sleep(GENE_WAIT_TIME)

async def main():
    client = udp_client.SimpleUDPClient(OSC_HOST, OSC_PORT)
    await asyncio.gather(get_sc_data(client), get_gene_data(client))

asyncio.run(main())
