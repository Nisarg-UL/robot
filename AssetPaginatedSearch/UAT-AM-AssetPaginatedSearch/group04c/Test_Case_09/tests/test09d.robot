*** Settings ***
Documentation	SingleModel TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***


*** Test Cases ***
1. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    create product1 asset	CreationOfRegressionProduct1.json

2. Search Asset with valid orderNumber
	[Tags]	Functional	asset   Search	POST    current
	set global variable  ${searchParameter_key}  ${orderNumber_key}
	set global variable  ${operator_value}  ${like_search_value}
	set global variable  ${searchParameter_value}   ${Asset1_Collection_Order_no}
	Search Asset    Asset_Search_with_collectionParameter.json
	Extract asset search response   ${Asset_summary_json}
	should be equal  ${Asset_total_count}   ${value_as_1}
#	should be equal  ${Asset_offset}    ${value_as_0}
#	should be equal  ${Asset_rows}   ${value_as_400}
	length should be  ${Asset_list}  ${value_as_1}
	should be empty  ${Asset_refiners}
#	length should be  ${Asset_findkeys}  ${value_as_6}
#	should be equal  ${Asset_user}  ${user_1}

2a. Validate Asset Details
    [Tags]	Functional	asset   Search	POST    current
	Extract values from asset list  ${Asset_list}
	Compare lists  [${Asset_status}, ${asset_version}, ${isPLAsset}, ${Asset_model_nomenclature}, ${Asset_created_by}, ${Asset_updated_by}]   [["${status_Draft}"], ["${value_as_1.0}"], ["${value_as_N}"], ["${modelNomenclature_1}"], ["${user_2}"], ["${user_2}"]]
	compare lists  [${UL_Asset_Id}, ${Asset_Id}, ${Asset_hierarchyId}, ${Asset_collectionId}]    [["${asset_Id_Product1}"], ["${asset_Id_Product1}"], ["${regression_product_1_hierarchy_id}"], ["${Asset1_Collection_Id}"]]
	Extract values from taxonomy list  ${Asset_taxonomy}
	Compare lists   [${Asset_product_type}, ${Asset_model_name}, ${Asset_reference_number}, ${Asset_owner_reference}, ${Asset_family_series}, ${Asset_creation_date}]    [["${product_type_1}"], ["${model_name_1}_${current_time}"], ["${reference_number_1}"], ["${Asset1_Owner_Ref}"], ["${family_series_1}-${current_time}"], ["${today_date}"]]

2b. Validate findKeys Details
    [Tags]	Functional	asset   Search	POST    current
    Extract searchParameters from findKeys dictionary    ${Asset_findkeys}
    should not be empty  ${FK_searchParameters_dict}
    Extract orderNumber values from searchParameters dictionary   ${FK_searchParameters_dict}
    compare lists  ${SP_orderNumber_values}   ["${Asset1_Collection_Order_no}", "${like_search_value}"]