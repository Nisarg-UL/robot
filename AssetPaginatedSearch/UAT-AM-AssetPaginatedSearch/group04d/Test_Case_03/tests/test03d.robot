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
    Create Product1 Asset2	CreationOfRegressionProduct1_siscase1_withSameOwnerRef.json

3. Search Draft Assets with multiple referenceNumberList values
	[Tags]	Functional	asset   Search	POST    current
	Search Asset    Asset_Search_with_referenceNumberList_multiple.json
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
	list should contain value   ${Asset_reference_number}    ${reference_number_1}
	list should contain value   ${Asset_reference_number}    ${reference_number_2}

3b. Validate findKeys Details
    [Tags]	Functional	asset   Search	POST    current
    Extract referenceNumberList values from findKeys dictionary  ${Asset_findkeys}
	compare lists  ${FK_referenceNumber_values}    ["${reference_number_1}", "${reference_number_2}"]