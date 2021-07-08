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
	set test variable  ${family_series_1}  ${family_series_2}
	set test variable  ${model_name_1}  ${model_name_2}
	Create Product1 Asset2	CreationOfRegressionProduct2.json

3. Search multiple values for Draft asset with all valid Lists
	[Tags]	Functional	asset   Search	POST    current
	set global variable  ${status_value}  ${status_Draft}
	Search Asset    Asset_Search_with_all_Lists_multiple.json
	Extract asset search response   ${Asset_summary_json}
	should not be equal  ${Asset_total_count}   ${value_as_0}
#	should be equal  ${Asset_offset}    ${value_as_0}
#	should be equal  ${Asset_rows}   ${value_as_400}
    length should be  ${Asset_list}  ${value_as_400}
	should be empty  ${Asset_refiners}
	length should be  ${Asset_findkeys}  ${value_as_6}
#	should be equal  ${Asset_user}  ${user_1}

3a. Validate Asset Details
    [Tags]	Functional	asset   Search	POST    current
	Extract values from asset list  ${Asset_list}
	list should contain value   ${UL_assetId}   ${asset_Id_Product1}
	list should contain value   ${Asset_Id}   ${asset_Id_Product1}
	list should contain value   ${UL_assetId}   ${asset2_Id_Product1}
	list should contain value   ${Asset_Id}   ${asset2_Id_Product1}
	Extract values from taxonomy list  ${Asset_taxonomy}
	list should contain value   ${Asset_product_type}    ${product_type_1}
	list should contain value   ${Asset_product_type}    ${product_type_2}
	list should contain value   ${Asset_owner_reference}   ${Asset1_Owner_Ref}
	list should contain value   ${Asset_owner_reference}    ${Asset2_Owner_Ref}
	list should contain value   ${Asset_reference_number}    ${reference_number_1}
	list should contain value   ${Asset_reference_number}    ${reference_number_2}
	list should contain value   ${Asset_family_series}    ${family_series_1}-${current_time}
	list should contain value   ${Asset_family_series}    ${family_series_2}-${current_time}


3b. Validate findKeys Details
    [Tags]	Functional	asset   Search	POST    current
    Extract productTypeList values from findKeys dictionary  ${Asset_findkeys}
    compare lists  ${FK_productType_values}    ["${product_type_1}", "${product_type_2}"]
    Extract ownerReferenceList values from findKeys dictionary  ${Asset_findkeys}
    compare lists  ${FK_ownerReference_values}  ["${Asset_Owner_Ref}", "${Asset2_Owner_Ref}"]
    Extract referenceNumberList values from findKeys dictionary  ${Asset_findkeys}
	compare lists  ${FK_referenceNumber_values}    ["${reference_number_1}", "${reference_number_2}"]
	Extract family_SeriesList values from findKeys dictionary    ${Asset_findkeys}
	compare lists  ${FK_family_Series_values}   ["${family_series_1}-${current_time}", "${family_series_2}-${current_time}"]
	Extract statusList values from findKeys dictionary    ${Asset_findkeys}
	compare lists  ${FK_status_values}   ["${status_Draft}", "${status_Draft}"]