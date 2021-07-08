*** Settings ***
Documentation	Security TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***

*** Test Cases ***
1a. Setting up Environment
    [Tags]	Functional	POST    current
	set global variable  ${entity_name}    Regression Scheme
	set global variable  ${tab_name}    Questions
	set global variable  ${user}    ManojAutomation
	set global variable  ${read_access}    Y

1. Role Access Configuration With POST Request
	[Tags]	Functional	POST    current
	set global variable  ${role}    Owner
	set global variable  ${attr_name}    Question5
    Configure Role Access    ConfigureRole_Certificate_withAttrName.json   Certificate
    should be equal  ${access_role}   Owner
    set global variable  ${role}    Brand Owner
    set global variable  ${attr_name}    Question6
    Configure Role Access    ConfigureRole_Certificate_withAttrName.json   Certificate
    should be equal  ${access_role}   Brand Owner
    set global variable  ${role}    Production Site
    set global variable  ${attr_name}    Question7
    Configure Role Access    ConfigureRole_Certificate_withAttrName.json   Certificate
    should be equal  ${access_role}   Production Site
    set global variable  ${role}    Local Representative
    set global variable  ${attr_name}    Question8
    Configure Role Access    ConfigureRole_Certificate_withAttrName.json   Certificate
    should be equal  ${access_role}   Local Representative
    set global variable  ${role}    Applicant
    set global variable  ${attr_name}    Question9
    Configure Role Access    ConfigureRole_Certificate_withAttrName.json   Certificate
    should be equal  ${access_role}   Applicant

2. Get Role Access at Attribute Level
	[Tags]	Functional	POST    current
    ${att_role}    Get Role Access at Attribute Level   Certificate     Regression%20Scheme     Questions     ManojAutomation
    compare lists  ${att_role}   ['Applicant', 'Brand Owner', 'Local Representative', 'Owner', 'Production Site']

3. Disfigure Role With POST Request
	[Tags]	Functional	POST    current
	set global variable  ${read_access}    N
	set global variable  ${role}    Owner
	set global variable  ${attr_name}    Question5
    Disfigure Role Access    ConfigureRole_Certificate_withAttrName.json   Certificate
    should be equal  ${access_role}   Owner
    set global variable  ${role}    Brand Owner
    set global variable  ${attr_name}    Question6
    Disfigure Role Access    ConfigureRole_Certificate_withAttrName.json   Certificate
    should be equal  ${access_role}   Brand Owner
    set global variable  ${role}    Production Site
    set global variable  ${attr_name}    Question7
    Disfigure Role Access    ConfigureRole_Certificate_withAttrName.json   Certificate
    should be equal  ${access_role}   Production Site
    set global variable  ${role}    Local Representative
    set global variable  ${attr_name}    Question8
    Disfigure Role Access    ConfigureRole_Certificate_withAttrName.json   Certificate
    should be equal  ${access_role}   Local Representative
    set global variable  ${role}    Applicant
    set global variable  ${attr_name}    Question9
    Disfigure Role Access    ConfigureRole_Certificate_withAttrName.json   Certificate
    should be equal  ${access_role}   Applicant