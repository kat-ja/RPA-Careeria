*** Settings ***
Library     RPA.Dialogs

*** Keywords ***
Input form dialog
    #Add heading    User Information    size=Large

    Add text input    user    label=E-mail address
    Add text input    password    label=Password
    #${result}=    Run dialog
    

