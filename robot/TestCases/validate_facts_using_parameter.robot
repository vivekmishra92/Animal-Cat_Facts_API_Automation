#Description: Validate Cat facts Base URL with endpoint with paramter
#Reference: https://alexwohlbruck.github.io/cat-facts/
#           https://alexwohlbruck.github.io/cat-facts/docs/
#           https://alexwohlbruck.github.io/cat-facts/docs/endpoints/facts.html

*** Settings ***
Library    Libraries.CatFacts

*** Variables ***
${animal_type}    dog,cat
${amount}    100

*** Test Cases ***
Get All The Facts
    [Documentation]
    ${response}    Run Keyword    Get Facts    ${animal_type}    ${amount}
    Set Suite Variable    ${response}    ${response}

Validate Response Codes
    [Documentation]
    ${response_code}    Set Variable    ${response.status_code}
    ${failedReason}    Set Variable If    ${response_code} != 200
    ...    Getting status with ${response.status_code} while fetching cat facts with parameter    ${EMPTY}
    Should Be Empty    ${failedReason}

Validate Response Data
    [Documentation]
    ${response_data}    Set Variable    ${response.json()}
    Log    ${response_data}
    FOR    ${index}    IN RANGE    0    ${amount}
        # the attribute 'type' retured in response should match with the animal_type sent in the request
        ${type}    Set Variable    ${response_data[${index}]['type']}
        ${contains}=  Evaluate   "${type}" in "${animal_type}"
        Should Be True    ${contains}    attribute 'type' returned in reponse is not same as animal_type sent in the request
        #Evaluate the data type of the attribute '_id' retured in response
        Should Match Regexp    ${response_data[${index}]['_id']}    ^([a-zA-Z0-9])*$    invalid data type of attribute '_id'
    END

Validate Response Header
    [Documentation]
    ${header_response}    Set Variable    ${response.headers}
    ${content_type}     Set Variable     ${header_response['Content-Type']}
    Should Be True    '''${content_type}''' == '''application/json; charset=utf-8'''    invalid content type returned
