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

3. Asset Summary with all valid parameters
    [Tags]	Functional	current
    get present_date
    ${response}  Summary of Asset   productType=Regression+Test+Product+1&ownerReference_PartySiteID=${Asset_owner_ref}&referenceNumber=${Asset_Ref_No}&modelName=Regression_Test_Model_1&family_Series=Reg-Test&fromDate=${Today_Date}&toDate=${Today_Date}&fromCreatedDate=${Today_Date}&toCreatedDate=${Today_Date}&fromModifiedDate=${Today_Date}&toModifiedDate=${Today_Date}
    run keyword if  ${response} != ['${asset_Id_Product1}']   Fail