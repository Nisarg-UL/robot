*** Settings ***
Documentation	Security TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***

*** Test Cases ***
1a. Setting up Environment
    [Tags]	Functional	POST    current
	set global variable  ${entity_name}    Regression Scheme
	set global variable  ${tab_name}    Party Type
	set global variable  ${role}    Brand Owner
	set global variable  ${user}    ManojAutomation
	set global variable  ${read_access}    Y

1. Role Access Configuration With POST Request
	[Tags]	Functional	POST    current
    Configure Role Access    ConfigureRole_CertificateParties_forBrandOwner.json   Certificate
    should be equal  ${access_role}   Brand Owner

2. Get Role Access at Attribute Level
	[Tags]	Functional	POST    current
    ${att_role}    Get Role Access at Attribute Level   Certificate     Regression%20Scheme     Party%20Type     ManojAutomation
    compare lists  ${att_role}   ['Brand Owner']

3. Disfigure Role With POST Request
	[Tags]	Functional	POST    current
	set global variable  ${read_access}    N
    Disfigure Role Access    ConfigureRole_CertificateParties_forBrandOwner.json   Certificate
    should be equal  ${access_role}   Brand Owner
