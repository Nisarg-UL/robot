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
    Create Product2 Asset	CreationOfRegressionProduct2_withProduct1OwnerRef.json

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
	${state}=	Get Asset State  ${asset_Id_Product2}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown

7. Search Asset with taxonomy parameters & ownerReference Refiner
	[Tags]	Functional	asset   Search	POST    current
	set global variable  ${operator_value}  ${like_search_value}
	set global variable  ${field_value}  ${ownerReference_key}
	Search Asset    Asset_Search_with_taxonomyParameters_oneRefiner.json
	Extract asset search response   ${Asset_summary_json}
#	should be equal  ${Asset_user}  ${user_1}
	should be equal  ${Asset_total_count}   ${value_as_1}
#	should be equal  ${Asset_offset}    ${value_as_0}
#	should be equal  ${Asset_rows}   ${value_as_400}
    length should be  ${Asset_refiners}  ${value_as_1}
	length should be  ${Asset_list}  ${value_as_1}
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
	Extract ownerReference values from refiners dictionary  ${Asset_refiners}
	compare lists  ${RF_ownerReference_list}   ['${Asset_Owner_Ref}', ${value_as_1}]

7c. Validate findKeys Details
    [Tags]	Functional	asset   Search	POST    current
    Extract searchParameters from findKeys dictionary    ${Asset_findkeys}
    length should be  ${FK_searchParameters_dict}     ${value_as_5}
    Extract productType values from searchParameters dictionary   ${FK_searchParameters_dict}
    compare lists  ${SP_productType_values}  ["${product_type_1}", "${like_search_value}"]
    Extract modelName values from searchParameters dictionary   ${FK_searchParameters_dict}
    compare lists   ${SP_modelName_values}    ["${model_name_1}_${current_time}", "${like_search_value}"]
    Extract referenceNumber values from searchParameters dictionary   ${FK_searchParameters_dict}
    compare lists  ${SP_referenceNumber_values}  ["${reference_number_1}", "${like_search_value}"]
    Extract ownerReference values from searchParameters dictionary   ${FK_searchParameters_dict}
    compare lists  ${SP_ownerReference_values}   ["${Asset_Owner_Ref}", "${like_search_value}"]
    Extract family_Series values from searchParameters dictionary   ${FK_searchParameters_dict}
    compare lists  ${SP_family_Series_values}    ["${family_series_1}-${current_time}", "${like_search_value}"]