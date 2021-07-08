*** Settings ***
Documentation	Certification Regression TestSuite
Resource	../../../resource/ApiFunctions.robot
Suite Setup  Link RegressionScheme-Scope-Product1
Suite Teardown  Unlink Scheme Scope    Unlink_ScopeScheme.json

*** Keywords ***


*** Test Cases ***
1. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    create product1 asset	CreationOfRegressionProduct1.json

2. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productnoevalreqd.json	${asset_Id_Product1}

3. Get AssessmentId
	[Tags]	Functional	GET	current
	${assessmentId}  Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId}	${assessmentId}

4. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}

5. Check Asset State After Evaluation
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	should be equal  ${state}    ${asset_state_immutable}

6. Certificate creation
	[Tags]	Functional	certificate create	POST    current
    create certificate   Certificate/CreationOfRegressionSchemeCertificate.json

7. Link Product and Evaluation to Certificate
    [Tags]	Functional	certificate	create	POST    current
    ${Trans_Id1}     Get Certificate TransactionId using Certificate Details  ${Certificate_Name}    ${Cert_Owner_Ref}  ${scheme}
    set global variable	${Cert_Transaction_Id}	${Trans_Id1}
    log to console	"Transaction ID": ${Cert_Transaction_Id}
    ${response}  Get ULAssetID   ${asset_Id_Product1}
    set global variable	${ul_asset_Id}	${response}
    Add Assets to Certificate  Certificate/Link_Product1_Eval1_RegressionCertificate.json    ${Certificate_Id}

8. Validate Certificate Status
    [Tags]	Functional	certificate	create	current
    ${cert_status}  Get certificate status
    should be equal  ${cert_status}  "${status_Under_Revision}"

9. Search Certificate with searchParameters as ownerReference
	[Tags]	Functional	asset   Search	POST    current
	set global variable  ${operator_value}   ${like_search_value}
	set global variable  ${search_parameter}  ${cert_ownerReference_key}
	set global variable  ${search_parameter_value}   ${Cert_Owner_Ref}
	Paginated Search for Certificate    Certificate_Search_with_searchParameters.json
	Extract certificate search response   ${certificate_search}
	should be equal  ${certificate_total_count}  ${value_as_1}
	should be equal  ${certificate_offset}    ${EMPTY}
	should be equal  ${certificate_rows}   ${EMPTY}
	length should be  ${certificate_list}     ${value_as_1}
	should be empty  ${certificate_refiners}
	length should be  ${certificate_findkeys}  ${value_as_1}
#	should be equal  ${Asset_user}  ${user_1}

10a. Validate Certificate Details
    [Tags]	Functional	asset   Search	POST    current
    Extract values from certificate list  ${certificate_list}
    should be equal  ${is_privateLabel}  [${value_as_false}]
	Compare lists  [${certificate_status}, ${certificate_version}, ${revision_number}, ${certify}]   [["${status_Under_Revision}"], ["${value_as_1.0}"], ["${value_as_0}"], ["${value_as_N}"]]
	compare lists  [${unique_certificateId}, ${CS_certificate_Id}, ${CS_certificate_hierarchyId}, ${CS_partySiteContainerId}]    [["${Certificate_Id}"], ["${Certificate_Id}"], ["${certificate_hierarchy_Id}"], ["${EMPTY}"]]
	compare lists  [${CS_certificate_type}, ${CS_certificate_name}, ${CS_Cerificate_owner_reference}, ${CS_issuing_body}, ${CS_mark}, ${CS_cert_ccn}]    [["${certificate_type_1}"], ["${certificate_name_1}-${current_time}"], ["${Cert_Owner_Ref}"], ["${issuing_body_1}"], ["${mark_1}"], ["${Scope_Code_1}"]]
	compare lists  [${CS_issueDate}, ${CS_revisionDate}, ${CS_withdrawalDate}, ${CS_expiryDate}]     [["${EMPTY}"], ["${EMPTY}"], ["${EMPTY}"], ["${EMPTY}"]]
    should be equal  ${parties}  [[${EMPTY}]]

10b. Validate findKeys searchParameters Details
    [Tags]	Functional	asset   Search	POST    current
    Extract searchParameters from findKeys dictionary    ${certificate_findkeys}
    length should be  ${FK_searchParameters_dict}     ${value_as_1}
    Extract Certificate ownerReference values from searchParameters dictionary   ${FK_searchParameters_dict}
    compare lists  ${SP_cert_ownerReference_values}  ["${Cert_Owner_Ref}", "${like_search_value}"]