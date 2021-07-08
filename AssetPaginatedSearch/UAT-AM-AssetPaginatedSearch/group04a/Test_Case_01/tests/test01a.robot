*** Settings ***
Documentation	SingleModel TestSuite
Resource	../../../resource/ApiFunctions.robot
Suite Setup  Link RegressionScheme-Scope-Product1
Suite Teardown  Unlink Scheme Scope    Unlink_ScopeScheme.json

*** Keywords ***


*** Test Cases ***
1. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    notcurrent
    create product1 asset	CreationOfRegressionProduct1.json

2. Check Asset State
	[Tags]	Functional	notcurrent
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

3. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	notcurrent
	standard assignment	productnoevalreqd.json	${asset_Id_Product1}

4. Check Asset State After Associating Standard to Product
	[Tags]	Functional	notcurrent
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

5. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	notcurrent
	${assessmentId}  Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId}	${assessmentId}

6. Complete Evaluation
	[Tags]	Functional	POST	notcurrent
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}

7. Check Asset State After Evaluation
	[Tags]	Functional	notcurrent
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'immutable'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

8. Certificate Creation
	[Tags]	Functional	certificate	create	POST    notcurrent
    create certificate   Certificate/CreationOfRegressionSchemeCertificate_withReferenceAttributes.json

9. Link Product to Certificate
    [Tags]	Functional	certificate	create	POST    notcurrent
    ${Trans_Id1}     Get Certificate TransactionId using Certificate Details  ${Certificate_Name}    ${Cert_Owner_Ref}  ${scheme}
    set global variable	${Cert_Transaction_Id}	${Trans_Id1}
    log to console	"Transaction ID": ${Cert_Transaction_Id}
    ${response}  Get ULAssetID   ${asset_Id_Product1}
    set global variable	${ul_asset_Id}	${response}
    Add Assets to Certificate  Certificate/Link_Product1_Eval1_RegressionCertificate.json    ${Certificate_Id}

10. Associate parties to certificate
    [Tags]	Functional	certificate	create	POST    notcurrent
    ${has_assets}    Get HasAssets using Certificate Details   ${certificate_type_1_url}   ${Certificate_Name}    ${Cert_Owner_Ref}   ${Certificate_Id}
    Should not be Empty     ${has_assets}
    ${has_evaluations}    Get HasEvaluations using Certificate Details   ${certificate_type_1_url}   ${Certificate_Name}    ${Cert_Owner_Ref}   ${Certificate_Id}
    Should not be Empty     ${has_evaluations}
    Add Parties to Certificate  Certificate/Associate_Parties_RegressionCertificate.json  ${Certificate_Id}

11. Certify certificate
    [Tags]	Functional	certificate	create	POST    notcurrent
    Add Decisions to Certificate  Certificate/Certify_RegressionCertificate.json     ${Certificate_Id}

12. Create Private Label
    [Tags]	Functional	certificate	PL  create	POST   notcurrent
    Create private label    Private_Label/CreationOfPrivateLabel_RegressionSchemeCertificate_withReferenceAttributes.json
    should not be empty  ${PrivateLabel_Id}
    log to console  ${PrivateLabel_Id}

13. Add Asset To Private Label
    [Tags]	Functional	certificate	PL  create	POST    notcurrent
    ${response}  Add Asset To PL  Private_Label/Add_Asset_To_Private_Label.json
    set global variable  ${PrivateLabel_Asset_Id}   ${response}

14. Add Party To Private Label
    [Tags]	Functional	certificate	PL  POST    notcurrent
    Add Party To PL  Private_Label/Add_Parties_To_Private_Label.json

15. Validate Certificate Reference Attributes
    [Tags]	Functional	certificate    notcurrent
    Validate Certificate Reference Attributes   ${PrivateLabel_Id}
    should be empty  ${ref_attr_errors}

16. Certify Private Label
    [Tags]	Functional	certificate	PL  POST    notcurrent
    Certify Private Label    Private_Label/Certify_PrivateLabelCertificate.json

17. Search Asset with valid values
	[Tags]	Functional	asset   Search	POST    notcurrent
	set global variable  ${isPLAsset_value}  ${value_as_Y}
	set global variable  ${status_value}     ${status_Active}
#	set global variable  ${completed_value}  ${value_as_Y}
#	set global variable  ${accepted_value}   ${value_as_Y}
	set global variable  ${completed_value}  ${EMPTY}
	set global variable  ${accepted_value}   ${EMPTY}
	Search Asset    PLAsset_Search_with_all_valid_values.json
	Extract asset search response   ${Asset_summary_json}
	should be equal  ${Asset_total_count}   ${value_as_1}
	should be equal  ${Asset_offset}    ${value_as_0}
	should be equal  ${Asset_rows}   ${value_as_10}
	length should be  ${Asset_list}  ${value_as_1}
	length should be  ${Asset_refiners}  ${value_as_4}
	length should be  ${Asset_findkeys}  ${value_as_16}
#	should be equal  ${Asset_user}  ${user_1}

