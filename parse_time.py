#'datetime_received': 'datetime_received': EWSDateTime(2021, 7, 27, 17, 57, 35, tzinfo=EWSTimeZone(key='UTC'))
#str =  "EWSDateTime(2021, 7, 27, 17, 57, 35, tzinfo=EWSTimeZone(key='UTC'))"
'''
def parse_time2(str):
    substr = str[12:-32]
    dt_list = substr.split(', ')
    time = f"{dt_list[3]}:{dt_list[4]}:{dt_list[5]}"
    return time
'''


def parse_time(str):
    substr = str[11:-4]
    return substr
   

#parse_time('2021-08-10 22:25:48+00:00')