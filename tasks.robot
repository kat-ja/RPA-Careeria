*** Settings ***
Documentation   Read Exchange mail messages, make a table of specific messages and send that information to user.

Library         RPA.Email.Exchange
Library         RPA.Dialogs
Library         String
Library         Collections
Library         RPA.Tables
Library         DateTime
Library         RPA.Excel.Files
Library         RPA.Browser.Selenium
Library         RPA.Dialogs

Library         parse_date.py
Library         parse_time.py
Library         get_attachment_names.py
Library         msg_to_send.py

Task Setup      Dialog For Credentials   


*** Variables ***
${ACCOUNT}    ${EMPTY}   
${PASSWORD}    ${EMPTY}   
${hoks}=    other
${RECIPIENT_ADDRESS}    katja.valanne@gmail.com
${OPETTAJA}    Katja Valanne


*** Keywords ***
Dialog For Credentials
    Create Form    title=Credentials
    Add text input    label=Username    name=user    
    Add password input    label=Password    name=password    
    &{response}    Request Response    window_height=550
    ${ACCOUNT}=    Set Variable    ${response}[user] 
    ${PASSWORD}=    Set Variable    ${response}[password]
    Authorize    username=${ACCOUNT}    password=${PASSWORD}  # exhange-librarystä


*** Tasks ***
Mail Messages From Specific Sender To Table

    ${messages}=    List Messages
    @{hoks_list}=    Create list
    @{other_list}=    Create List
    ${table}=    Create Table
    ${hoks_table}=    Create Table 
    ${hoks_table_str}=    Set Variable    ${EMPTY}
    ${other_table}=    Create Table
    ${other_table_str}=    Set Variable     ${EMPTY}
    Add table column    ${table}    name=date
    Add table column    ${table}    name=time
    Add table column    ${table}    name=subject
    Add table column    ${table}    name=body
    Add table column    ${table}    name=attachments
    Add table column    ${table}    name=hoks
    ${hoks_count}=    Set Variable    ${0}
    
    FOR    ${msg}    IN    @{messages}
        ${match}=    Get Regexp Matches    ${msg}[sender][name]    ${OPETTAJA}   # opettajalta tulleet viestit  
        ${match_HOPS}=    Get Regexp Matches    ${msg}[subject]    HOPS|HOKS     # hoks-viestit
        ${match_len}=    Get Length    ${match}
        ${match_HOPS_len}=    Get Length    ${match_HOPS}

        IF    ${match_HOPS_len} > 0    # merkitään hoks-viestit ja muut viestit
            ${hoks}=    Set Variable    hoks         
        ELSE    
            ${hoks}=    Set Variable    other
        END

        ${attachments_len}=   Get Length    ${msg}[attachments_object] 

        IF    ${match_len} > 0    # jos viesti on opettajalta
            IF    ${attachments_len} > 0    # jos viestissä on liitteitä
                ${text}=   Convert To String    ${msg}[attachments_object]    # attachments_object stringiksi, jotta nimet saadaan erotettua
                ${attachment_names}=    Get Attachment Names    ${text}    # erotetaan attachment_names        
                ${attachment_names_str}=    Catenate    SEPARATOR=, ${EMPTY}    @{attachment_names}    # yhdistetään nimet pilkulla
            ELSE    
                ${attachment_names_str}=    Set variable    Ei liitetiedostoja    # jos ei ole liitteitä, attachments_objectin pituus on 0
            END

            ${str_date_time}=    Convert Date    ${msg}[datetime_received]    # datetime stringiksi, jotta saadaan erotettua päivä ja kellonaika
            ${date}=    Parse Date    ${str_date_time}
            ${time}=    Parse Time    ${str_date_time}
            &{mail_dict}=    Create Dictionary    date=${date}    time=${time}    subject=${msg}[subject]    body=${msg}[body]    attachments=${attachment_names_str}    hoks=${hoks}   # kootaan viestin tiedot dictionaryksi
            Add Table Row    ${table}    ${mail_dict}    # lisätään dictionary rivinä tableen
        END     
    END
 
    # erotetaan hoks_table ja other_table, koska lähetettävässä viestissä pitää erotella hoks-viestit ja muut viestit
    @{hoks_table}=    Find Table Rows    ${table}    hoks    hoks
    @{other_table}=    Find Table Rows    ${table}    hoks    other


    FOR    ${row}    IN    @{hoks_table}
# lasketaan hoks-viestin lukumäärää
        ${hoks_count}=    Set Variable    ${hoks_count + 1}
# vain 2 välilyöntiä SEPARATOR jälkeen tarkoittaa ei mitään! 
# yhdistetään viestin tiedot stringiksi   
        ${hoks_table_str}=    Catenate    SEPARATOR=  -Viesti${SPACE}   ${hoks_count}${SPACE}   Päivämäärä:${SPACE}   ${row}[date]  , Aihe:${SPACE}   ${row}[subject]  , Liitetiedostot:${SPACE}   ${row}[attachments]
# lisätään string listaan
        Append To List    ${hoks_list}    ${hoks_table_str}
    END

# tehtävänannon mukaan muut viestit numeroidaan jatkaen HOKS-viestien listan numerointia eteenpäin eli muiden viestien laskeminen on aloitettava hoks-viestien määrästä
    ${other_count}=    Get Length    ${hoks_table}

     FOR    ${row}    IN    @{other_table}
        ${other_count}=    Set Variable    ${other_count + 1}
        ${other_table_str}=    Catenate    SEPARATOR=  -Viesti${SPACE}   ${other_count}${SPACE}   Päivämäärä:${SPACE}   ${row}[date]  , Aihe:${SPACE}   ${row}[subject]  , Liitetiedostot:${SPACE}   ${row}[attachments]
        Append To List    ${other_list}    ${other_table_str}
    END
# kootaan lähetettävän sähköpostiviestin body
    ${msg_to_send}=    Msg To Send    ${table}    ${hoks_count}    ${hoks_list}    ${other_list}    ${opettaja}

   # Luodaan Excel-tiedosto
    Create Workbook    mails.xlsx
    Append Rows To Worksheet    ${table}    header=True
    Save Workbook

    # Lähetetään viesti
    Send Message  recipients=${RECIPIENT_ADDRESS}
    ...           subject=RPA-lopputyö: ${OPETTAJA}
    ...           body=${msg_to_send}
    ...           save=${TRUE}
    ...           html=${TRUE}
