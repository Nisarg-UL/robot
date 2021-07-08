*** Settings ***
Documentation	Multimodel Regression TestSuite
Resource	../../../resource/ApiFunctions.robot

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
    create product1 asset	CreationOfRegressionProduct1_siscase1.json

2. Check for Asset State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_Asset_State": ${state}

3. Get the Colletion_ID
    [Tags]	Functional	current
    Get Collection_ID   ${asset_Id_Product1}

4. Edit Product1 Attributes
    [Tags]	Functional	asset	create	POST    current
    Edit product1 asset	EditOfAttRegressionProduct1_siscase1_withCol_ID.json    ${asset_Id_Product1}
    ${response}  Get Asset From Endpoint   ${asset_Id_Product1}
    ${Att6_value}  Get TP1Attribute6  ${response}
    run keyword if  '${Att6_value}' != 'F'   Fail	test1 Teardown