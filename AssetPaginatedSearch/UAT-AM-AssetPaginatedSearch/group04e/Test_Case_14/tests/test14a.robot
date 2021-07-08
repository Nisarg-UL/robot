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
    Create Product2 Asset	CreationOfRegressionProduct2_withProduct1OwnerRef.json

3. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productnoevalreqd.json	${asset_Id_Product1}

4. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${assessmentId1}  Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId1}	${assessmentId}

5. Complete Evaluation
	[Tags]	Functional	POST	current
	set global variable	${assessmentId}	${assessmentId1}
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}

6. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'immutable'	Fail	test1a Teardown
	${state}=	Get Asset State  ${asset_Id_Product2}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown

7. Search Asset with ownerReference & productType Refiner
	[Tags]	Functional	asset   Search	POST    current
	set global variable  ${searchParameter_key}  ${ownerReference_key}
	set global variable  ${operator_value}  ${exact_search_value}
	set global variable  ${searchParameter_value}   ${Asset1_Owner_Ref}
	set global variable  ${field_value}  ${productType_key}
	Search Asset    Asset_Search_with_searchParameter_oneRefiner.json
	Extract asset search response   ${Asset_summary_json}
#	should be equal  ${Asset_user}  ${user_1}
	should be equal  ${Asset_total_count}   ${value_as_2}
#	should be equal  ${Asset_offset}    ${value_as_0}
#	should be equal  ${Asset_rows}   ${value_as_400}
    length should be  ${Asset_refiners}  ${value_as_1}
	length should be  ${Asset_list}  ${value_as_2}
#	length should be  ${Asset_findkeys}  ${value_as_1}

7a. Validate Asset Details
    [Tags]	Functional	asset   Search	POST    current
	Extract values from asset list  ${Asset_list}
	compare lists   ${Asset_status}  ["${status_Active}", "${status_Draft}"]
	compare lists  ${Asset_updated_by}   ["${user_1}", "${user_2}"]
	compare lists  ${Asset_Id}  ["${asset_Id_Product1}", "${asset_Id_Product2}"]
	compare lists  ${UL_Asset_Id}  ["${asset_Id_Product1}", "${asset_Id_Product2}"]
	compare lists  ${Asset_hierarchyId}  ["${regression_product_1_hierarchy_id}", "${regression_product_2_hierarchy_id}"]
	compare lists  ${Asset_collectionId}    ["${Asset1_Collection_Id}", "${Asset2_Collection_Id}"]
	Extract values from taxonomy list  ${Asset_taxonomy}
	compare lists  ${Asset_product_type}    ["${product_type_1}", "${product_type_2}"]
	compare lists  ${Asset_model_name}   ["${model_name_1}_${current_time}", "${model_name_2}_${current_time}"]
	compare lists  ${Asset_reference_number}    ["${reference_number_1}", "${reference_number_1}"]
	compare lists  ${Asset_owner_reference}  ["${Asset1_Owner_Ref}", "${Asset1_Owner_Ref}"]
	compare lists  ${Asset_family_series}    ["${family_series_1}-${current_time}", "${family_series_1}-${current_time}"]
	compare lists  ${Asset_creation_date}    ["${today_date}", "${today_date}"]


7b. Validate Refiner Details
    [Tags]	Functional	asset   Search	POST    current
	Extract productType values from refiners dictionary  ${Asset_refiners}
	compare lists  ${RF_productType_list}   ['${product_type_1}', ${value_as_1}, '${product_type_2}', ${value_as_1}]

7c. Validate findKeys Details
    [Tags]	Functional	asset   Search	POST    current
    Extract searchParameters from findKeys dictionary    ${Asset_findkeys}
    length should be  ${FK_searchParameters_dict}     ${value_as_1}
    Extract ownerReference values from searchParameters dictionary   ${FK_searchParameters_dict}
    compare lists  ${SP_ownerReference_values}   ["${Asset_Owner_Ref}", "${exact_search_value}"]