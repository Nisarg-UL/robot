*** Settings ***
Documentation	SingleModel TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***

*** Test Cases ***
1. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    create product1 asset	CreationOfRegressionProduct1_siscase1.json

2. Check Asset State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

3. Asset Summary with Modified Date & Owner Reference
    [Tags]	Functional	current
    get present_date
    Summary of Asset with Error   toModifiedDate=${Today_Date}&ownerReference_PartySiteID=${Asset_owner_ref}
    should be equal  '${err_msg}'   'Both fromDate and toDate should be entered'
    should be equal  '${err_code}'    '400'