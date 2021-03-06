import json
from datetime import datetime
import serial

class Gateway:
    """
    Gateway Class

    SUPPORT:
    JSON-only communication messages.

    FUNCTIONS:
    checksum()
    parse()
    reset()
    """
    def __init__(self, use_checksum=False, timeout=1, baud=38400, device="/dev/ttyACM0"):
        """
        Initialize the Gateway
        """
        # Get settings
        self.use_checksum = use_checksum
        self.device = device
        self.baud = baud
        self.timeout = timeout

        try:
            self.port = serial.Serial(self.device, self.baud, timeout=self.timeout)
        except Exception as e:
            self.port = None
            raise e

    def byteify(self, input):
        if isinstance(input, dict):
            return {self.byteify(key) : self.byteify(value) for key,value in input.iteritems()}
        elif isinstance(input, list):
            return [self.byteify(element) for element in input]
        elif isinstance(input, unicode):
            return input.encode('utf-8')
        else:
            return input

    def poll(self, chars=256, force_read=False): 
        s = self.port.readline()
        msg = self.byteify(json.loads(s)) # parse as JSON
        if self.use_checksum:
            chksum = self.checksum(msg['data'])
            if self.checksum(msg['data']) == msg['chksum']: # run checksum of parsed dictionary
                return msg # return data if checksum ok
            else:
                return None # return None if checksum failed
        else:
            return msg

    def checksum(self, data, mod=256, force_precision=2):
        """
        Calculate checksum
        """
        chksum = 0
        s = str(data)
        s_clean = s.replace(' ', '')
        for i in s_clean:
            chksum += ord(i)
        return chksum % mod

    def reset(self):
        pass
