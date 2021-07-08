*** Settings ***
Documentation	Multimodel Regression TestSuite
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

4. Product 1 Asset2 Creation With POST Request
    [Tags]	Functional	asset	create	POST    current
    ${response}  run keyword and ignore error    create Asset2 based on product1 Asset1   CreationOfRegressionProduct1Asset2_siscase1_withoutCol_ID.json
    ${msg}  Get Error Message   ${response_api}
	run keyword if  '${msg}' != 'Collection already exists with same Collection Name, Project Number, Order Number or Quote Number'  Fail	test1 Teardown
	log to console  ${msg}



