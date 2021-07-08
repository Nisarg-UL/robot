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

##ModifyTaxonomySinglemodelwith Asset_Id
#Customer requests to change Model number (ver1.0) for Draft Asset
#-Model number -  (< 50 charachters)
# changing Model Number Multiple Time
3. Change Model Number
    [Tags]	Functional	POST	current
    Modify Taxonomy Single_Model With Asset_Id   change_model_less_than_150_chars_Single_Model.json
    ${status}   api_message   ${response_api}
    run keyword if  "${status}" != "Taxonomy updated successfully"  Fail

4. Change Model Number Again
    [Tags]	Functional	POST	current
    Modify Taxonomy Single_Model With Asset_Id   change_model_less_than_150_chars_Single_Model_Multiple_Time.json
    ${status}   api_message   ${response_api}
    run keyword if  "${status}" != "Taxonomy updated successfully"  Fail