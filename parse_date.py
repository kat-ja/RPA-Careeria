#'datetime_received': 'datetime_received': EWSDateTime(2021, 7, 27, 17, 57, 35, tzinfo=EWSTimeZone(key='UTC'))
#str1 =  "EWSDateTime(2021, 7, 27, 17, 57, 35, tzinfo=EWSTimeZone(key='UTC'))"
'''
def parse_date2(str):
    substr = str[12:-32]
    dt_list = substr.split(', ')
    date = f"{dt_list[2]}.{dt_list[1]}.{dt_list[0]}"
    return date
'''


#print(parse_date(str1))

#2021-08-10 22:25:48+00:00
def parse_date(str):
    substr = str[0:-13]
    dt_list = substr.split('-')
    date = f"{dt_list[2]}.{dt_list[1]}.{dt_list[0]}"
    return date


