*** Settings ***
Documentation	Taxonomy Modification TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***
test1 Teardown
	Log To Console	test1a Teardown Beginning
	Expire The Asset	${asset_Id_Product1}
	Log To Console	test1a Teardown Finished

*** Test Cases ***
1a. Setting up Environment
	set global variable	${asset_Id_Product1}

1. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    create product1 asset	CreationOfRegressionProduct1_siscase1.json

2. Check for Asset State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_Asset_State": ${state}

#ModifyTaxonomySinglemodelwithout Asset_Id
#Customer requests to change Family Series (ver1.0) for Draft Asset
#-Family Series -  (> 50 charachters)
3. Change Family Series
    [Tags]	Functional	POST	current
    run keyword and ignore error  Modify Taxonomy Single_Model Without Asset_Id   change_family_more_than_50_chars_Single_Model.json
    ${message}   err msg  ${response_api}
    log to console  ${message}
    run keyword if  "${message}" != "Unable to execute query due to SQL Exception"  fail