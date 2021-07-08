*** Settings ***
Documentation	Security TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***

*** Test Cases ***
1. Role Access Configuration With POST Request
	[Tags]	Functional	POST    current
    Configure Role Access    Certificate/ConfigureRole_Owner_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Owner
    Configure Role Access    Certificate/ConfigureRole_BrandOwner_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Brand Owner
    Configure Role Access    Certificate/ConfigureRole_ProductionSite_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Production Site
    Configure Role Access    Certificate/ConfigureRole_LocalRepresentative_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Local Representative
    Configure Role Access    Certificate/ConfigureRole_Applicant_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Applicant

2. Get Role Access at Attribute Level
	[Tags]	Functional	POST    current
    ${att_role}    Get Role Access at Attribute Level   Certificate     Regression%20Scheme     Certificate     ManojAutomation
    compare lists  ${att_role}   	['Applicant', 'Applicant', 'Applicant', 'Brand Owner', 'Brand Owner', 'Brand Owner', 'Local Representative', 'Local Representative', 'Local Representative', 'Local Representative', 'Owner', 'Owner', 'Owner', 'Owner', 'Production Site', 'Production Site', 'Production Site', 'Production Site']

3. Disfigure Role With POST Request
	[Tags]	Functional	POST    current
    Disfigure Role Access    Certificate/DisfigureRole_Owner_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Owner
    Disfigure Role Access    Certificate/DisfigureRole_BrandOwner_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Brand Owner
    Disfigure Role Access    Certificate/DisfigureRole_ProductionSite_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Production Site
    Disfigure Role Access    Certificate/DisfigureRole_LocalRepresentative_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Local Representative
    Disfigure Role Access    Certificate/DisfigureRole_Applicant_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Applicant