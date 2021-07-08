*** Settings ***
Documentation	Certification Regression TestSuite
Resource	../../../resource/ApiFunctions.robot
Suite Setup  Link RegressionScheme-Scope-Product1
Suite Teardown  Unlink Scheme Scope    Unlink_ScopeScheme.json

*** Keywords ***


*** Test Cases ***
1. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST   notcurrent
    create product1 asset	CreationOfRegressionProduct1.json

2. Check Asset State
	[Tags]	Functional	notcurrent
	${state}=	Get Asset State	${asset_Id_Product1}
	should be equal  ${state}    ${asset_state_scratchpad}

3. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	notcurrent
	standard assignment	productnoevalreqd.json	${asset_Id_Product1}

4. Check Asset State After Associating Standard to Product
	[Tags]	Functional	notcurrent
	${state}=	Get Asset State	${asset_Id_Product1}
	should be equal  ${state}    ${asset_state_associated}

5. Get AssessmentId
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
	should be equal  ${state}    ${asset_state_immutable}

8. Certificate creation
	[Tags]	Functional	certificate create	POST    notcurrent
    create certificate   Certificate/CreationOfRegressionSchemeCertificate.json

#9. Link Product and Evaluation to Certificate
#    [Tags]	Functional	certificate	create	POST    current
#    ${Trans_Id1}     Get Certificate TransactionId using Certificate Details  ${Certificate_Name}    ${Cert_Owner_Ref}  ${scheme}
#    set global variable	${Cert_Transaction_Id}	${Trans_Id1}
#    log to console	"Transaction ID": ${Cert_Transaction_Id}
#    ${response}  Get ULAssetID   ${asset_Id_Product1}
#    set global variable	${ul_asset_Id}	${response}
#    Add Assets to Certificate  Certificate/Link_Product1_Eval1_RegressionCertificate.json    ${Certificate_Id}
#
#10. Associate parties to certificate
#    [Tags]	Functional	certificate	create	POST    current
#    ${has_assets}    Get HasAssets using Certificate Details   ${certificate_type_1_url}   ${certificate_name_1}    ${Cert_Owner_Ref}   ${Certificate_Id}
#    Should not be Empty     ${has_assets}
#    ${has_evaluations}    Get HasEvaluations using Certificate Details   ${certificate_type_1_url}   ${certificate_name_1}    ${Cert_Owner_Ref}   ${Certificate_Id}
#    Should not be Empty     ${has_evaluations}
#    Add Parties to Certificate  Certificate/Associate_Parties_RegressionCertificate.json  ${Certificate_Id}
#
#11. Certify certificate
#    [Tags]	Functional	certificate	create	POST    current
#    Add Decisions to Certificate  Certificate/Certify_RegressionCertificate_with_Dates.json     ${Certificate_Id}
#
#12. Validate Certificate Status
#    [Tags]	Functional	certificate	create	current
#    ${cert_status}  Get certificate status
#    log to console  ${cert_status}
#    should be equal  ${cert_status}  "${status_Active}"

13. Search Certificate with valid values
	[Tags]	Functional	asset   Search	POST    notcurrent
	set global variable  ${status_value}     ${status_Active}
#	set global variable  ${completed_value}  ${value_as_Y}
#	set global variable  ${accepted_value}   ${value_as_Y}
	set global variable  ${completed_value}  ${EMPTY}
	set global variable  ${accepted_value}   ${EMPTY}
	Paginated Search for Certificate    Certificate_Search_with_all_valid_values.json
	Extract certificate search response   ${certificate_search}
	should be equal  ${certificate_total_count}   ${value_as_1}
	should be equal  ${certificate_offset}    ${EMPTY}
	should be equal  ${certificate_rows}   ${EMPTY}
	length should be  ${certificate_list}  ${value_as_1}
	should be empty  ${certificate_refiners}
	length should be  ${certificate_findkeys}  ${value_as_1}
	should be equal  ${Asset_user}  ${user_1}

