*** Settings ***
Documentation	SIS Regression TestSuite
Resource	../../../../resource/ApiFunctions.robot

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

4. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productevaluationsetup.json	${asset_Id_Product1}

5. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

6. Edit Product1 Col_Attribute (Project_Number)
    [Tags]	Functional	asset	create	POST    current
    log to console   "Project_No before Edit: " ${Collection_Project_no}
    set global variable  ${old_collection_ID}   ${Collection_Id}
    Edit Asset Collection Attribute	 EditOfCol_AttRegressionProduct1_siscase1_withoutCol_ID.json    ${asset_Id_Product1}
    run keyword if  ${Asset_Owner_Ref_edit} != ${Asset_Owner_Ref}   Fail	test1 Teardown
    run keyword if  ${Collection_Order_no_edit} != ${Collection_Order_no}   Fail	test1 Teardown
    run keyword if  ${Collection_Quote_no_edit} != ${Collection_Quote_no}   Fail	test1 Teardown
    run keyword if  ${Collection_Project_no_edit} == ${Collection_Project_no}   Fail	test1 Teardown
    log to console   "Project_No After Edit: " ${Collection_Project_no_edit}

7. Get Evaluation Scope
    [Tags]	Functional	current
    ${comments}=	Get Evaluation Scope Comments  ${std_transaction_Id}
    run keyword if	'${comments}' != 'This is Evaluation scope Test'	Fail	test1a Teardown
    log to console	"Evaluation Scope Comments": ${comments}