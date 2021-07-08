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

4. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

5. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${assessmentId1}  Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId1}	${assessmentId}

6. Complete Evaluation
	[Tags]	Functional	POST	current
	set global variable	${assessmentId}	${assessmentId1}
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}

7. Search Asset with all valid values
	[Tags]	Functional	asset   Search	POST    current
	set test variable   ${like_search_value}   ${EMPTY}
	Search Asset    Asset_Search_with_all_searchParameters_likeSearch.json
	Extract asset search response   ${Asset_summary_json}
	should be equal  ${Asset_total_count}   ${value_as_1}
#	should be equal  ${Asset_offset}    ${value_as_0}
#	should be equal  ${Asset_rows}   ${value_as_400}
	should not be empty  ${Asset_list}
	should be empty  ${Asset_refiners}
	should not be empty  ${Asset_findkeys}
#	should be equal  ${Asset_user}  ${user_1}

7a. Validate Asset Details
    [Tags]	Functional	asset   Search	POST    current
	Extract values from asset list  ${Asset_list}
	Compare lists  [${Asset_status}, ${asset_version}, ${isPLAsset}, ${Asset_model_nomenclature}, ${Asset_created_by}, ${Asset_updated_by}]   [["${status_Active}"], ["${value_as_1.0}"], ["${value_as_N}"], ["${modelNomenclature_1}"], ["${user_2}"], ["${user_1}"]]
	compare lists  [${UL_Asset_Id}, ${Asset_Id}, ${Asset_hierarchyId}, ${Asset_collectionId}]    [["${asset_Id_Product1}"], ["${asset_Id_Product1}"], ["${regression_product_1_hierarchy_id}"], ["${Asset1_Collection_Id}"]]
	Extract values from taxonomy list  ${Asset_taxonomy}
	Compare lists   [${Asset_product_type}, ${Asset_model_name}, ${Asset_reference_number}, ${Asset_owner_reference}, ${Asset_family_series}, ${Asset_creation_date}]    [["${product_type_1}"], ["${model_name_1}_${current_time}"], ["${reference_number_1}"], ["${Asset1_Owner_Ref}"], ["${family_series_1}-${current_time}"], ["${today_date}"]]

7b. Validate findKeys Details
    [Tags]	Functional	asset   Search	POST    current
    Extract searchParameters from findKeys dictionary    ${Asset_findkeys}
    should not be empty  ${FK_searchParameters_dict}

2c. Validate searchParameters Details
    [Tags]	Functional	asset   Search	POST    current
    Extract productType values from searchParameters dictionary   ${FK_searchParameters_dict}
    compare lists  ${SP_productType_values}  ["${product_type}", "${like_search_value}"]
    Extract modelName values from searchParameters dictionary   ${FK_searchParameters_dict}
    compare lists   ${SP_modelName_values}    ["${model_name_1}", "${like_search_value}"]
    Extract referenceNumber values from searchParameters dictionary   ${FK_searchParameters_dict}
    compare lists  ${SP_referenceNumber_values}  ["${reference_number}", "${like_search_value}"]
    Extract ownerReference values from searchParameters dictionary   ${FK_searchParameters_dict}
    compare lists  ${SP_ownerReference_values}   ["${Asset_Owner_Ref}", "${like_search_value}"]
    Extract family_Series values from searchParameters dictionary   ${FK_searchParameters_dict}
    compare lists  ${SP_family_Series_values}    ["${today_date}", "${like_search_value}"]
    Extract collectionName values from searchParameters dictionary   ${FK_searchParameters_dict}
    compare lists  ${SP_collectionName_values}   ["${collection}", "${like_search_value}"]
    Extract projectNumber values from searchParameters dictionary   ${FK_searchParameters_dict}
    compare lists  ${SP_projectNumber_values}    ["${Asset1_Collection_Project_no}", "${like_search_value}"]
    Extract quoteNumber values from searchParameters dictionary   ${FK_searchParameters_dict}
    compare lists  ${SP_quoteNumber_values}  ["${Asset1_Collection_Quote_no}", "${like_search_value}"]
    Extract orderNumber values from searchParameters dictionary   ${FK_searchParameters_dict}
    compare lists  ${SP_orderNumber_values}  ["${Asset1_Collection_Order_no}", "${like_search_value}"]