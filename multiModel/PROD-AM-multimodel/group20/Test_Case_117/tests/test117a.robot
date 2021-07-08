*** Settings ***
Documentation	Multimodel Regression TestSuite
Resource    ../../../resource/ApiFunctions.robot

*** Keywords ***
test1 Teardown
	Log To Console	test1a Teardown Beginning
	Expire The Asset	${asset_Id_Product1}
	Log To Console	test1a Teardown Finished

*** Test Cases ***
1a. Setting up Environment
	set global variable	${asset_Id_Product1}

1. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    create product3 asset	CreationOfRegressionProduct3_siscase2.json

2. Check for Asset State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product3}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_Asset_State": ${state}

3. Get the Colletion_ID
    [Tags]	Functional	current
    ${response}  run keyword and ignore error  Validate On End   ${asset_Id_Product3}
    run keyword if  ${response} != ('FAIL', u'HTTPError: HTTP Error 400: Bad Request')   Fail	test1 Teardown
    log to console  ${response}