*** Settings ***
Documentation	SingleModel TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***


*** Test Cases ***
1. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    create product1 asset	CreationOfRegressionProduct1.json

2. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    Create Product1 Asset2	CreationOfRegressionProduct1_withSameOwnerRef.json

3. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productnoevalreqd.json	${asset_Id_Product1}

4. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${assessmentId1}  Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId1}	${assessmentId}

5. Complete Evaluation
	[Tags]	Functional	POST	current
	set global variable	${assessmentId}	${assessmentId1}
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}

6. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'immutable'	Fail	test1a Teardown
	${state}=	Get Asset State  ${asset2_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown

7. Search Asset with family_SeriesList & referenceNumber Refiner
	[Tags]	Functional	asset   Search	POST    current
	set global variable  ${field_value}  ${referenceNumber_key}
	Search Asset    Asset_Search_with_familySeriesList_oneRefiner.json
	Extract asset search response   ${Asset_summary_json}
#	should be equal  ${Asset_user}  ${user_1}
	should not be equal  ${Asset_total_count}   ${value_as_0}
#	should be equal  ${Asset_offset}    ${value_as_0}
#	should be equal  ${Asset_rows}   ${value_as_400}
    length should be  ${Asset_refiners}  ${value_as_1}
	should not be equal  ${Asset_list}  ${value_as_0}
#	length should be  ${Asset_findkeys}  ${value_as_1}

7a. Validate Asset Details
    [Tags]	Functional	asset   Search	POST    current
	Extract values from asset list  ${Asset_list}
	list should contain value   ${UL_assetId}   ${asset_Id_Product1}
	list should contain value   ${Asset_Id}   ${asset_Id_Product1}
	list should contain value   ${UL_assetId}   ${asset2_Id_Product1}
	list should contain value   ${Asset_Id}   ${asset2_Id_Product1}
	Extract values from taxonomy list  ${Asset_taxonomy}
	list should contain value   ${Asset_owner_reference}   ${Asset1_Owner_Ref}
	list should contain value   ${Asset_owner_reference}   ${Asset2_Owner_Ref}

7b. Validate Refiner Details
    [Tags]	Functional	asset   Search	POST    current
	Extract referenceNumber values from refiners dictionary  ${Asset_refiners}
	should not be empty  ${RF_referenceNumber_list}

7c. Validate findKeys Details
    [Tags]	Functional	asset   Search	POST    current
    Extract family_SeriesList values from findKeys dictionary   ${Asset_findkeys}
    compare lists  ${FK_family_Series_values}    ["${family_series_1}-${current_time}"]