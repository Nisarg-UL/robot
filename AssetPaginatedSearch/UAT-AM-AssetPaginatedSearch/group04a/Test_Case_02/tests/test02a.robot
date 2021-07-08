*** Settings ***
Documentation	SingleModel TestSuit
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
    ${has_assets}    Get HasAssets using Certificate Details   Regression%20Scheme   Regression-US001-1    ${Cert_Owner_Ref}   ${Certificate_Id}
    Should not be Empty     ${has_assets}
    ${has_evaluations}    Get HasEvaluations using Certificate Details   Regression%20Scheme   Regression-US001-1    ${Cert_Owner_Ref}   ${Certificate_Id}
    Should not be Empty     ${has_evaluations}
    Add Parties to Certificate  Certificate/Associate_Parties_With2Product_Certificate.json  ${Certificate_Id}

11. Certify certificate
    [Tags]	Functional	certificate	create	POST    notcurrent
    Add Decisions to Certificate  Certificate/Certify_RegressionCertificate.json     ${Certificate_Id}

12. Create Private Label
    [Tags]	Functional	certificate	PL  create	POST    notcurrent
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

17. Search Asset with isPLAsset value as Y
	[Tags]	Functional	asset   Search	POST    notcurrent
	set global variable  ${isPLAsset_value}  ${value_as_Y}
	Search Asset     Asset_Search_with_isPLAsset.json
	Extract asset search response   ${Asset_summary_json}
	should not be equal  ${Asset_total_count}   ${value_as_0}
#	should be equal  ${Asset_offset}    ${value_as_0}
#	should be equal  ${Asset_rows}   ${value_as_400}
	length should be  ${Asset_list}  ${value_as_1}
	should be empty  ${Asset_refiners}
	should not be empty  ${Asset_findkeys}
#	should be empty  ${Asset_user}

17a. Validate Asset Details
    [Tags]	Functional	asset   Search	POST    notcurrent
	Extract values from asset list  ${Asset_list}
	Compare lists  [${Asset_status}, ${asset_version}, ${isPLAsset}, ${Asset_model_nomenclature}, ${Asset_created_by}, ${Asset_updated_by}]   [["${status_Active}"], ["${EMPTY}"], ["${value_as_Y}"], ["${PL_modelNomenclature_1}"], ["50696"], ["50696"]]
	compare lists  [${UL_Asset_Id}, ${Asset_Id}, ${Asset_hierarchyId}, ${Asset_collectionId}]    [["${asset_Id_Product1}"], ["${asset_Id_Product1}"], ["${regression_product_1_hierarchy_id}"], ["${Asset1_Collection_Id}"]]
	Extract values from taxonomy list  ${Asset_taxonomy}
	Compare lists   [${Asset_product_type}, ${Asset_model_name}, ${Asset_reference_number}, ${Asset_owner_reference}, ${Asset_family_series}, ${Asset_creation_date}]    [["${product_type_1}"], ["${PL_model_name_1}"], ["${PL_reference_number_1}"], ["${Asset_Owner_Ref}"], ["${family_series_1}-${current_time}"], ["${today_date}"]]

17b. Validate findKeys Details
    [Tags]	Functional	asset   Search	POST    notcurrent
    Extract searchText from findKeys dictionary  ${Asset_findkeys}
    should be equal  ${FK_searchText}   ${Asset_Owner_Ref}
    Extract isPLAsset from findKeys dictionary  ${Asset_findkeys}
    should be equal  ${FK_isPLAsset}   ${value_as_Y}
    Extract ownerReferenceList values from findKeys dictionary  ${Asset_findkeys}
    compare lists  ${FK_ownerReference_values}  [${EMPTY}]
#    Extract productTypeList values from findKeys dictionary  ${Asset_findkeys}
#    compare lists  ${FK_productType_values}    [${EMPTY}]
#    Extract referenceNumberList values from findKeys dictionary  ${Asset_findkeys}
#	compare lists  ${FK_referenceNumber_values}    [${EMPTY}]
#	Extract family_SeriesList values from findKeys dictionary    ${Asset_findkeys}
#	compare lists  ${FK_family_Series_values}   [${family_series_1}-${current_time}]

