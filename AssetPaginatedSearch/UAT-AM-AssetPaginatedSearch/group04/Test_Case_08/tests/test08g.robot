*** Settings ***
Documentation	SingleModel TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***


*** Test Cases ***
1. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    create product1 asset	CreationOfRegressionProduct1.json

2. Check Asset State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

3. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productnoevalreqd.json	${asset_Id_Product1}

4. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

5. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${assessmentId}  Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId}	${assessmentId}

6. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}

7. Check Asset State After Evaluation
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'immutable'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

8. Search Asset with Completed as 'Y' & Accepted as Empty
	[Tags]	Functional	asset   Search	POST    current
	set global variable  ${completed_value}  ${value_as_Y}
	set global variable  ${accepted_value}   ${EMPTY}
	Search Asset     Asset_Search_with_completed&accepted.json
	Extract asset search response   ${Asset_summary_json}
	should not be equal  ${Asset_total_count}   ${value_as_0}
#	should be equal  ${Asset_offset}    ${value_as_0}
#	should be equal  ${Asset_rows}   ${value_as_400}
	should not be empty  ${Asset_list}
	should be empty  ${Asset_refiners}
	should not be empty  ${Asset_findkeys}
#	should be empty  ${Asset_user}

8a. Validate Asset Details
    [Tags]	Functional	asset   Search	POST    current
	Extract values from asset list  ${Asset_list}
	Compare lists  [${Asset_status}, ${asset_version}, ${isPLAsset}, ${Asset_model_nomenclature}, ${Asset_created_by}, ${Asset_updated_by}]   [["${status_Active}"], ["${value_as_1.0}"], ["${value_as_N}"], ["${modelNomenclature_1}"], ["${user_2}"], ["${user_1}"]]
	compare lists  [${UL_Asset_Id}, ${Asset_Id}, ${Asset_hierarchyId}, ${Asset_collectionId}]    [["${asset_Id_Product1}"], ["${asset_Id_Product1}"], ["${regression_product_1_hierarchy_id}"], ["${Asset1_Collection_Id}"]]
	Extract values from taxonomy list  ${Asset_taxonomy}
	Compare lists   [${Asset_product_type}, ${Asset_model_name}, ${Asset_reference_number}, ${Asset_owner_reference}, ${Asset_family_series}, ${Asset_creation_date}]    [["${product_type_1}"], ["${model_name_1}_${current_time}"], ["${reference_number_1}"], ["${Asset_Owner_Ref}"], ["${family_series_1}-${current_time}"], ["${today_date}"]]

8b. Validate findKeys Details
    [Tags]	Functional	asset   Search	POST    current
    Extract searchText from findKeys dictionary  ${Asset_findkeys}
    should be equal  ${FK_searchText}   ${Asset_Owner_Ref}
    Extract ownerReferenceList values from findKeys dictionary  ${Asset_findkeys}
    compare lists  ${FK_ownerReference_values}  [${EMPTY}]
#    Extract productTypeList values from findKeys dictionary  ${Asset_findkeys}
#    compare lists  ${FK_productType_values}    [${EMPTY}]
#    Extract referenceNumberList values from findKeys dictionary  ${Asset_findkeys}
#	compare lists  ${FK_referenceNumber_values}    [${EMPTY}]
#	Extract family_SeriesList values from findKeys dictionary    ${Asset_findkeys}
#	compare lists  ${FK_family_Series_values}   [${family_series_1}-${current_time}]