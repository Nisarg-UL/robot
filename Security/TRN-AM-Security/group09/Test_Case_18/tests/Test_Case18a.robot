*** Settings ***
Documentation	Security TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***

*** Test Cases ***
1a. Setting up Environment
    [Tags]	Functional	POST    current
	set global variable  ${entity_name}    Regression Scheme
	set global variable  ${tab_name}    Party Type
	set global variable  ${role}    Owner
	set global variable  ${user}    ManojAutomation
	set global variable  ${read_access}    Y

1. Role Access Configuration With POST Request
	[Tags]	Functional	POST    current
    Configure Role Access    ConfigureRole_CertificateParties_forBrandOwner.json   Certificate
    should be equal  ${access_role}   Owner

2. Role Access Configuration With POST Request
	[Tags]	Functional	POST    current
	set global variable  ${role}    Production Site
    Configure Role Access    ConfigureRole_CertificateParties_forBrandOwner.json   Certificate
    should be equal  ${access_role}   Production Site

3. Disfigure Role With POST Request
	[Tags]	Functional	POST    current
	set global variable  ${read_access}    N
	set global variable  ${role}    Owner
    Disfigure Role Access    ConfigureRole_CertificateParties_forBrandOwner.json   Certificate
    should be equal  ${access_role}   Owner
    set global variable  ${role}    Production Site
    Disfigure Role Access    ConfigureRole_CertificateParties_forBrandOwner.json   Certificate
    should be equal  ${access_role}   Production Site