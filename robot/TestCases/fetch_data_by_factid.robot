*** Settings ***
Library    Libraries.CatFacts

*** Variables ***
${factid}    591f98d1d1f17a153828aade

*** Test Cases ***
Get Facts By factId
    [Documentation]
    ${response}    Run Keyword    Get Facts By Id   ${factid}
    Set Suite Variable    ${response}    ${response}

Validate Response Codes
    [Documentation]
    ${response_code}    Set Variable    ${response.status_code}
    ${failedReason}    Set Variable If    ${response_code} != 200
    ...    Getting status with ${response.status_code} while fetching cat facts with parameter    ${EMPTY}
    Should Be Empty    ${failedReason}

Validate Response ID And Type Of Animal
    [Documentation]
    ${response_data}    Set Variable    ${response.json()}
    Log    ${response_data}
    ${response_id}    Set Variable    ${response_data['_id']}
    Should Be Equal    ${response_id}    ${factid}       recieved id doesn't match with id provided by user
    #Evaluate the data type of the attribute '_id' retured in response
    Should Match Regexp    ${response_id}    ^([a-zA-Z0-9])*$    invalid data type of id
    #Validate Animal type
    ${animal_type}    Set Variable    ${response_data['type']}
    ${is_string}=   Evaluate     isinstance('${animal_type}', str)