#8a. Validate Asset Details
#    [Tags]	Functional	asset   Search	POST    current
#	Extract values from asset list  ${Asset_list}
#	Compare lists  [${Asset_status}, ${asset_version}, ${isPLAsset}, ${Asset_model_nomenclature}, ${Asset_created_by}, ${Asset_updated_by}]   [["${status_Active}"], ["${value_as_1.0}"], ["${value_as_N}"], ["${modelNomenclature_1}"], ["${user_2}"], ["${user_1}"]]
#	compare lists  [${UL_Asset_Id}, ${Asset_Id}, ${Asset_hierarchyId}, ${Asset_collectionId}]    [["${asset_Id_Product1}"], ["${asset_Id_Product1}"], ["${regression_product_1_hierarchy_id}"], ["${Asset1_Collection_Id}"]]
#	Extract values from taxonomy list  ${Asset_taxonomy}
#	Compare lists   [${Asset_product_type}, ${Asset_model_name}, ${Asset_reference_number}, ${Asset_owner_reference}, ${Asset_family_series}, ${Asset_creation_date}]    [["${product_type_1}"], ["${model_name_1}_${current_time}"], ["${reference_number_1}"], ["${Asset1_Asset_Owner_Ref}"], ["${family_series_1}-${current_time}"], ["${today_date}"]]
#
#8b. Validate Refiner Details
#    [Tags]	Functional	asset   Search	POST    current
#	Extract productType values from refiners dictionary  ${Asset_refiners}
#	compare lists  ${RF_productType_list}   ['${product_type_1}', ${value_as_1}]
#	Extract referenceNumber values from refiners dictionary  ${Asset_refiners}
#	compare lists  ${RF_referenceNumber_list}    ['${reference_number_1}', ${value_as_1}]
#	Extract ownerReference values from refiners dictionary   ${Asset_refiners}
#	Compare lists  ${RF_ownerReference_list}  ['${Asset_Owner_Ref}', ${value_as_1}]
#	Extract family_Series values from refiners dictionary   ${Asset_refiners}
#	compare lists  ${RF_family_series_list}    ['${family_series_1}-${current_time}', ${value_as_1}]
#
#8c. Validate findKeys Details
#    [Tags]	Functional	asset   Search	POST    current
#    Extract searchParameters from findKeys dictionary    ${Asset_findkeys}
#    length should be  ${FK_searchParameters_dict}     ${value_as_9}
#    Extract searchText from findKeys dictionary  ${Asset_findkeys}
#    should be equal  ${FK_searchText}   ${value_as_Test}
#    Extract modelNomenclature from findKeys dictionary  ${Asset_findkeys}
#    should be equal  ${FK_modelNomenclature}   ${modelNomenclature_1}
#    Extract isPLAsset from findKeys dictionary  ${Asset_findkeys}
#    should be equal  ${FK_isPLAsset}   ${value_as_N}
#    Extract fromDate and toDate from findKeys dictionary    ${Asset_findkeys}
#    should be equal  ${FK_from&toDate}  [${today_date}, ${today_date}]
#    Extract fromCreatedDate and toCreatedDate from findKeys dictionary   ${Asset_findkeys}
#    should be equal  ${FK_from&toCreatedDate}  [${today_date}, ${today_date}]
#    Extract fromModifiedDate and toModifiedDate from findKeys dictionary    ${Asset_findkeys}
#    should be equal  ${FK_from&toModifiedDate}  [${today_date}, ${today_date}]
#
#8d. Validate findKeys Lists Details
#    [Tags]	Functional	asset   Search	POST    current
#    Extract ownerReferenceList values from findKeys dictionary  ${Asset_findkeys}
#    compare lists  ${FK_ownerReference_values}  ["${Asset_Owner_Ref}"]
#    Extract productTypeList values from findKeys dictionary  ${Asset_findkeys}
#    compare lists  ${FK_productType_values}    ["${product_type_1}"]
#    Extract referenceNumberList values from findKeys dictionary  ${Asset_findkeys}
#	compare lists  ${FK_referenceNumber_values}    ["${reference_number_1}"]
#	Extract family_SeriesList values from findKeys dictionary    ${Asset_findkeys}
#	compare lists  ${FK_family_Series_values}   ["${family_series_1}-${current_time}"]
#	Extract statusList values from findKeys dictionary    ${Asset_findkeys}
#	compare lists  ${FK_status_values}   ["${status_Active}"]
#
#8e. Validate searchParameters Details
#    [Tags]	Functional	asset   Search	POST    current
#    Extract productType values from searchParameters dictionary   ${FK_searchParameters_dict}
#    compare lists  ${SP_productType_values}  ["${product_type_1}", "${exact_search_value}"]
#    Extract modelName values from searchParameters dictionary   ${FK_searchParameters_dict}
#    compare lists   ${SP_modelName_values}    ["${model_name_1}_${current_time}", "${exact_search_value}"]
#    Extract referenceNumber values from searchParameters dictionary   ${FK_searchParameters_dict}
#    compare lists  ${SP_referenceNumber_values}  ["${reference_number_1}", "${exact_search_value}"]
#    Extract ownerReference values from searchParameters dictionary   ${FK_searchParameters_dict}
#    compare lists  ${SP_ownerReference_values}   ["${Asset_Owner_Ref}", "${exact_search_value}"]
#    Extract family_Series values from searchParameters dictionary   ${FK_searchParameters_dict}
#    compare lists  ${SP_family_Series_values}    ["${family_series_1}-${current_time}", "${exact_search_value}"]
#    Extract collectionName values from searchParameters dictionary   ${FK_searchParameters_dict}
#    compare lists  ${SP_collectionName_values}   ["${collection_1}", "${exact_search_value}"]
#    Extract projectNumber values from searchParameters dictionary   ${FK_searchParameters_dict}
#    compare lists  ${SP_projectNumber_values}    ["${Asset1_Collection_Project_no}", "${exact_search_value}"]
#    Extract quoteNumber values from searchParameters dictionary   ${FK_searchParameters_dict}
#    compare lists  ${SP_quoteNumber_values}  ["${Asset1_Collection_Quote_no}", "${exact_search_value}"]
#    Extract orderNumber values from searchParameters dictionary   ${FK_searchParameters_dict}
#    compare lists  ${SP_orderNumber_values}  ["${Asset1_Collection_Order_no}", "${exact_search_value}"]