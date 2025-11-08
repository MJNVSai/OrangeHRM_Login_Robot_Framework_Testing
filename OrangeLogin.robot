*** Settings ***
Documentation    Performing Automation Testing Using Robot Framework In Python For Orange HRM Login Feature
Library    SeleniumLibrary
Suite Setup    Open Browser To Login Page
Suite Teardown    Close All Browsers

*** Variables ***
${BROWSER}    chrome
${URL}    https://opensource-demo.orangehrmlive.com/web/index.php/auth/login
${VALID_USER}    Admin
${VALID_PASS}    admin123
${INVALID_USER}    Admin_VenkatSai
${INVALID_PASS}    Admin_2036
${EMPTY}

*** Keywords ***
Open Browser To Login Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed    2s

Login With Credentials
    [Arguments]    ${username}    ${password}
    Wait Until Element Is Visible    xpath=//input[@name='username']    8s
    Input Text    name:username    ${username}
    Input Text    name:password    ${password}
    Click Button    xpath=//button[@type='submit']

Logout The Webpage
    Click Element    xpath=//*[@id="app"]/div[1]/div[1]/header/div[1]/div[3]/ul/li/span
    Click Link    xpath=//*[@id="app"]/div[1]/div[1]/header/div[1]/div[3]/ul/li/ul/li[4]/a

Verify Dashboard is Visible
    ${text}=    Get Text    xpath=//*[@id="app"]/div[1]/div[1]/header/div[1]/div[1]/span/h6
    Should Be Equal    ${text}    Dashboard

Verify Error Message is Displayed
    Wait Until Element Is Visible    xpath=//p[contains(@class, 'oxd-alert-content-text')]    5s
    ${Error_Text}=    Get Text    xpath=//p[contains(@class, 'oxd-alert-content-text')]
    Log To Console    Error Message Displayed : ${Error_Text}
    Should Contain    ${Error_Text}    Invalid credentials
    Log    Error Message Displayed : ${Error_Text}

*** Test Cases ***
Valid Username And Valid Password
    [Documentation]    Valid Username and valid Password Should Give Login Sucessfully
    Login With Credentials    ${VALID_USER}    ${VALID_PASS}
    Verify Dashboard is Visible
    Capture Page Screenshot    Login_Sucess_Dashboard_Pic.png
    Logout The Webpage

Valid Username And Invalid Password
    [Documentation]    Valid Username and Invalid Password Should Show Error Message
    Reload Page
    Login With Credentials    ${VALID_USER}    ${INVALID_PASS}
    Verify Error Message is Displayed

Invalid Username And Valid Password
    [Documentation]    Invalid Username and Valid Password Should Show Error Message
    Reload Page
    Login With Credentials    ${INVALID_USER}    ${VALID_PASS}
    Verify Error Message is Displayed

Innvalid Username And Invalid Password
    [Documentation]    Invalid Username and Invalid Password Should Show Error Message
    Reload Page
    Login With Credentials    ${INVALID_USER}    ${INVALID_PASS}
    Verify Error Message is Displayed

Empty Username And Empty Password
    [Documentation]    Empty Username And Empty Password Should Show Required Field User
    Reload Page

    Login With Credentials    ${EMPTY}    ${EMPTY}
    Wait Until Element Is Visible    xpath=//span[text()='Required']    5s
    Page Should Contain Element    xpath=//span[text()='Required']

Empty Username And Valid Password
    [Documentation]    Empty Username And Valid Password Should Show Required Field User
    Reload Page

    Login With Credentials    ${EMPTY}    ${VALID_PASS}
    Wait Until Element Is Visible    xpath=//span[text()='Required']    5s
    Page Should Contain Element    xpath=//span[text()='Required']

Valid Username And Empty Password
    [Documentation]    Valid Username And Empty Password Should Show Required Field User
    Reload Page

    Login With Credentials    ${VALID_USER}    ${EMPTY}
    Wait Until Element Is Visible    xpath=//span[text()='Required']    5s
    Page Should Contain Element    xpath=//span[text()='Required']