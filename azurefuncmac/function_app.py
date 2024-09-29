import azure.functions as func
import datetime
import json
import logging

app = func.FunctionApp()

####################################################################
#
# GetVersion
#
@app.route(route="GetVersion", auth_level=func.AuthLevel.ANONYMOUS)
def GetVersion(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('--GetVersion---')

    return func.HttpResponse(
       "V0,8.0",
       status_code=200
    )

####################################################################
#
# GetDeviceInfo
#
@app.route(route="GetDeviceInfo", auth_level=func.AuthLevel.ANONYMOUS)
def GetDeviceInfo(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('--GetDeviceInfo---')

    deviceinfo = {"modelname": "iR-ADV C5500", "serialnumber": "80001234", "status": 10001}
    body = json.dumps(deviceinfo)

    return func.HttpResponse(
        body,
        mimetype="application/json",
        status_code=200
    )



    
