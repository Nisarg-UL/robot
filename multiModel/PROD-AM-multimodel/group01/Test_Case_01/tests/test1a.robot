*** Settings ***
Documentation	Multimodel Regression TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***
test1 Teardown
	Log To Console	test1a Teardown Beginning
	Expire The Asset	${asset_Id_Product1}
	Log To Console	test1a Teardown Finished

*** Test Cases ***
1. Validate Master Asset Template
	[Tags]	Functional	Test	GET    current
    ${response}     Get Collection Attributes       Regression%20test%20Product%201
    Sort List  ${response}
    log to console  ${response}
    run keyword if  ${response} != [{'dataParamName': 'collectionName', 'name': 'Collection Name'}, {'dataParamName': 'orderNumber', 'name': 'Order Number'}, {'dataParamName': 'projectNumber', 'name': 'Project Number'}, {'dataParamName': 'quoteNumber', 'name': 'Quote Number'}]  Fail test1 Teardown
    ${response}     Get Shared Attributes       Regression%20test%20Product%201
    run keyword if  ${response} != {'dataParamName': 'sharedAttribute3', 'name': 'Shared Attribute 3'}  Fail	test1 Teardown
