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
    set global variable  ${product_collection_id}   ${collection_id}

4. Asset2 Creation with POST Request
    [Tags]	Functional	asset	create	POST    current
    create Asset2 based on product1 Asset1   CreationOfRegressionProduct1Asset2_siscase1_withCol_ID.json

5. Validate above Asset's part of same collection
    [Tags]	Functional	Test	GET    current
    ${response}  Get Collection Asset Link  ${Collection_Id}
    run keyword if  ${response} != (('${asset_Id_Product1}',), ('${asset_Id_Product12}',))    Fail	test1 Teardown

#ModifyTaxonomySinglemodelwith Asset_Id
#Customer requests to change Reference Number (ver1.0) for one of Draft Asset in collection
#-Reference Number -  (< 50 charachters)
6. Change Owner reference
    [Tags]	Functional	POST	current
    run keyword and ignore error  Modify Taxonomy Single_Model With Asset_Id   change_refno_less_than_50_chars_Single_Model.json
    ${message}   err msg  ${response_api}
    log to console  ${message}
    run keyword if  "${message}" != "Cant modify taxonomy because more than one asset is linked to the collection, please call modify taxonomy service at collection level"  fail