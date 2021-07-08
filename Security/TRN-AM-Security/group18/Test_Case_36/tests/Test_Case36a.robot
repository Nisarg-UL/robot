*** Settings ***
Documentation	Security TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***

*** Test Cases ***
1a. Setting up Environment
    [Tags]	Functional	POST    Notcurrent
	set global variable  ${entity_name}    Regression Scheme
	set global variable  ${tab_name}    CERTIFY
	set global variable  ${role}    Public
	set global variable  ${user}    ManojAutomation
	set global variable  ${attr_name}    Certification Comment
	set global variable  ${read_access}    Y

1. Role Access Configuration With POST Request
	[Tags]	Functional	POST    Notcurrent
    ${error}     run keyword and ignore error  Configure Role Access    ConfigureRole_Certificate_withAttrName.json    ${EMPTY}
    run keyword if  "${error}" != "('FAIL', u'200 != 404')"     Fail

2. Disfigure Role With POST Request
	[Tags]	Functional	POST    Notcurrent
	set global variable  ${read_access}    N
    Disfigure Role Access    ConfigureRole_Certificate_withAttrName.json   Certificate
    should be equal  ${access_role}   Public