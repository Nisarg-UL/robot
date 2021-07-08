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

4. Asset2 Creation with POST Request
    [Tags]	Functional	asset	create	POST    current
    create Asset2 based on product1 Asset1   CreationOfRegressionProduct1Asset2_siscase1_withCol_ID.json

5. Validate above Asset's part of same collection
    [Tags]	Functional	GET    current
    ${response}  Get Collection Asset Link  ${Collection_Id}
    run keyword if  ${response} != (('${asset_Id_Product1}',), ('${asset_Id_Product12}',))    Fail	test1 Teardown

6. Edit Asset1 Col_Attribute
    [Tags]	Functional	asset	create	POST    current
    log to console   "Project_No before Edit: " ${Collection_Project_no}
    set global variable  ${old_collection_ID}   ${Collection_Id}
    Edit Asset Collection Attribute	 EditOfCol_AttRegressionProduct1_siscase1_withoutCol_ID.json    ${asset_Id_Product1}
    run keyword if  ${Asset_Owner_Ref_edit} != ${Asset_Owner_Ref}   Fail	test1 Teardown
    run keyword if  ${Collection_Order_no_edit} != ${Collection_Order_no}   Fail	test1 Teardown
    run keyword if  ${Collection_Quote_no_edit} != ${Collection_Quote_no}   Fail	test1 Teardown
    run keyword if  ${Collection_Project_no_edit} == ${Collection_Project_no}   Fail	test1 Teardown
    log to console   "Project_No After Edit: " ${Collection_Project_no_edit}

7. Get the Colletion_ID
    [Tags]	Functional	current
    Get Collection_ID   ${asset_Id_Product1}

8. Validate Assst is part of New collection only
    [Tags]	Functional	GET    current
    ${response}  Get Collection Asset Link  ${Collection_Id}
    run keyword if  ${response} != (('${asset_Id_Product1}',),)    Fail	test1 Teardown

9. Validate Assst is Not part of Old collection and Old collection End dated
    [Tags]	Functional	GET    current
    ${response}  Get Asset Effective_END_DATE  ${Collection_Id}
    run keyword if  '${response}' != '((datetime.datetime(2999, 12, 31, 23, 59, 59),),)'    Fail	test1 Teardown
    log to console  "asset_pseudo_taxonomy_link Effective_END_Date For NEw Collection_ID": ${response}
    ${response}  Get Asset Effective_END_DATE  ${old_collection_ID}
    run keyword if  '${response}' == '((datetime.datetime(2999, 12, 31, 23, 59, 59),),)'    Fail	test1 Teardown
    log to console  "asset_pseudo_taxonomy_link Effective_END_Date For OLD Collection_ID": ${response}