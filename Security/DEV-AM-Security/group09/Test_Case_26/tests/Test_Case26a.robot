*** Settings ***
Documentation	Security TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***

*** Test Cases ***
1a. Setting up Environment
    [Tags]	Functional	POST    Notcurrent
	set global variable  ${entity_name}    Regression Scheme
	set global variable  ${tab_name}    Certificate
	set global variable  ${role}    Public
	set global variable  ${user}    ManojAutomation
	set global variable  ${read_access}    Y

1. Role Access Configuration With POST Request
	[Tags]	Functional	POST    Notcurrent
    run keyword and ignore error  Configure Role Access    ConfigureRole_CertificateParties_forBrandOwner.json   Certificate
    ${error_msg}  Get Error Message  ${response_api}
    should be equal  ${error_msg}   Invalid Tab name

2. Disfigure Role With POST Request
	[Tags]	Functional	POST    Notcurrent
	set global variable  ${read_access}    N
	set global variable  ${tab_name}    Certificate
    Disfigure Role Access    ConfigureRole_CertificateParties_forBrandOwner.json   Certificate
    should be equal  ${access_role}   Public