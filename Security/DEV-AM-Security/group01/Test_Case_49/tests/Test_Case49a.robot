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
    run keyword and ignore error   Configure Role Access    Certificate/ConfigureRole_EmptyReadAccess_forRegressionScheme.json   Certificate
    ${error_msg}  Get Error Message  ${response_api}
    should be equal  ${error_msg}   Value for Read access should be Y/N

2. Disfigure Role With POST Request
	[Tags]	Functional	POST    current
    Disfigure Role Access    Certificate/DisfigureRole_InvalidAttributes_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Public