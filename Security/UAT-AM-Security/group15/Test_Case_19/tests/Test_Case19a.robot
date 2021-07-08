*** Settings ***
Documentation	Security TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***

*** Test Cases ***
1a. Setting up Environment
    [Tags]	Functional	POST    current
	set global variable  ${entity_name}    Regression Scheme
	set global variable  ${tab_name}    Recommendation
	set global variable  ${user}    ManojAutomation
	set global variable  ${read_access}    Y

1. Role Access Configuration With POST Request
	[Tags]	Functional	POST    current
	set global variable  ${role}    Owner
	set global variable  ${attr_name}    Recommendation Status
    Configure Role Access    ConfigureRole_Certificate_withAttrName.json   Certificate
    should be equal  ${access_role}   Owner
    set global variable  ${role}    Brand Owner
    set global variable  ${attr_name}    Recommendation Comment
    Configure Role Access    ConfigureRole_Certificate_withAttrName.json   Certificate
    should be equal  ${access_role}   Brand Owner
    set global variable  ${role}    Production Site
    set global variable  ${attr_name}    Reviewer Employee Name
    Configure Role Access    ConfigureRole_Certificate_withAttrName.json   Certificate
    should be equal  ${access_role}   Production Site
    set global variable  ${role}    Local Representative
    set global variable  ${attr_name}    Reviewer Employee Number
    Configure Role Access    ConfigureRole_Certificate_withAttrName.json   Certificate
    should be equal  ${access_role}   Local Representative
    set global variable  ${role}    Applicant
    set global variable  ${attr_name}    Review Date
    Configure Role Access    ConfigureRole_Certificate_withAttrName.json   Certificate
    should be equal  ${access_role}   Applicant

2. Get Role Access at Attribute Level
	[Tags]	Functional	POST    current
    ${att_role}    Get Role Access at Attribute Level   Certificate     Regression%20Scheme     Recommendation     ManojAutomation
    compare lists  ${att_role}   ['Applicant', 'Brand Owner', 'Local Representative', 'Owner', 'Production Site']

3. Disfigure Role With POST Request
	[Tags]	Functional	POST    current
	set global variable  ${read_access}    N
	set global variable  ${role}    Owner
	set global variable  ${attr_name}    Recommendation Status
    Disfigure Role Access    ConfigureRole_Certificate_withAttrName.json   Certificate
    should be equal  ${access_role}   Owner
    set global variable  ${role}    Brand Owner
    set global variable  ${attr_name}    Recommendation Comment
    Disfigure Role Access    ConfigureRole_Certificate_withAttrName.json   Certificate
    should be equal  ${access_role}   Brand Owner
    set global variable  ${role}    Production Site
    set global variable  ${attr_name}    Reviewer Employee Name
    Disfigure Role Access    ConfigureRole_Certificate_withAttrName.json   Certificate
    should be equal  ${access_role}   Production Site
    set global variable  ${role}    Local Representative
    set global variable  ${attr_name}    Reviewer Employee Number
    Disfigure Role Access    ConfigureRole_Certificate_withAttrName.json   Certificate
    should be equal  ${access_role}   Local Representative
    set global variable  ${role}    Applicant
    set global variable  ${attr_name}    Review Date
    Disfigure Role Access    ConfigureRole_Certificate_withAttrName.json   Certificate
    should be equal  ${access_role}   Applicant