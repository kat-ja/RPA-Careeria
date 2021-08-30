# kootaan ja muotoillaan lähetettävä viesti
def msg_to_send(dict, hoks_count, hoks_list, other_list, opettaja):
    # listat yhdistetään stringeiksi
    hoks_str = "<br>".join(hoks_list)
    other_str = "<br>".join(other_list)
    # muiden kuin hoks-viestien määrä
    other_count = len(dict) - hoks_count

    # muotoilu html-tageillä
    return f"<div><p>Opettaja {opettaja} on lähettänyt minulle {opettaja} {len(dict)} kpl sähköpostiviestejä. Tässä lista viesteistä:</p><p><u>HOKS-viestejä {hoks_count} kappaletta</u><p><p>{hoks_str}</p><p><u>Muita viestejä {other_count} kappaletta:</u></p><p>{other_str}</p></div>"
            

