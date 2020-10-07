#Description: Fetch data using factId for Cat Facts API

#if I would have had more time,i would like to create keyword(refers to a callable, reusable, lower-level test function that performs a specific task)
# of all common validation steps and place it in keyword folder. So that such keywords will be reuseable across the framework

*** Settings ***
Library    Libraries.CatFacts

*** Variables ***
${factid}    591f98d1d1f17a153828aade

*** Test Cases ***
Get Facts By factId
    [Documentation]    This Step retrieve the animal facts using 'factid' by calling python method
    ...    "get_facts_by_id" of CatFacts class
    ${response}    Run Keyword    Get Facts By Id   ${factid}
    Set Suite Variable    ${response}    ${response}

Validate Response Codes
    [Documentation]     this step validate the response code
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

Validate Response Header
    [Documentation]     this step validate the headers from response header
    ${header_response}    Set Variable    ${response.headers}
    ${content_type}     Set Variable     ${header_response['Content-Type']}
    Should Be True    '''${content_type}''' == '''application/json; charset=utf-8'''    invalid content type returned
