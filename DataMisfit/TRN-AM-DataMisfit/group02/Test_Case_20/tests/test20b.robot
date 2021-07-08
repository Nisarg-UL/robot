*** Settings ***
Documentation	Data Misfit TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***
test1 Teardown
	Log To Console	test1a Teardown Beginning
	Expire The Asset	${asset_Id_Product1}
	Log To Console	test1a Teardown Finished

*** Test Cases ***
1a. Setting up Environment
	set global variable	${asset_Id_Product1}

1. End Date Misfit Testing PET_V2
	[Tags]	Functional	POST	current
	Expire PET   ${data_misfit_testing_v2_hierarchy_Id}

2. Post Date Misfit Testing PET_V1
	[Tags]	Functional	POST	current
	Activate PET   ${data_misfit_testing_v1_hierarchy_Id}

3. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    create product1 asset	group02/Test_Case_01/inputrequest/CreateProduct1.json

4. Check for Asset State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_Asset_State": ${state}

5. Get the Colletion_ID
    [Tags]	Functional	current
    Get Collection_ID   ${asset_Id_Product1}
    set global variable  ${product_collection_id}   ${collection_id}

6. Product 2 Asset1 Creation based on product1 Asset1
    [Tags]	Functional	asset	create	POST    current
    create product2 asset   group02/Test_Case_01/inputrequest/CreateComponent1.json

7. Check for Asset State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product2}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Component_Asset_State": ${state}

8. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productnoevalreqd.json	${asset_Id_Product2}

9. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product2}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

10. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${response}  Get AssesmentID	${asset_Id_Product2}
	set global variable	${assessmentId}     ${response}
	set global variable	${assessmentId2}	${assessmentId}

11. Complete Evaluation
	[Tags]	Functional	POST	current
	Mark Evaluation Complete	markevaluationcomplete_1asset.json	${asset_Id_Product2}

12. Link Component to Product
    [Tags]	Functional	current
    ${result}   Link Components to Asset    group02/Test_Case_20/inputrequest/Link_Product1toComponent1b.json     ${asset_Id_Product1}
	set global variable	${assetLinkSeqId}	${result.json()["data"]["hasComponents"][0]["assetAssetLinkSeqId"]}
	should not be empty  ${assetLinkSeqId}
	log to console  ${assetLinkSeqId}

13. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productnoevalreqd.json	${asset_Id_Product1}

14. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${response}  Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId}     ${response}
	set global variable	${assessmentId1}	${assessmentId}

15. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}

16. End Date Misfit Testing PET_V1
	[Tags]	Functional	POST	current
	Expire PET   ${data_misfit_testing_v1_hierarchy_Id}

17. Post Date Misfit Testing PET_V2
	[Tags]	Functional	POST	current
	Activate PET   ${data_misfit_testing_v2_hierarchy_Id}

18. View Asset Component Details
	[Tags]	Functional	POST	current
    Get Asset Component Details   ${asset_Id_Product1}

19. Modify Product1
	[Tags]	Functional	POST	current
    Modify Product1 Asset   group02/Test_Case_01/inputrequest/ModifyProduct1.json    ${asset_Id_Product1}