17a. Validate Asset Details
    [Tags]	Functional	asset   Search	POST    notcurrent
	Extract values from asset list  ${Asset_list}
	Compare lists  [${Asset_status}, ${asset_version}, ${isPLAsset}, ${Asset_model_nomenclature}, ${Asset_created_by}, ${Asset_updated_by}]   [["${status_Active}"], ["${EMPTY}"], ["${value_as_N}"], ["${PL_modelNomenclature_1}"], ["50696"], ["50696"]]
	compare lists  [${UL_Asset_Id}, ${Asset_Id}, ${Asset_hierarchyId}, ${Asset_collectionId}]    [["${asset_Id_Product1}"], ["${asset_Id_Product1}"], ["${regression_product_1_hierarchy_id}"], ["${Asset1_Collection_Id}"]]
	Extract values from taxonomy list  ${Asset_taxonomy}
	Compare lists   [${Asset_product_type}, ${Asset_model_name}, ${Asset_reference_number}, ${Asset_owner_reference}, ${Asset_family_series}, ${Asset_creation_date}]    [["${product_type_1}"], ["${PL_model_name_1}"], ["${PL_reference_number_1}"], ["${Asset1_Owner_Ref}"], ["${family_series_1}-${current_time}"], ["${today_date}"]]

17b. Validate Refiner Details
    [Tags]	Functional	asset   Search	POST    notcurrent
	Extract productType values from refiners dictionary  ${Asset_refiners}
	compare lists  ${RF_productType_list}   ['${product_type_1}', ${value_as_1}]
	Extract referenceNumber values from refiners dictionary  ${Asset_refiners}
	compare lists  ${RF_referenceNumber_list}    ['${PL_reference_number_1}', ${value_as_1}]
	Extract ownerReference values from refiners dictionary   ${Asset_refiners}
	Compare lists  ${RF_ownerReference_list}  ['${Asset_Owner_Ref}', ${value_as_1}]
	Extract family_Series values from refiners dictionary   ${Asset_refiners}
	compare lists  ${RF_family_series_list}    ['${family_series_1}', ${value_as_1}]

17c. Validate findKeys Details
    [Tags]	Functional	asset   Search	POST    notcurrent
    Extract searchParameters from findKeys dictionary    ${Asset_findkeys}
    length should be  ${FK_searchParameters_dict}     ${value_as_5}
    Extract searchText from findKeys dictionary  ${Asset_findkeys}
    should be equal  ${FK_searchText}   ${value_as_Test}
    Extract modelNomenclature from findKeys dictionary  ${Asset_findkeys}
    should be equal  ${FK_modelNomenclature}   ${PL_modelNomenclature_1}
    Extract isPLAsset from findKeys dictionary  ${Asset_findkeys}
    should be equal  ${FK_isPLAsset}   ${value_as_Y}
    Extract fromDate and toDate from findKeys dictionary    ${Asset_findkeys}
    should be equal  ${FK_from&toDate}  [${today_date}, ${today_date}]
    Extract fromCreatedDate and toCreatedDate from findKeys dictionary   ${Asset_findkeys}
    should be equal  ${FK_from&toCreatedDate}  [${today_date}, ${today_date}]
    Extract fromModifiedDate and toModifiedDate from findKeys dictionary    ${Asset_findkeys}
    should be equal  ${FK_from&toModifiedDate}  [${today_date}, ${today_date}]

17d. Validate findKeys Lists Details
    [Tags]	Functional	asset   Search	POST    notcurrent
    Extract ownerReferenceList values from findKeys dictionary  ${Asset_findkeys}
    compare lists  ${FK_ownerReference_values}  ["${Asset_Owner_Ref}"]
    Extract productTypeList values from findKeys dictionary  ${Asset_findkeys}
    compare lists  ${FK_productType_values}    ["${product_type_1}"]
    Extract referenceNumberList values from findKeys dictionary  ${Asset_findkeys}
	compare lists  ${FK_referenceNumber_values}    ["${PL_reference_number_1}"]
	Extract family_SeriesList values from findKeys dictionary    ${Asset_findkeys}
	compare lists  ${FK_family_Series_values}   ["${family_series_1}"]
	Extract statusList values from findKeys dictionary    ${Asset_findkeys}
	compare lists  ${FK_status_values}   ["${status_Active}"]

17e. Validate searchParameters Details
    [Tags]	Functional	asset   Search	POST    notcurrent
    Extract productType values from searchParameters dictionary   ${FK_searchParameters_dict}
    compare lists  ${SP_productType_values}  ["${product_type_1}", "${exact_search_value}"]
    Extract modelName values from searchParameters dictionary   ${FK_searchParameters_dict}
    compare lists   ${SP_modelName_values}    ["${PL_model_name_1}", "${exact_search_value}"]
    Extract referenceNumber values from searchParameters dictionary   ${FK_searchParameters_dict}
    compare lists  ${SP_referenceNumber_values}  ["${PL_reference_number_1}", "${exact_search_value}"]
    Extract ownerReference values from searchParameters dictionary   ${FK_searchParameters_dict}
    compare lists  ${SP_ownerReference_values}   ["${Asset_Owner_Ref}", "${exact_search_value}"]
    Extract family_Series values from searchParameters dictionary   ${FK_searchParameters_dict}
    compare lists  ${SP_family_Series_values}    ["${family_series_1}", "${exact_search_value}"]
#    Extract collectionName values from searchParameters dictionary   ${FK_searchParameters_dict}
#    compare lists  ${SP_collectionName_values}   ["${collection_1}", "${exact_search_value}"]
#    Extract projectNumber values from searchParameters dictionary   ${FK_searchParameters_dict}
#    compare lists  ${SP_projectNumber_values}    ["${Asset1_Collection_Project_no}", "${exact_search_value}"]
#    Extract quoteNumber values from searchParameters dictionary   ${FK_searchParameters_dict}
#    compare lists  ${SP_quoteNumber_values}  ["${Asset1_Collection_Quote_no}", "${exact_search_value}"]
#    Extract orderNumber values from searchParameters dictionary   ${FK_searchParameters_dict}
#    compare lists  ${SP_orderNumber_values}  ["${Asset1_Collection_Order_no}", "${exact_search_value}"]