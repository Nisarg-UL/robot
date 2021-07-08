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
	set test variable  ${reference_number_1}  ${reference_number_2}
    Create Product1 Asset2	CreationOfRegressionProduct1_withSameOwnerRef.json

3. Search Asset with orderBy value as +referenceNumber
	[Tags]	Functional	asset   Search	POST    current
	set global variable  ${orderBy_value}  +referenceNumber
	Search Asset     Asset_Search_with_orderBy.json
	Extract asset search response   ${Asset_summary_json}
	should not be equal  ${Asset_total_count}   ${value_as_0}
#	should be equal  ${Asset_offset}    ${value_as_0}
#	should be equal  ${Asset_rows}   ${value_as_400}
	should not be empty  ${Asset_list}
	should be empty  ${Asset_refiners}
	should not be empty  ${Asset_findkeys}
#	should be empty  ${Asset_user}

3a. Validate Asset Details
    [Tags]	Functional	asset   Search	POST    current
	Extract values from asset list  ${Asset_list}
	Compare lists  [${Asset_status}, ${asset_version}, ${isPLAsset}, ${Asset_model_nomenclature}, ${Asset_created_by}, ${Asset_updated_by}]   [["${status_Draft}", "${status_Draft}"], ["${value_as_1.0}", "${value_as_1.0}"], ["${value_as_N}", "${value_as_N}"], ["${modelNomenclature_1}", "${modelNomenclature_1}"], ["${user_2}", "${user_2}"], ["${user_2}", "${user_2}"]]
	compare lists  ${Asset_Id}  ["${asset_Id_Product1}", "${asset2_Id_Product1}"]
	compare lists  ${UL_Asset_Id}  ["${asset_Id_Product1}", "${asset2_Id_Product1}"]
	compare lists  ${Asset_hierarchyId}  ["${regression_product_1_hierarchy_id}", "${regression_product_1_hierarchy_id}"]
	compare lists  ${Asset_collectionId}    ["${Asset1_Collection_Id}", "${Asset2_Collection_Id}"]
	Extract values from taxonomy list  ${Asset_taxonomy}
	compare lists  ${Asset_product_type}    ["${product_type_1}", "${product_type_1}"]
	compare lists  ${Asset_model_name}   ["${model_name_1}_${current_time}", "${model_name_2}_${current_time}"]
	compare lists  ${Asset_owner_reference}  ["${Asset1_Owner_Ref}", "${Asset2_Owner_Ref}"]
	compare lists  ${Asset_family_series}    ["${family_series_1}-${current_time}", "${family_series_1}-${current_time}"]
	compare lists  ${Asset_creation_date}    ["${today_date}", "${today_date}"]
	compare lists  ${Asset_reference_number}    ["${reference_number_1}", "${reference_number_2}"]

3b. Validate findKeys Details
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