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

7. Search Asset with all Lists & referenceNumber Refiner
	[Tags]	Functional	asset   Search	POST    current
	set global variable  ${field_value}  ${referenceNumber_key}
	set global variable  ${status_value}  ${status_Active}
	Search Asset    Asset_Search_with_all_Lists_oneRefiner.json
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
	Compare lists  [${Asset_status}, ${asset_version}, ${isPLAsset}, ${Asset_model_nomenclature}, ${Asset_created_by}, ${Asset_updated_by}]   [["${status_Active}"], ["${value_as_1.0}"], ["${value_as_N}"], ["${modelNomenclature_1}"], ["${user_2}"], ["${user_1}"]]
	compare lists  [${UL_Asset_Id}, ${Asset_Id}, ${Asset_hierarchyId}, ${Asset_collectionId}]    [["${asset_Id_Product1}"], ["${asset_Id_Product1}"], ["${regression_product_1_hierarchy_id}"], ["${Asset1_Collection_Id}"]]
	Extract values from taxonomy list  ${Asset_taxonomy}
	Compare lists   [${Asset_product_type}, ${Asset_model_name}, ${Asset_reference_number}, ${Asset_owner_reference}, ${Asset_family_series}, ${Asset_creation_date}]    [["${product_type_1}"], ["${model_name_1}_${current_time}"], ["${reference_number_1}"], ["${Asset1_Owner_Ref}"], ["${family_series_1}-${current_time}"], ["${today_date}"]]

7b. Validate Refiner Details
    [Tags]	Functional	asset   Search	POST    current
	Extract referenceNumber values from refiners dictionary  ${Asset_refiners}
	should not be empty  ${RF_referenceNumber_list}

7c. Validate findKeys Details
    [Tags]	Functional	asset   Search	POST    current
    Extract ownerReferenceList values from findKeys dictionary  ${Asset_findkeys}
    compare lists  ${FK_ownerReference_values}  ["${Asset_Owner_Ref}"]
    Extract productTypeList values from findKeys dictionary  ${Asset_findkeys}
    compare lists  ${FK_productType_values}    ["${product_type_1}"]
    Extract referenceNumberList values from findKeys dictionary  ${Asset_findkeys}
	compare lists  ${FK_referenceNumber_values}    ["${reference_number_1}"]
	Extract family_SeriesList values from findKeys dictionary    ${Asset_findkeys}
	compare lists  ${FK_family_Series_values}   ["${family_series_1}-${current_time}"]
	Extract statusList values from findKeys dictionary    ${Asset_findkeys}
	compare lists  ${FK_status_values}   ["${status_Active}"]