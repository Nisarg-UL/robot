*** Settings ***
Documentation	Security TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***

*** Test Cases ***
1a. Setting up Environment
    [Tags]	Functional	POST    current
	set global variable  ${entity_name}    Regression Scheme
	set global variable  ${tab_name}    Recommendation
	set global variable  ${role}    Applicant
	set global variable  ${user}    ManojAutomation
	set global variable  ${read_access}    Y

1. Role Access Configuration With POST Request
	[Tags]	Functional	POST    current
    Configure Role Access    ConfigureRole_CertificateRecommendation.json   Certificate
    should be equal  ${access_role}   Applicant

2. Role Access Configuration With POST Request
	[Tags]	Functional	POST    current
	set global variable  ${role}    Public
    run keyword and ignore error     Configure Role Access    ConfigureRole_CertificateRecommendation.json   Certificate
    ${error_msg}  Get hasError Message  ${response_api}
    should be equal  ${error_msg}   The listed attributes are part of the other role. Please re-check for the role Public

3. Disfigure Role With POST Request
	[Tags]	Functional	POST    current
	set global variable  ${read_access}    N
	set global variable  ${role}    Applicant
    Disfigure Role Access    ConfigureRole_CertificateRecommendation.json   Certificate
    should be equal  ${access_role}   Applicant
    set global variable  ${role}    Public
    Disfigure Role Access    ConfigureRole_CertificateRecommendation.json   Certificate
    should be equal  ${access_role}   Public