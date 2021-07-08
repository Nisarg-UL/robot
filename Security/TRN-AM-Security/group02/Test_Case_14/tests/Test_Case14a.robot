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
    Configure Role Access    Product/ConfigureRole_Public_forProduct1.json   Asset
    should be equal  ${access_role}   Public

2. Get Role Access at Attribute Level
	[Tags]	Functional	POST    current
    ${att_role}    Get Role Access at Attribute Level   Asset     Regression%20Test%20Product%201     Details     ManojAutomation
    compare lists  ${att_role}   ['Public', 'Public', 'Public', 'Public', 'Public']

3. Disfigure Role With POST Request
	[Tags]	Functional	POST    current
    Disfigure Role Access    Product/DisfigureRole_Public_forProduct1.json   Asset
    should be equal  ${access_role}   Public