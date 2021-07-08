*** Settings ***
Documentation	Security TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***

*** Test Cases ***
1a. Setting up Environment
    [Tags]	Functional	POST    current
	set global variable  ${entity_name}    Regression Scheme
	set global variable  ${tab_name}    CERTIFY
	set global variable  ${role}    Public
	set global variable  ${user}    ManojAutomation
	set global variable  ${read_access}    Y

1. Role Access Configuration With POST Request
	[Tags]	Functional	POST    current
    Configure Role Access    ConfigureRole_CertificateCertify.json   Certificate
    should be equal  ${access_role}   Public

2. Get Role Access at Attribute Level
	[Tags]	Functional	POST    current
    ${error}     run keyword and ignore error  Get Role Access at Attribute Level   ${EMPTY}     Regression%20Scheme     CERTIFY     ManojAutomation
    should be equal  ${response_api}   HTTP Error 404: Not Found

3. Disfigure Role With POST Request
	[Tags]	Functional	POST    current
	set global variable  ${read_access}    N
    Disfigure Role Access    ConfigureRole_CertificateCertify.json   Certificate
    should be equal  ${access_role}   Public