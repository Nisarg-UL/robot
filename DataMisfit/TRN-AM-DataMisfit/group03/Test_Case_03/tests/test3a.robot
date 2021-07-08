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
    create product1 asset	group03/Test_Case_03/inputrequest/CreateProduct1a.json

4. Check for Asset State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_Asset_State": ${state}

5. Get the Colletion_ID
    [Tags]	Functional	current
    Get Collection_ID   ${asset_Id_Product1}
    set global variable  ${product_collection_id}   ${collection_id}

6. Validate above Asset's part of same collection
    [Tags]	Functional	GET    current
    ${response}  Get Collection Asset Link  ${Collection_Id}
    run keyword if  ${response} != (('${asset_Id_Product1}',), )    Fail	test1 Teardown

7. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productnoevalreqd.json	${asset_Id_Product1}

8. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${response}  Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId}     ${response}
	set global variable	${assessmentId1}	${assessmentId}

9. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}

10. End Date Misfit Testing PET_V1
	[Tags]	Functional	POST	current
	Expire PET   ${data_misfit_testing_v1_hierarchy_Id}

11. Post Date Misfit Testing PET_V2
	[Tags]	Functional	POST	current
	Activate PET   ${data_misfit_testing_v2_hierarchy_Id}

12. View Asset Details
	[Tags]	Functional	POST	current
    Get Asset Details   ${asset_Id_Product1}

13. Modify Product1
	[Tags]	Functional	POST	current
    Modify Product1 Asset   group03/Test_Case_03/inputrequest/ModifyProduct1a.json    ${asset_Id_Product1}
    ${data_grp_att1}     Get Asset Attribute Value with seq    ${response_api.json()}  dataGroupAttribute5   1
	run keyword if  '${data_grp_att1}' != '1'  Fail	test1 Teardown
	${data_grp_att2}     Get Asset Attribute Value with seq    ${response_api.json()}  dataGroupAttribute6   1
	run keyword if  '${data_grp_att2}' != '0.1'  Fail	test1 Teardown
	${data_grp_att3}     Get Asset Attribute Value with seq    ${response_api.json()}  dataGroupAttribute7   1
	run keyword if  '${data_grp_att3}' != 'Yes'  Fail	test1 Teardown
	${data_grp_att4}     Get Asset Attribute Value with seq    ${response_api.json()}  dataGroupAttribute8   1
	run keyword if  '${data_grp_att4}' != 'Up'  Fail	test1 Teardown
	${data_grp_att12}     Get Asset Attribute Value with seq    ${response_api.json()}  dataGroupAttribute5   2
	run keyword if  '${data_grp_att12}' != '2'  Fail	test1 Teardown
	${data_grp_att22}     Get Asset Attribute Value with seq    ${response_api.json()}  dataGroupAttribute6   2
	run keyword if  '${data_grp_att22}' != '0.2'  Fail	test1 Teardown
	${data_grp_att32}     Get Asset Attribute Value with seq    ${response_api.json()}  dataGroupAttribute7   2
	run keyword if  '${data_grp_att32}' != 'No'  Fail	test1 Teardown
	${data_grp_att42}     Get Asset Attribute Value with seq    ${response_api.json()}  dataGroupAttribute8   2
	run keyword if  '${data_grp_att42}' != 'Down'  Fail	test1 Teardown
	${data_grp_att13}     Get Asset Attribute Value with seq    ${response_api.json()}  dataGroupAttribute5   3
	run keyword if  '${data_grp_att13}' != '3'  Fail	test1 Teardown
	${data_grp_att23}     Get Asset Attribute Value with seq    ${response_api.json()}  dataGroupAttribute6   3
	run keyword if  '${data_grp_att23}' != '0.3'  Fail	test1 Teardown
	${data_grp_att33}     Get Asset Attribute Value with seq    ${response_api.json()}  dataGroupAttribute7   3
	run keyword if  '${data_grp_att33}' != ''  Fail	test1 Teardown
	${data_grp_att43}     Get Asset Attribute Value with seq    ${response_api.json()}  dataGroupAttribute8   3
	run keyword if  '${data_grp_att43}' != 'Top'  Fail	test1 Teardown
#    set test variable	${data_grp_att1}	${response_api.json()["data"]["attributes"][10]["value"]}
#	run keyword if  '${data_grp_att1}' != '1'  Fail	test1 Teardown
#	set test variable	${data_grp_att2}	${response_api.json()["data"]["attributes"][11]["value"]}
#	run keyword if  '${data_grp_att2}' != '0.1'  Fail	test1 Teardown
#	set test variable	${data_grp_att3}	${response_api.json()["data"]["attributes"][12]["value"]}
#	run keyword if  '${data_grp_att3}' != 'Yes'  Fail	test1 Teardown
#	set test variable	${data_grp_att4}	${response_api.json()["data"]["attributes"][13]["value"]}
#	run keyword if  '${data_grp_att4}' != 'Up'  Fail	test1 Teardown
#	set test variable	${data_grp_att12}	${response_api.json()["data"]["attributes"][14]["value"]}
#	run keyword if  '${data_grp_att12}' != '2'  Fail	test1 Teardown
#	set test variable	${data_grp_att22}	${response_api.json()["data"]["attributes"][15]["value"]}
#	run keyword if  '${data_grp_att22}' != '0.2'  Fail	test1 Teardown
#	set test variable	${data_grp_att32}	${response_api.json()["data"]["attributes"][16]["value"]}
#	run keyword if  '${data_grp_att32}' != 'No'  Fail	test1 Teardown
#	set test variable	${data_grp_att42}	${response_api.json()["data"]["attributes"][17]["value"]}
#	run keyword if  '${data_grp_att42}' != 'Down'  Fail	test1 Teardown
#	set test variable	${data_grp_att13}	${response_api.json()["data"]["attributes"][18]["value"]}
#	run keyword if  '${data_grp_att13}' != '3'  Fail	test1 Teardown
#	set test variable	${data_grp_att23}	${response_api.json()["data"]["attributes"][19]["value"]}
#	run keyword if  '${data_grp_att23}' != '0.3'  Fail	test1 Teardown
#	set test variable	${data_grp_att33}	${response_api.json()["data"]["attributes"][20]["value"]}
#	run keyword if  '${data_grp_att33}' != ''  Fail	test1 Teardown
#	set test variable	${data_grp_att43}	${response_api.json()["data"]["attributes"][21]["value"]}
#	run keyword if  '${data_grp_att43}' != 'Top'  Fail	test1 Teardown

