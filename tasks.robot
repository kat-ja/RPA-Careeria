*** Settings ***
Documentation   Read Exchange mail messages, make a table of specific messages and send that information to user.
Library         RPA.Email.Exchange

Library         RPA.Dialogs
Library         String
Library         Collections
Library         RPA.Tables
Library         DateTime
Library         parse_date.py
Library         parse_time.py
Library         get_attachment_names.py
Library         msg_to_send.py
Library         RPA.Excel.Files
Library         RPA.Browser.Selenium
Library         RPA.Dialogs
Resource        dialog.robot
Task Setup      Dialog For Credentials   
#Task Setup      Authorize    username=${ACCOUNT}    password=${PASSWORD}

*** Variables ***
${ACCOUNT}    ${EMPTY}   
${PASSWORD}    ${EMPTY}   
${hoks}=    other



# Tällä saa tietää muuttujan tyypin:
    #   ${type} =    Evaluate    type($msg).__name__
    #    Log        ${type}

# pvm, klo, aihe, viesti, luettelo liitetiedostoista
*** Keywords ***
Dialog For Credentials
    Create Form    title=Credentials
    Add text input    label=Username    name=user
    Add text input    label=Password    name=password
    &{response}    Request Response    window_height=550
    ${ACCOUNT}=    Set Variable    ${response}[user] 
    ${PASSWORD}=    Set Variable    ${response}[password]
    Authorize    username=${ACCOUNT}    password=${PASSWORD}
    #[Return]    ${ACCOUNT}    ${PASSWORD}

*** Tasks ***
Mail Messages From Specific Sender To Table

    #Dialog
     
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
    #${other_count}=    Set Variable    ${hoks_count}
    
    FOR    ${msg}    IN    @{messages}
        #Log    ${msg}
        ${match}=    Get Regexp Matches    ${msg}[sender][name]    Katja Valanne 
        ${match_HOPS}=    Get Regexp Matches    ${msg}[subject]    HOPS|HOKS
        ${match_len}=    Get Length    ${match}
        ${match_HOPS_len}=    Get Length    ${match_HOPS}

        IF    ${match_HOPS_len} > 0
            ${hoks}=    Set Variable    hoks
           # ${hoks_count}=    Set Variable    ${hoks_count + 1}
        ELSE    
            ${hoks}=    Set Variable    other
        END

        ${attachments_len}=   Get Length    ${msg}[attachments_object] 

        IF    ${match_len} > 0
            IF    ${attachments_len} > 0
                ${text}=   Convert To String    ${msg}[attachments_object]
                ${attachment_names}=    Get Attachment Names    ${text}
                #Log    ${attachment_names}
                # RUMA
                # ${attachment_names_str}=     Convert To String    ${attachment_names}
                ${attachment_names_str}=    Catenate    SEPARATOR=, ${EMPTY}    @{attachment_names}
            ELSE    
                ${attachment_names_str}=    Set variable    Ei liitetiedostoja
            END

            ${str_date_time}=    Convert Date    ${msg}[datetime_received]
            ${date}=    Parse Date    ${str_date_time}
            ${time}=    Parse Time    ${str_date_time}
            &{mail_dict}=    Create Dictionary    date=${date}    time=${time}    subject=${msg}[subject]    body=${msg}[body]    attachments=${attachment_names_str}    hoks=${hoks}
  
            #Append To List    ${L1}    ${msg}
            Add Table Row    ${table}    ${mail_dict}
        END     
    END

    FOR    ${row}    IN    @{table}
        Log    ${row}     
    END

    #@{rows}=    Find table rows    Price  >  ${200}
    #Filter table by column    ${table}   price  !=  ${0}
    
    @{hoks_table}=    Find Table Rows    ${table}    hoks    hoks
    @{other_table}=    Find Table Rows    ${table}    hoks    other

    #  -Viesti 1 Päivämäärä: dd.mm.yyyy, Aihe: zzzz, Liitetiedostot: HOKS.xlsx, suunn.txt
    FOR    ${row}    IN    @{hoks_table}
        ${hoks_count}=    Set Variable    ${hoks_count + 1}
        # vain 2 välilyöntiä SEPARATOR jälkeen = ei mitään! 
        ${hoks_table_str}=    Catenate    SEPARATOR=  -Viesti${SPACE}   ${hoks_count}${SPACE}   Päivämäärä:${SPACE}   ${row}[date]  , Aihe:${SPACE}   ${row}[subject]  , Liitetiedostot:${SPACE}   ${row}[attachments]
        Append To List    ${hoks_list}    ${hoks_table_str}
    END

    ${other_count}=    Get Length    ${hoks_table}

     FOR    ${row}    IN    @{other_table}
        ${other_count}=    Set Variable    ${other_count + 1}
        # vain 2 välilyöntiä SEPARATOR jälkeen = ei mitään 
        ${other_table_str}=    Catenate    SEPARATOR=  -Viesti${SPACE}   ${other_count}${SPACE}   Päivämäärä:${SPACE}   ${row}[date]  , Aihe:${SPACE}   ${row}[subject]  , Liitetiedostot:${SPACE}   ${row}[attachments]
        Append To List    ${other_list}    ${other_table_str}
    END

    Log    ${hoks_list}

    ${msg_to_send}=    Msg To Send    ${table}    ${hoks_count}    ${hoks_list}    ${other_list}
    Log    ${msg_to_send}

    #${type} =    Evaluate    type($table).__name__
    #Log        ${type}
   
    Create Workbook    mails.xlsx
    Append Rows To Worksheet    ${table}    header=True
    Save Workbook
