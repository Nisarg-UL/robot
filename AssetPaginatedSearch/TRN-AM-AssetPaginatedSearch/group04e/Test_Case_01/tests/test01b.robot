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
	${state}=	Get Asset State  ${asset2_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown

7. Search Asset with Search Text & all Refiner
	[Tags]	Functional	asset   Search	POST    current
	set global variable  ${searchText_value}    ${Asset_Owner_Ref}
	Search Asset     Asset_Search_with_searchText_allRefiners.json
	Extract asset search response   ${Asset_summary_json}
#	should be equal  ${Asset_user}  ${user_1}
	should be equal  ${Asset_total_count}   ${value_as_2}
#	should be equal  ${Asset_offset}    ${value_as_0}
#	should be equal  ${Asset_rows}   ${value_as_400}
    length should be  ${Asset_refiners}  ${value_as_4}
	length should be  ${Asset_list}  ${value_as_2}
#	length should be  ${Asset_findkeys}  ${value_as_1}

7a. Validate Asset Details
    [Tags]	Functional	asset   Search	POST    current
	Extract values from asset list  ${Asset_list}
	compare lists   ${Asset_status}  ["${status_Active}", "${status_Draft}"]
	Compare lists  [${asset_version}, ${isPLAsset}, ${Asset_model_nomenclature}, ${Asset_created_by}]   [["${value_as_1.0}", "${value_as_1.0}"], ["${value_as_N}", "${value_as_N}"], ["${modelNomenclature_1}", "${modelNomenclature_1}"], ["${user_2}", "${user_2}"]]
	compare lists  ${Asset_updated_by}   ["${user_1}", "${user_2}"]
	compare lists  ${Asset_Id}  ["${asset_Id_Product1}", "${asset2_Id_Product1}"]
	compare lists  ${UL_Asset_Id}  ["${asset_Id_Product1}", "${asset2_Id_Product1}"]
	compare lists  ${Asset_hierarchyId}  ["${regression_product_1_hierarchy_id}", "${regression_product_1_hierarchy_id}"]
	compare lists  ${Asset_collectionId}    ["${Asset1_Collection_Id}", "${Asset2_Collection_Id}"]
	Extract values from taxonomy list  ${Asset_taxonomy}
	compare lists  ${Asset_product_type}    ["${product_type_1}", "${product_type_1}"]
	compare lists  ${Asset_model_name}   ["${model_name_1}_${current_time}", "${model_name_2}_${current_time}"]
	compare lists  ${Asset_reference_number}    ["${reference_number_1}", "${reference_number_1}"]
	compare lists  ${Asset_owner_reference}  ["${Asset1_Owner_Ref}", "${Asset2_Owner_Ref}"]
	compare lists  ${Asset_family_series}    ["${family_series_1}-${current_time}", "${family_series_1}-${current_time}"]
	compare lists  ${Asset_creation_date}    ["${today_date}", "${today_date}"]

7b. Validate Refiner Details
    [Tags]	Functional	asset   Search	POST    current
	Extract productType values from refiners dictionary  ${Asset_refiners}
	compare lists  ${RF_productType_list}   ['${product_type_1}', ${value_as_2}]
	Extract referenceNumber values from refiners dictionary  ${Asset_refiners}
	compare lists  ${RF_referenceNumber_list}    ['${reference_number_1}', ${value_as_2}]
	Extract ownerReference values from refiners dictionary   ${Asset_refiners}
	Compare lists  ${RF_ownerReference_list}  ['${Asset_Owner_Ref}', ${value_as_2}]
	Extract family_Series values from refiners dictionary   ${Asset_refiners}
	compare lists  ${RF_family_series_list}    ['${family_series_1}-${current_time}', ${value_as_2}]

7c. Validate findKeys Details
    [Tags]	Functional	asset   Search	POST    current
    Extract searchText from findKeys dictionary  ${Asset_findkeys}
    should be equal  ${FK_searchText}   ${Asset_Owner_Ref}
