*** Settings ***
Documentation	Security TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***

*** Test Cases ***
1. Role Access Configuration With POST Request
	[Tags]	Functional	POST    current
    Configure Role Access    Certificate/ConfigureRole_Public_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Public

2. Role Access Configuration With POST Request
	[Tags]	Functional	POST    current
    Configure Role Access    Certificate/ConfigureRole_Owner_forRegression2Scheme.json   Certificate
    should be equal  ${access_role}   Owner

3. Disfigure Role With POST Request
	[Tags]	Functional	POST    current
    Disfigure Role Access    Certificate/DisfigureRole_Public_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Public

4. Disfigure Role With POST Request
	[Tags]	Functional	POST    current
    Disfigure Role Access    Certificate/DisfigureRole_Owner_forRegression2Scheme.json   Certificate
    should be equal  ${access_role}   Owner