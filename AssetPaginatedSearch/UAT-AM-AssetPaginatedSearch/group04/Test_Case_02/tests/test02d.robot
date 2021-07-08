*** Settings ***
Documentation	SingleModel TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***


*** Test Cases ***
1. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    create product1 asset	CreationOfRegressionProduct1.json

2. Search Asset with Search Text
	[Tags]	Functional	asset   Search	POST    current
	set global variable  ${searchText_value}    ${value_as_Test}
	Search Asset     Asset_Search_with_searchText.json
	Extract asset search response   ${Asset_summary_json}
#	should be equal  ${Asset_user}  ${user_1}
	should not be equal  ${Asset_total_count}   ${value_as_0}
#	should be equal  ${Asset_offset}    ${value_as_0}
#	should be equal  ${Asset_rows}   ${value_as_400}
    should be empty  ${Asset_refiners}
	length should be  ${Asset_list}  ${value_as_400}
#	length should be  ${Asset_findkeys}  ${value_as_1}

2a. Validate Asset Details
    [Tags]	Functional	asset   Search	POST    current
	Extract values from asset list  ${Asset_list}
	list should contain value   ${UL_assetId}   ${asset_Id_Product1}
	list should contain value   ${Asset_Id}   ${asset_Id_Product1}
	Extract values from taxonomy list  ${Asset_taxonomy}
	list should contain value  ${Asset_owner_reference}   ${Asset1_Owner_Ref}

2b. Validate findKeys Details
    [Tags]	Functional	asset   Search	POST    current
    Extract searchText from findKeys dictionary  ${Asset_findkeys}
    should be equal  ${FK_searchText}   ${value_as_Test}