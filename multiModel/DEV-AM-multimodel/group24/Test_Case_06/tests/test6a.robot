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

1. Asset1 Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    create product1 asset	CreationOfRegressionProduct1_siscase1.json

2. Check for Asset1 State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_Asset_State": ${state}

3. Get the Colletion_ID
    [Tags]	Functional	current
    Get Collection_ID   ${asset_Id_Product1}
    set global variable     ${Product_Collection_Id}    ${Collection_Id}

4. Validate above Asset1's part of same collection
    [Tags]	Functional	GET    current
    ${response}  Get Collection Asset Link  ${Collection_Id}
    run keyword if  ${response} != (('${asset_Id_Product1}',),)    Fail	test1 Teardown

5. Component(Product2 Asset1) Creation based on product1 Asset1
    [Tags]	Functional	asset	create	POST    current
    create product2 asset   CreationOfRegressionProduct2_siscase1.json
    set global variable  ${Component_ID}    ${asset_Id_Product2}

6. Check for Component State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product2}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Component_Asset_State": ${state}

7. Standard Assignment To Component (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productnoevalreqd.json	${asset_Id_Product2}

8. Check Component State After Associating Standard to Component
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product2}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

9. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	Get AssesmentID	${asset_Id_Product2}

10. Complete Evaluation for Component
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product2}
    Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product2}

11. Link Component to Asset1
    [Tags]	Functional	current
    ${result}   Link Components to Asset    Link_Product1toComponent1withoutLinkageDetails&somemandatoryattributeempty.json     ${asset_Id_Product1}
	set global variable	${assetLinkSeqId}	${result.json()["data"]["hasComponents"][0]["assetAssetLinkSeqId"]}
	should not be empty  ${assetLinkSeqId}
	log to console  ${assetLinkSeqId}

12. Asset2 Creation with POST Request
    [Tags]	Functional	asset	create	POST    current
    create Asset2 based on product1 Asset1   CreationOfRegressionProduct1Asset2_siscase1_withCol_ID.json

13. Validate above Asset2's part of same collection
    [Tags]	Functional	GET    current
    ${response}  Get Collection Asset Link  ${Collection_Id}
    run keyword if  ${response} != (('${asset_Id_Product1}',), ('${asset_Id_Product12}',))    Fail	test1 Teardown

14. Asset3 Creation with POST Request
    [Tags]	Functional	asset	create	POST    current
    create Asset3 based on product1 Asset1   CreationOfRegressionProduct1Asset3_siscase1_withCol_ID.json

15. Validate above Asset3's part of same collection
    [Tags]	Functional	GET    current
    ${response}  Get Collection Asset Link  ${Collection_Id}
    run keyword if  ${response} != (('${asset_Id_Product1}',), ('${asset_Id_Product12}',), ('${asset_Id_Product13}',))    Fail	test1 Teardown

16. Asset4 Creation with POST Request
    [Tags]	Functional	asset	create	POST    current
    create Asset4 based on product1 Asset1   CreationOfRegressionProduct1Asset4_siscase1_withCol_ID.json

17. Validate above Asset4's part of same collection
    [Tags]	Functional	GET    current
    ${response}  Get Collection Asset Link  ${Collection_Id}
    run keyword if  ${response} != (('${asset_Id_Product1}',), ('${asset_Id_Product12}',), ('${asset_Id_Product13}',), ('${asset_Id_Product14}',))    Fail	test1 Teardown

18. Asset5 Creation with POST Request
    [Tags]	Functional	asset	create	POST    current
    create Asset5 based on product1 Asset1   CreationOfRegressionProduct1Asset5_siscase1_withCol_ID.json

19. Validate above Asset5's part of same collection
    [Tags]	Functional	GET    current
    ${response}  Get Collection Asset Link  ${Collection_Id}
    run keyword if  ${response} != (('${asset_Id_Product1}',), ('${asset_Id_Product12}',), ('${asset_Id_Product13}',), ('${asset_Id_Product14}',), ('${asset_Id_Product15}',))    Fail	test1 Teardown

20. Standard Assignment To All Assets in Collection (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productnoevalreqd.json	${asset_Id_Product1}
	standard assignment	productnoevalreqd.json	${asset_Id_Product12}
	standard assignment	productnoevalreqd.json	${asset_Id_Product13}
	standard assignment	productnoevalreqd.json	${asset_Id_Product14}
	standard assignment	productnoevalreqd.json	${asset_Id_Product15}

21. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	${state2}=	Get Asset State	${asset_Id_Product12}
	run keyword if	'${state2}' != 'associated'	Fail	test1a Teardown
	${state3}=	Get Asset State	${asset_Id_Product12}
	run keyword if	'${state3}' != 'associated'	Fail	test1a Teardown
	${state4}=	Get Asset State	${asset_Id_Product12}
	run keyword if	'${state4}' != 'associated'	Fail	test1a Teardown
	${state5}=	Get Asset State	${asset_Id_Product12}
	run keyword if	'${state5}' != 'associated'	Fail	test1a Teardown

22. Validate and Update Compliance Collection Level
    [Tags]	Functional	current
    ${result}    Validate and Update Compliance Collection Level  Update_ComplianceAll.json  ${collection_Id}
	run keyword if	'${result}' != 'successfully validated'	Fail	test1a Teardown
	should not be empty  ${Validation_Errors}
	${msg}  Get Validation Error for Update Compliance Collection Level   ${response_api}    ${asset_Id_Product1}
	run keyword if  '${msg}' != 'Required information is missing from the Product Details tab and\/or the Components tab.'  Fail	test1 Teardown
	log to console  ${msg}


