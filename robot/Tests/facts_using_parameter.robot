*** Settings ***
Library    Libraries.CatFacts

*** Variables ***
${animal_type}    dog,cat
${amount}    100

*** Test Cases ***
Get All The Facts
    ${response}    Run Keyword    Get Facts    ${animal_type}    ${amount}
    Set Suite Variable    ${response}    ${response}

Validate Response Codes
    ${response_code}    Set Variable    ${response.status_code}
    ${failedReason}    Set Variable If    ${response_code} != 200
    ...    Getting status with ${response.status_code} while fetching cat facts with parameter    ${EMPTY}
    Should Be Empty    ${failedReason}

Validate Response Data
    ${response_data}    Set Variable    ${response.json()}
    Log    ${response_data}
    FOR    ${index}    IN RANGE    0    ${amount}
        #evaluate the animal type retured should be from animal type provided
        ${type}    Set Variable    ${response_data[${index}]['type']}
        ${contains}=  Evaluate   "${type}" in "${animal_type}"
        Should Be True    ${contains}    animal type returned is not same as animal type given by user
        #Evaluate the data type of the ID
        Should Match Regexp    ${response_data[${index}]['_id']}    ^([a-zA-Z0-9])*$    invalid data type of id
    END

Validate Response Header
    ${header_response}    Set Variable    ${response.headers}
    ${content_type}     Set Variable     ${header_response['Content-Type']}
    Should Be True    '''${content_type}''' == '''application/json; charset=utf-8'''    invalid content type
