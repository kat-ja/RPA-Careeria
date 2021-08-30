#'datetime_received': 'datetime_received': EWSDateTime(2021, 7, 27, 17, 57, 35, tzinfo=EWSTimeZone(key='UTC'))
#str =  "EWSDateTime(2021, 7, 27, 17, 57, 35, tzinfo=EWSTimeZone(key='UTC'))"

def parse_time(str):
    substr = str[11:-4]
    return substr
