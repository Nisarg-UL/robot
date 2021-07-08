*** Settings ***
Documentation	Multimodel Regression TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***
test1 Teardown
	Log To Console	test1a Teardown Beginning
	Expire The Asset	${asset_Id_Product1}
	Log To Console	test1a Teardown Finished

*** Test Cases ***
1. Validate and Update Compliance Collection Level
    [Tags]	Functional	current
    ${response}  run keyword and ignore error  Validate and Update Compliance Collection Level  Update_ComplianceAll.json  123456
    ${msg}  Get Error Message   ${response_api}
	run keyword if  '${msg}' != 'Invalid collectionID passed in URL'  Fail	test1 Teardown
	log to console  ${msg}

