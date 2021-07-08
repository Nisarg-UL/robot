*** Settings ***
Documentation	Security TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***

*** Test Cases ***
1a. Setting up Environment
    [Tags]	Functional	POST    current
	set global variable  ${entity_name}    Regression Test Product 1
	set global variable  ${tab_name}    Recommendation
	set global variable  ${role}    Public
	set global variable  ${user}    ManojAutomation
	set global variable  ${attr_name}    Recommendation Status
	set global variable  ${read_access}    Y

1. Role Access Configuration With POST Request
	[Tags]	Functional	POST    current
    run keyword and ignore error  Configure Role Access    ConfigureRole_Certificate_withAttrName.json    Certificate
    ${error_msg}  Get Error Message  ${response_api}
    should be equal  ${error_msg}   Invalid Entity Name

2. Disfigure Role With POST Request
	[Tags]	Functional	POST    current
	set global variable  ${read_access}    N
	set global variable  ${entity_name}    Regression Scheme
    Disfigure Role Access    ConfigureRole_Certificate_withAttrName.json   Certificate
    should be equal  ${access_role}   Public