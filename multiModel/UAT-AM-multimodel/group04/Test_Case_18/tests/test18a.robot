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

4. Edit Product1 Col_Attribute
    [Tags]	Functional	asset	create	POST    current
    set global variable  ${old_collection_ID}   ${Collection_Id}
    Edit Asset Collection Attribute	 EditOfCol_AttRegressionProduct1_siscase1_withCol_ID.json   ${asset_Id_Product1}
    run keyword if  ${Asset_Owner_Ref_edit} != ${Asset_Owner_Ref}   Fail	test1 Teardown
    run keyword if  ${Collection_Order_no_edit} != ${Collection_Order_no}   Fail	test1 Teardown
    run keyword if  ${Collection_Quote_no_edit} != ${Collection_Quote_no}   Fail	test1 Teardown
    run keyword if  ${Collection_Project_no_edit} == ${Collection_Project_no}   Fail	test1 Teardown
    log to console   "Project_No before Edit: " ${Collection_Project_no}
    log to console   "Project_No After Edit: " ${Collection_Project_no_edit}

5. Get the Colletion_ID
    [Tags]	Functional	current
    Get Collection_ID   ${asset_Id_Product1}
    run keyword if  '${old_collection_ID}' != '${collection_id}'    Fail	test1 Teardown



