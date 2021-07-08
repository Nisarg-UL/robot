*** Settings ***
Documentation	SingleModel TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***


*** Test Cases ***
1. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
	set test variable  ${model_name_1}  ${model_name_2}
    create product1 asset	CreationOfRegressionProduct1.json

2. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    set test variable  ${family_series_1}  ${family_series_2}
    Create Product1 Asset2	CreationOfRegressionProduct2.json

3. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productnoevalreqd.json	${asset_Id_Product1}
	standard assignment	productnoevalreqd.json	${asset2_Id_Product1}

4. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}
	${state}=	Get Asset State	${asset2_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

5. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${assessmentId1}  Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId1}	${assessmentId}
	${assessmentId2}  Get AssesmentID	${asset2_Id_Product1}
	set global variable	${assessmentId2}	${assessmentId}

6. Complete Evaluation
	[Tags]	Functional	POST	current
	set global variable	${assessmentId}	${assessmentId1}
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}
	set global variable	${assessmentId}	${assessmentId2}
	Complete Evaluation	markevaluationcomplete.json	${asset2_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset2_Id_Product1}

7. Search Active Assets with multiple valid familySeriesList value
	[Tags]	Functional	asset   Search	POST    current
	Search Asset    Asset_Search_with_familySeriesList_multiple.json
	Extract asset search response   ${Asset_summary_json}
	should not be equal  ${Asset_total_count}   ${value_as_0}
#	should be equal  ${Asset_offset}    ${value_as_0}
#	should be equal  ${Asset_rows}   ${value_as_400}
    length should be  ${Asset_list}  ${value_as_400}
	should be empty  ${Asset_refiners}
	length should be  ${Asset_findkeys}  ${value_as_6}
#	should be equal  ${Asset_user}  ${user_1}

7a. Validate Asset Details
    [Tags]	Functional	asset   Search	POST    current
	Extract values from asset list  ${Asset_list}
	list should contain value   ${UL_assetId}   ${asset_Id_Product1}
	list should contain value   ${Asset_Id}   ${asset_Id_Product1}
	list should contain value   ${UL_assetId}   ${asset2_Id_Product1}
	list should contain value   ${Asset_Id}   ${asset2_Id_Product1}
	Extract values from taxonomy list  ${Asset_taxonomy}
	list should contain value   ${Asset_family_series}    ${family_series_1}-${current_time}
	list should contain value   ${Asset_family_series}    ${family_series_2}-${current_time}

7b. Validate findKeys Details
    [Tags]	Functional	asset   Search	POST    current
    Extract family_SeriesList values from findKeys dictionary    ${Asset_findkeys}
	compare lists  ${FK_family_Series_values}   ["${family_series_1}-${current_time}", "${family_series_2}-${current_time}"]