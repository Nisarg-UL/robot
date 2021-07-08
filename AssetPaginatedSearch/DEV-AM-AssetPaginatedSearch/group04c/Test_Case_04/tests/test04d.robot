*** Settings ***
Documentation	SingleModel TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***


*** Test Cases ***
1. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    create product1 asset	CreationOfRegressionProduct1.json

2. Search Asset with valid family_Series values
	[Tags]	Functional	asset   Search	POST    current
	Search Asset    Asset_Search_with_familySeries_likeSearch.json
	Extract asset search response   ${Asset_summary_json}
	should not be equal  ${Asset_total_count}   ${value_as_0}
#	should be equal  ${Asset_offset}    ${value_as_0}
#	should be equal  ${Asset_rows}   ${value_as_400}
    length should be  ${Asset_list}  ${value_as_400}
	should be empty  ${Asset_refiners}
	should not be empty  ${Asset_findkeys}
#	should be equal  ${Asset_user}  ${user_1}

2a. Validate Asset Details
    [Tags]	Functional	asset   Search	POST    current
	Extract values from asset list  ${Asset_list}
	list should contain value   ${UL_assetId}   ${asset_Id_Product1}
	list should contain value   ${Asset_Id}   ${asset_Id_Product1}
	Extract values from taxonomy list  ${Asset_taxonomy}
	list should contain value   ${Asset_owner_reference}   ${Asset1_Owner_Ref}

2b. Validate findKeys Details
    [Tags]	Functional	asset   Search	POST    current
    Extract searchParameters from findKeys dictionary    ${Asset_findkeys}
    should not be empty  ${FK_searchParameters_dict}
    Extract family_Series values from searchParameters dictionary   ${FK_searchParameters_dict}
    compare lists  ${SP_family_Series_values}    ["${family_series_1}", "${like_search_value}"]