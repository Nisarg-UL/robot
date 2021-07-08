*** Settings ***
Documentation	Security TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***

*** Test Cases ***
1a. Setting up Environment
    [Tags]	Functional	POST    current
	set global variable  ${entity_name}    Regression Scheme
	set global variable  ${tab_name}    Party Type
	set global variable  ${user}    ManojAutomation
	set global variable  ${read_access}    Y

1. Role Access Configuration With POST Request
	[Tags]	Functional	POST    current
	set global variable  ${role}    Owner
    Configure Role Access    ConfigureRole_CertificateParties_forBrandOwner.json   Certificate
    should be equal  ${access_role}   Owner
    set global variable  ${role}    Brand Owner
    Configure Role Access    ConfigureRole_CertificateParties_forBrandOwner.json   Certificate
    should be equal  ${access_role}   Brand Owner
    set global variable  ${role}    Production Site
    Configure Role Access    ConfigureRole_CertificateParties_forProductionSite.json   Certificate
    should be equal  ${access_role}   Production Site
    set global variable  ${role}    Local Representative
    Configure Role Access    ConfigureRole_CertificateParties_forLocalRepresentative.json   Certificate
    should be equal  ${access_role}   Local Representative
    set global variable  ${role}    Applicant
    Configure Role Access    ConfigureRole_CertificateParties_forApplicant.json   Certificate
    should be equal  ${access_role}   Applicant

2. Get Role Access at Attribute Level
	[Tags]	Functional	POST    current
    ${att_role}    Get Role Access at Attribute Level   Certificate     Regression%20Scheme     Party%20Type     ManojAutomation
    compare lists  ${att_role}   ['Applicant', 'Brand Owner', 'Owner', 'Local Representative', 'Production Site']

3. Disfigure Role With POST Request
	[Tags]	Functional	POST    current
	set global variable  ${read_access}    N
	set global variable  ${role}    Owner
    Disfigure Role Access    ConfigureRole_CertificateParties_forBrandOwner.json   Certificate
    should be equal  ${access_role}   Owner
    set global variable  ${role}    Brand Owner
    Disfigure Role Access    ConfigureRole_CertificateParties_forBrandOwner.json   Certificate
    should be equal  ${access_role}   Brand Owner
    set global variable  ${role}    Production Site
    Disfigure Role Access    ConfigureRole_CertificateParties_forProductionSite.json   Certificate
    should be equal  ${access_role}   Production Site
    set global variable  ${role}    Local Representative
    Disfigure Role Access    ConfigureRole_CertificateParties_forLocalRepresentative.json   Certificate
    should be equal  ${access_role}   Local Representative
    set global variable  ${role}    Applicant
    Disfigure Role Access    ConfigureRole_CertificateParties_forApplicant.json   Certificate
    should be equal  ${access_role}   Applicant