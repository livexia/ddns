import requests
import socket
import sys
from contextlib import closing

def get_local_ipv6():
    with socket.socket(socket.AF_INET6, socket.SOCK_DGRAM) as s:
        s.connect(("2409:8a28:46a:4100::1", 80))
        return s.getsockname()[0]

def updater_he(hostname, key, ip):
    he_url = 'https://{0}:{1}@dyn.dns.he.net/nic/update?hostname={0}&myip={2}'.format(hostname, key , ip)
    res = requests.get(he_url, timeout = 10)
    if(not res.ok):
        print("Update faliure: {}".format(res.text))
        return updater_he(hostname, key, ip)
    else:
        print("Update success: {}".format(res.text))


if __name__ == "__main__":
    if(len(sys.argv) != 4):
        print("Usage: python ddns.py [hostname] [key] [ip]")
    else:
        hostname, key, ip = tuple(sys.argv[1:])
        updater_he(hostname, key, ip)
