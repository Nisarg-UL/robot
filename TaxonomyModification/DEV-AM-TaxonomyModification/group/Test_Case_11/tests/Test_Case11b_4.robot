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

3. Get the Colletion_ID
    [Tags]	Functional	current
    Get Collection_ID   ${asset_Id_Product1}
    set global variable     ${Product_Collection_Id}    ${Collection_Id}

#ModifyTaxonomyBulkmodelwith Collection_Id
#Customer requests to change Creation Date (ver1.0) for Draft Asset
#-Creation Date -  (todays date)
4. Change Creation Date
    [Tags]	Functional	POST	current
    run keyword and ignore error  Modify Taxonomy Bulk_Model With Collection_Id   change_creationdate_todays_date_Single_Model.json
    ${message}   err msg  ${response_api}
    log to console  ${message}
    run keyword if  "${message}" != "Cannot update product type and creation date"  fail