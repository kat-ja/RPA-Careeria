import re

def get_attachment_names(text):
    matches = re.findall("name='(.+?)', content_type", text)
    return matches

