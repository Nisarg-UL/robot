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
    Configure Role Access    Certificate/ConfigureRole_Owner_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Owner

2. Role Access Configuration With POST Request
	[Tags]	Functional	POST    current
    Configure Role Access    Certificate/ConfigureRole_ProductionSite_sameAttrAsOwner_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Production Site

3. Get Role Access at Attribute Level
	[Tags]	Functional	POST    current
    ${att_role}    Get Role Access at Attribute Level   Certificate     Regression%20Scheme     Certificate     ManojAutomation
    compare lists  ${att_role}   	['Owner', 'Production Site', 'Owner', 'Production Site', 'Owner', 'Production Site', 'Owner', 'Production Site']

4. Disfigure Role With POST Request
	[Tags]	Functional	POST    current
    Disfigure Role Access    Certificate/DisfigureRole_Owner_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Owner
    Disfigure Role Access    Certificate/DisfigureRole_ProductionSite_sameAttrAsOwner_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Production Site