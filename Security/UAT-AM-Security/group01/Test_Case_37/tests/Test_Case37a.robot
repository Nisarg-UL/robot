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
	[Tags]	Functional	POST    Notcurrent
    run keyword and ignore error   Configure Role Access    Certificate/ConfigureRole_InvalidAttributes_forRegressionScheme.json   Certificate
    ${error_msg}  Get Error Message  ${response_api}
    should be equal  ${error_msg}   Invalid Attribute Name provided for given Entity Name

2. Disfigure Role With POST Request
	[Tags]	Functional	POST    Notcurrent
    Disfigure Role Access    Certificate/DisfigureRole_InvalidAttributes_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Public