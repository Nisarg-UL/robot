*** Settings ***
Documentation	SingleModel TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***


*** Test Cases ***
1. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    create product1 asset	CreationOfRegressionProduct1_siscase1.json

2. Search Asset with all empty values
	[Tags]	Functional	asset   Search	POST    current
	run keyword and ignore error  Search Asset    Asset_Search_with_all_values_Empty.json
	${error_msg}  Get Error Message  ${response_api}
    should be equal  ${error_msg}   ${Asset_Search_Error}
