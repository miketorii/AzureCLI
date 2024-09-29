import json

class DeviceInfo:
    def __init__(self):
        self.modelname = "init"
        self.serialnumber = "0"
        self.status = 0 
        
    def getDeviceInfo(self):
        deviceinfo = {"modelname": "iR-ADV C3300", "serialnumber": "80001235", "status": 10002}
        devinfojson = json.dumps(deviceinfo)
        return devinfojson

if __name__ == '__main__':
    dev = DeviceInfo()
    devinfo = dev.getDeviceInfo()
    print(devinfo)
    
