'''
Aihe: RPA-lopputyö: OmaEtunimi OmaSukunimi
Viesti: Opettaja Etu Suku on lähettänyt minulle Etu Suku xx kpl sähköpostiviestejä. Tässä lista viesteistä:
HOKS-viestejä 9 kappaletta:
-Viesti 1 Päivämäärä: dd.mm.yyyy, Aihe: zzzz, Liitetiedostot: HOKS.xlsx, suunn.txt
-Viesti 2 Päivämäärä: dd.mm.yyyy, Aihe: zzzz, Liitetiedostot: HOKS.xlsx
Muita viestejä 89 kappaletta
-Viesti 3 Päivämäärä: dd.mm.yyyy, Aihe: zzzz, Ei liitetiedostoja

'''
my_dict = {
    'date': '10.08.2021',
    'time': '22:25:48',
    'subject': "10 Inspiring TED Talks That'll Boost Your Self-Confidence",
    'body': '<html><head>\r\n<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head><body><div dir="auto"><a href="https://blog.hubspot.com/marketing/ted-talks-confidence-boost">https://blog.hubspot.com/marketing/ted-talks-confidence-boost</a>&nbsp;</div></body></html>',
    'attachments': 'ei liitteitä',
    'hoks': 'other'
}

hoks_list = ['-Viesti 1 Päivämäärä: 27.07.2021, Aihe: Taas HOPS-juttuja, Liitetiedostot: catpic1.jpg, catpic3.jpg', '-Viesti 2 Päivämäärä: 27.07.2021, Aihe: Vähän HOKS-juttua, Liitetiedostot: catpic2.jpg',
             '-Viesti 3 Päivämäärä: 27.07.2021, Aihe: HOPS-asiaa, Liitetiedostot: catpic1.jpg', '-Viesti 4 Päivämäärä: 27.07.2021, Aihe: HOKS, Liitetiedostot: Ei liitetiedostoja', '-Viesti 5 Päivämäärä: 27.07.2021, Aihe: HOPS, Liitetiedostot: Ei liitetiedostoja']


def msg_to_send(dict, hoks_count, hoks_list, other_list):

    hoks_str = "\n".join(hoks_list)
    other_str = "\n".join(other_list)
    other_count = len(dict) - hoks_count

    return (f"Opettaja Etu Suku on lähettänyt minulle Etu Suku {len(dict)} kpl sähköpostiviestejä. Tässä lista viesteistä:",
            f"HOKS-viestejä {hoks_count} kappaletta:",
            f"{hoks_str}",
            f"Muita viestejä {other_count} kappaletta:"
            f"{other_str}"
            )


print(msg_to_send(my_dict, 4, hoks_list, hoks_list))

print("hello\nworld")
