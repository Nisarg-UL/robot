*** Settings ***
Documentation	SingleModel TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***


*** Test Cases ***
1. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
	set test variable  ${model_name_1}  ${model_name_3}
    create product1 asset	CreationOfRegressionProduct1.json

2. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    Create Product1 Asset2	CreationOfRegressionProduct1_withSameOwnerRef.json

3. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productnoevalreqd.json	${asset_Id_Product1}

4. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

5. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${assessmentId1}  Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId1}	${assessmentId}

6. Complete Evaluation
	[Tags]	Functional	POST	current
	set global variable	${assessmentId}	${assessmentId1}
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}

7. Search Asset with orderBy value as Empty when referenceNumber is same
	[Tags]	Functional	asset   Search	POST    current
	set global variable  ${orderBy_value}  ${EMPTY}
	Search Asset     Asset_Search_with_orderBy.json
	Extract asset search response   ${Asset_summary_json}
	should not be equal  ${Asset_total_count}   ${value_as_0}
#	should be equal  ${Asset_offset}    ${value_as_0}
#	should be equal  ${Asset_rows}   ${value_as_400}
	should not be empty  ${Asset_list}
	should be empty  ${Asset_refiners}
	should not be empty  ${Asset_findkeys}
#	should be empty  ${Asset_user}

7a. Validate Asset Details
    [Tags]	Functional	asset   Search	POST    current
	Extract values from asset list  ${Asset_list}
#	compare lists  [${UL_Asset_Id}, ${Asset_Id}, ${Asset_hierarchyId}, ${Asset_collectionId}]    [["${asset_Id_Product1}"], ["${asset_Id_Product1}"], ["${regression_product_1_hierarchy_id}"], ["${Asset1_Collection_Id}"]]
	compare lists  ${Asset_Id}  ["${asset_Id_Product1}", "${asset2_Id_Product1}"]
	compare lists  ${UL_Asset_Id}  ["${asset_Id_Product1}", "${asset2_Id_Product1}"]
	compare lists  ${Asset_hierarchyId}  ["${regression_product_1_hierarchy_id}", "${regression_product_1_hierarchy_id}"]
	compare lists  ${Asset_collectionId}    ["${Asset1_Collection_Id}", "${Asset2_Collection_Id}"]
	Extract values from taxonomy list  ${Asset_taxonomy}
#	Compare lists   [${Asset_product_type}, ${Asset_model_name}, ${Asset_reference_number}, ${Asset_owner_reference}, ${Asset_family_series}, ${Asset_creation_date}]    [["${product_type_1}"], ["${model_name_1}_${current_time}"], ["${reference_number_1}"], ["${Asset_Owner_Ref}"], ["${family_series_1}-${current_time}"], ["${today_date}"]]
	compare lists  ${Asset_product_type}    ["${product_type_1}", "${product_type_1}"]
	compare lists  ${Asset_reference_number}    ["${reference_number_1}", "${reference_number_1}"]
	compare lists  ${Asset_owner_reference}  ["${Asset1_Owner_Ref}", "${Asset2_Owner_Ref}"]
	compare lists  ${Asset_family_series}    ["${family_series_1}-${current_time}", "${family_series_1}-${current_time}"]
	compare lists  ${Asset_creation_date}    ["${today_date}", "${today_date}"]
	compare lists  ${Asset_model_name}   ["${model_name_2}_${current_time}", "${model_name_3}_${current_time}"]

7b. Validate findKeys Details
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