20. View Asset Component Details
	[Tags]	Functional	POST	current
    ${response}  Get Asset Component Details   ${asset_Id_Product12}
    should not be empty  ${response}
    ${data_group_add1}     Get Asset Linkage Value with seq    ${response}  dataGroupAdd1   1
	run keyword if  '${data_group_add1}' != '1'  Fail	test1 Teardown
	${data_group_add2}     Get Asset Linkage Value with seq    ${response}  dataGroupAdd2   1
	run keyword if  '${data_group_add2}' != '1.1'  Fail	test1 Teardown
	${data_group_add3}     Get Asset Linkage Value with seq    ${response}  dataGroupAdd3   1
	run keyword if  '${data_group_add3}' != 'Yes'  Fail	test1 Teardown
	${data_group_add4}     Get Asset Linkage Value with seq    ${response}  dataGroupAdd4   1
	run keyword if  '${data_group_add4}' != 'Up'  Fail	test1 Teardown
	${data_group_add12}     Get Asset Linkage Value with seq    ${response}  dataGroupAdd1   2
	run keyword if  '${data_group_add12}' != '3'  Fail	test1 Teardown
	${data_group_add22}     Get Asset Linkage Value with seq    ${response}  dataGroupAdd2   2
	run keyword if  '${data_group_add22}' != '3.1'  Fail	test1 Teardown
	${data_group_add32}     Get Asset Linkage Value with seq    ${response}  dataGroupAdd3   2
	run keyword if  '${data_group_add32}' != 'No'  Fail	test1 Teardown
	${data_group_add42}     Get Asset Linkage Value with seq    ${response}  dataGroupAdd4   2
	run keyword if  '${data_group_add42}' != 'Down'  Fail	test1 Teardown
	${data_group_add13}     Get Asset Linkage Value with seq    ${response}  dataGroupAdd1   3
	run keyword if  '${data_group_add13}' != '9'  Fail	test1 Teardown
	${data_group_add23}     Get Asset Linkage Value with seq    ${response}  dataGroupAdd2   3
	run keyword if  '${data_group_add23}' != '9.1'  Fail	test1 Teardown
	${data_group_add33}     Get Asset Linkage Value with seq    ${response}  dataGroupAdd3   3
	run keyword if  '${data_group_add33}' != ''  Fail	test1 Teardown
	${data_group_add43}     Get Asset Linkage Value with seq    ${response}  dataGroupAdd4   3
	run keyword if  '${data_group_add43}' != ''  Fail	test1 Teardown
#    set test variable	${data_group_add1}	${response[0]["hasAssetLinkage"][26]["value"]}
#	run keyword if  '${data_group_add1}' != '1'  Fail	test1 Teardown
#	set test variable	${data_group_add2}	${response[0]["hasAssetLinkage"][27]["value"]}
#	run keyword if  '${data_group_add2}' != '1.1'  Fail	test1 Teardown
#	set test variable	${data_group_add3}	${response[0]["hasAssetLinkage"][28]["value"]}
#	run keyword if  '${data_group_add3}' != 'Yes'  Fail	test1 Teardown
#	set test variable	${data_group_add4}	${response[0]["hasAssetLinkage"][29]["value"]}
#	run keyword if  '${data_group_add4}' != 'Up'  Fail	test1 Teardown
#	set test variable	${data_group_add12}	${response[0]["hasAssetLinkage"][30]["value"]}
#	run keyword if  '${data_group_add12}' != '3'  Fail	test1 Teardown
#	set test variable	${data_group_add22}	${response[0]["hasAssetLinkage"][31]["value"]}
#	run keyword if  '${data_group_add22}' != '3.1'  Fail	test1 Teardown
#	set test variable	${data_group_add32}	${response[0]["hasAssetLinkage"][32]["value"]}
#	run keyword if  '${data_group_add32}' != 'No'  Fail	test1 Teardown
#	set test variable	${data_group_add42}	${response[0]["hasAssetLinkage"][33]["value"]}
#	run keyword if  '${data_group_add42}' != 'Down'  Fail	test1 Teardown
#	set test variable	${data_group_add13}	${response[0]["hasAssetLinkage"][34]["value"]}
#	run keyword if  '${data_group_add13}' != '9'  Fail	test1 Teardown
#	set test variable	${data_group_add23}	${response[0]["hasAssetLinkage"][35]["value"]}
#	run keyword if  '${data_group_add23}' != '9.1'  Fail	test1 Teardown
#	set test variable	${data_group_add33}	${response[0]["hasAssetLinkage"][36]["value"]}
#	run keyword if  '${data_group_add33}' != ''  Fail	test1 Teardown
#	set test variable	${data_group_add43}	${response[0]["hasAssetLinkage"][37]["value"]}
#	run keyword if  '${data_group_add43}' != ''  Fail	test1 Teardown
