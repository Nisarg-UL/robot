*** Settings ***
Documentation	Security TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***
test1 Teardown
	Log To Console	test1a Teardown Beginning
	Expire The Asset	${asset_Id_Product1}
	Log To Console	test1a Teardown Finished

*** Test Cases ***
1. Role Access Configuration With POST Request
	[Tags]	Functional	POST    current
    Configure Role Access    Certificate/ConfigureRole_Applicant_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Applicant

2. Role Access Configuration With POST Request
	[Tags]	Functional	POST    current
    run keyword and ignore error     Configure Role Access    Certificate/ConfigureRole_Public_sameAttrAsApplicant_forRegressionScheme.json   Certificate
    ${error_msg}  Get hasError Message  ${response_api}
    should be equal  ${error_msg}   The listed attributes are part of the other role. Please re-check for the role Public

3. Disfigure Role With POST Request
	[Tags]	Functional	POST    current
    Disfigure Role Access    Certificate/DisfigureRole_Applicant_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Applicant

4. Disfigure Role With POST Request
	[Tags]	Functional	POST    current
    Disfigure Role Access    Certificate/DisfigureRole_Public_sameAttrAsApplicant_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Public