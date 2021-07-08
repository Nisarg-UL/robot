*** Settings ***
Documentation	SingleModel TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***


*** Test Cases ***
1. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    notcurrent
    create product1 asset	CreationOfRegressionProduct1.json

2. Search Asset with valid CCN
	[Tags]	Functional	asset   Search	POST    notcurrent
	set global variable  ${searchParameter_key}  ${ccn_key}
	set global variable  ${operator_value}  ${exact_search_value}
	set global variable  ${searchParameter_value}   ${ccn_1}
	Search Asset    Asset_Search_with_collectionParameter.json
	Extract asset search response   ${Asset_summary_json}
	should not be equal  ${Asset_total_count}   ${value_as_0}
#	should be equal  ${Asset_offset}    ${value_as_0}
#	should be equal  ${Asset_rows}   ${value_as_400}
    should not be empty  ${Asset_list}
	should be empty  ${Asset_refiners}
	should not be empty  ${Asset_findkeys}
#	should be equal  ${Asset_user}  ${user_1}

2a. Validate Asset Details
    [Tags]	Functional	asset   Search	POST    notcurrent
	Extract values from asset list  ${Asset_list}
	list should contain value   ${UL_assetId}   ${asset_Id_Product1}
	list should contain value   ${Asset_Id}   ${asset_Id_Product1}
	Extract values from taxonomy list  ${Asset_taxonomy}
	list should contain value   ${Asset_owner_reference}   ${Asset1_Owner_Ref}

2b. Validate findKeys Details
    [Tags]	Functional	asset   Search	POST    notcurrent
    Extract searchParameters from findKeys dictionary    ${Asset_findkeys}
    should not be empty  ${FK_searchParameters_dict}
    Extract ccn values from searchParameters dictionary   ${FK_searchParameters_dict}
    compare lists   ${SP_ccn_values}    ["${ccn_1}", "${exact_search_value}"]