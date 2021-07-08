*** Settings ***
Documentation	Security TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***

*** Test Cases ***
1a. Setting up Environment
    [Tags]	Functional	POST    current
	set global variable  ${entity_name}    Regression Scheme
	set global variable  ${tab_name}    Party Type
	set global variable  ${role}    Public
	set global variable  ${user}    ManojAutomation
	set global variable  ${read_access}    N

1. Disfigure Role With POST Request
	[Tags]	Functional	POST    current
    Disfigure Role Access    ConfigureRole_CertificateParties_forOwnerRef.json    Certificate
    should be equal  ${access_role}   Public

2. Get Role Access at Attribute Level
	[Tags]	Functional	POST    current
    run keyword and ignore error    Get Role Access at Attribute Level   Certificate     Regression%20Scheme     Party%20Type     ManojAutomation
    ${error_msg}  Get Error Message  ${response_api}
    should be equal  ${error_msg}   No Content