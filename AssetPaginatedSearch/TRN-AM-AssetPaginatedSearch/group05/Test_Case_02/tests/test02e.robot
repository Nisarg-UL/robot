*** Settings ***
Documentation	SingleModel TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***


*** Test Cases ***
1. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    create product1 asset	CreationOfRegressionProduct1_siscase1.json

2. Search Asset with empty 'user' values
	[Tags]	Functional	asset   Search	POST    current
	Search Asset    Asset_Search_with_user_empty.json
#	${error_msg}  Get Error Message  ${response_api}
#    should be equal  ${error_msg}   ${Asset_Search_Error}
