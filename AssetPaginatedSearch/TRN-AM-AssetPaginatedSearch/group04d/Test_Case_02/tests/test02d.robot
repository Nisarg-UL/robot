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
    Create Product1 Asset2	CreationOfRegressionProduct1.json

3. Search Asset with multiple ownerReferenceList values
	[Tags]	Functional	asset   Search	POST    current
	Search Asset    Asset_Search_with_ownerReferenceList_multiple.json
	Extract asset search response   ${Asset_summary_json}
	should be equal  ${Asset_total_count}   ${value_as_2}
#	should be equal  ${Asset_offset}    ${value_as_0}
#	should be equal  ${Asset_rows}   ${value_as_400}
    length should be  ${Asset_list}  ${value_as_2}
	should be empty  ${Asset_refiners}
#	length should be  ${Asset_findkeys}  ${value_as_5}
#	should be equal  ${Asset_user}  ${user_1}

3a. Validate Asset Details
    [Tags]	Functional	asset   Search	POST    current
	Extract values from asset list  ${Asset_list}
	compare lists   ${Asset_status}  ["${status_Draft}", "${status_Draft}"]
	Compare lists  [${asset_version}, ${isPLAsset}, ${Asset_model_nomenclature}, ${Asset_created_by}]   [["${value_as_1.0}", "${value_as_1.0}"], ["${value_as_N}", "${value_as_N}"], ["${modelNomenclature_1}", "${modelNomenclature_1}"], ["${user_2}", "${user_2}"]]
	compare lists  ${Asset_updated_by}   ["${user_2}", "${user_2}"]
	compare lists  ${Asset_Id}  ["${asset_Id_Product1}", "${asset2_Id_Product1}"]
	compare lists  ${UL_Asset_Id}  ["${asset_Id_Product1}", "${asset2_Id_Product1}"]
	compare lists  ${Asset_hierarchyId}  ["${regression_product_1_hierarchy_id}", "${regression_product_1_hierarchy_id}"]
	compare lists  ${Asset_collectionId}    ["${Asset1_Collection_Id}", "${Asset2_Collection_Id}"]
	Extract values from taxonomy list  ${Asset_taxonomy}
	compare lists  ${Asset_product_type}    ["${product_type_1}", "${product_type_1}"]
	compare lists  ${Asset_model_name}   ["${model_name_1}_${current_time}", "${model_name_1}_${current_time}"]
	compare lists  ${Asset_reference_number}    ["${reference_number_1}", "${reference_number_1}"]
	compare lists  ${Asset_owner_reference}  ["${Asset1_Owner_Ref}", "${Asset2_Owner_Ref}"]
	compare lists  ${Asset_family_series}    ["${family_series_1}-${current_time}", "${family_series_1}-${current_time}"]
	compare lists  ${Asset_creation_date}    ["${today_date}", "${today_date}"]

3b. Validate findKeys Details
    [Tags]	Functional	asset   Search	POST    current
    Extract ownerReferenceList values from findKeys dictionary  ${Asset_findkeys}
    compare lists  ${FK_ownerReference_values}  ["${Asset_Owner_Ref}", "${Asset2_Owner_Ref}"]