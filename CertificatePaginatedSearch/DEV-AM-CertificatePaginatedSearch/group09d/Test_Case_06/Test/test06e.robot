*** Settings ***
Documentation	Certification Regression TestSuite
Resource	../../../resource/ApiFunctions.robot
Suite Setup  Link RegSchemeScopeProd1 & Reg2SchemeScope2Prod1
Suite Teardown  Unlink RegSchemeScopeProd1 & Reg2SchemeScope2Prod2

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

6. Certificates creation
	[Tags]	Functional	certificate create	POST    current
    create certificate   Certificate/CreationOfRegressionSchemeCertificate.json
    create certificate2   Certificate/CreationOfRegression2SchemeCertificate.json

7. Link Product and Evaluation to Certificates
    [Tags]	Functional	certificate	create	POST    current
    ${Trans_Id1}     Get Certificate TransactionId using Certificate Details  ${Certificate_Name}    ${Cert_Owner_Ref}  ${certificate_type_1_url}
    set global variable	${Cert_Transaction_Id}	${Trans_Id1}
    log to console	"Transaction ID": ${Cert_Transaction_Id}
    ${response}  Get ULAssetID   ${asset_Id_Product1}
    set global variable	${ul_asset_Id}	${response}
    Add Assets to Certificate  Certificate/Link_Product1_Eval1_RegressionCertificate.json    ${Certificate_Id}
    ${Trans_Id2}     Get Certificate TransactionId using Certificate Details  ${cert_name2}    ${Cert_Owner_Ref}  ${certificate_type_2_url}
    set global variable	${Cert_Transaction_Id2}	${Trans_Id2}
    log to console	"Transaction ID2": ${Cert_Transaction_Id}
    set test variable  ${Cert_Transaction_Id}   ${Cert_Transaction_Id2}
    set test variable  ${Certificate_Id}    ${Certificate_Id2}
    Add Assets to Certificate  Certificate/Link_Product1_Eval1_Regression2Certificate.json    ${Certificate_Id2}

8. Associate parties to certificates
    [Tags]	Functional	certificate	create	POST    current
    ${has_assets}    Get HasAssets using Certificate Details   ${certificate_type_1_url}   ${certificate_name}    ${Cert_Owner_Ref}   ${Certificate_Id}
    Should not be Empty     ${has_assets}
    ${has_evaluations}    Get HasEvaluations using Certificate Details   ${certificate_type_1_url}   ${certificate_name}    ${Cert_Owner_Ref}   ${Certificate_Id}
    Should not be Empty     ${has_evaluations}
    Add Parties to Certificate  Certificate/Associate_Parties_RegressionCertificate.json  ${Certificate_Id}
    ${has_assets2}    Get HasAssets using Certificate Details   ${certificate_type_2_url}   ${cert_name2}    ${Cert_Owner_Ref}   ${Certificate_Id2}
    Should not be Empty     ${has_assets}
    ${has_evaluations2}    Get HasEvaluations using Certificate Details   ${certificate_type_2_url}   ${cert_name2}    ${Cert_Owner_Ref}   ${Certificate_Id2}
    Should not be Empty     ${has_evaluations}
    Add Parties to Certificate  Certificate/Associate_Parties_RegressionCertificate.json  ${Certificate_Id2}

9. Certify certificates
    [Tags]	Functional	certificate	create	POST    current
    Add Decisions to Certificate  Certificate/Certify_RegressionCertificate_with_Dates.json     ${Certificate_Id}
    Add Decisions to Certificate  Certificate/Certify_Regression2Certificate.json     ${Certificate_Id2}

10. Validate Certificates Status
    [Tags]	Functional	certificate	create	current
    ${cert_status}  Get certificate status
    should be equal  ${cert_status}  "${status_Active}"
    set test variable  ${Certificate_Id}    ${Certificate_Id2}
    ${cert_status2}  Get certificate status
    should be equal  ${cert_status2}  "${status_Active}"

11. Search Certificate with multiple ccnList values
	[Tags]	Functional	asset   Search	POST    current
	set global variable  ${list_name}   ${ccnList_key}
	set global variable  ${list_key}   ${CCN_s_key}
	set global variable  ${list_value1}   ${Scope_Code_1}
	set global variable  ${list_value2}   ${Scope_Code_2}
	Paginated Search for Certificate    Certificate_Search_with_multipleValue_Lists.json
	Extract certificate search response   ${certificate_search}
	should not be empty  ${certificate_total_count}
	should be equal  ${certificate_offset}    ${EMPTY}
	should be equal  ${certificate_rows}   ${EMPTY}
	should not be empty  ${certificate_list}
	should be empty  ${certificate_refiners}
	length should be  ${certificate_findkeys}  ${value_as_1}
#	should be equal  ${Asset_user}  ${user_1}

11a. Validate Certificate Details
     [Tags]	Functional	asset   Search	POST    current
    ${certificate_list}  get_dictionary_from_list_of_dictionaries     ${certificate_list}     ${Cert_Owner_Ref}
	Extract values from certificate list  ${certificate_list}
    should be equal  ${is_privateLabel}  [${value_as_false}, ${value_as_false}]
	Compare lists  [${certificate_status}, ${certificate_version}, ${revision_number}, ${certify}]   [["${status_Active}", "${status_Active}"], ["${value_as_1.0}", "${value_as_1.0}"], ["${value_as_0}", "${value_as_0}"], ["${value_as_Y}", "${value_as_Y}"]]
	compare lists  [${unique_certificateId}, ${CS_certificate_Id}, ${CS_certificate_hierarchyId}, ${CS_partySiteContainerId}]    [["${Certificate_Id2}", "${Certificate_Id}"], ["${Certificate_Id2}", "${Certificate_Id}"], ["${certificate2_hierarchy_Id}", "${certificate_hierarchy_Id}"], ["${EMPTY}", "${EMPTY}"]]
	compare lists  [${CS_certificate_type}, ${CS_certificate_name}, ${CS_Cerificate_owner_reference}, ${CS_issuing_body}, ${CS_mark}, ${CS_cert_ccn}]    [["${certificate_type_2}", "${certificate_type_1}"], ["${cert_name2}", "${certificate_name}"], ["${Cert_Owner_Ref}", "${Cert_Owner_Ref}"], ["${issuing_body_1}", "${issuing_body_1}"], ["${mark_1}", "${mark_1}"], ["${Scope_Code_2}", "${Scope_Code_1}"]]
	compare lists  [${CS_issueDate}, ${CS_revisionDate}, ${CS_withdrawalDate}, ${CS_expiryDate}]     [["${today_date} ${time_00}", "${today_date} ${time_00}"], ["${EMPTY}", "${future_date_1} ${time_00}"], ["${EMPTY}", "${future_date_2} ${time_00}"], ["${EMPTY}", "${future_date_3} ${time_00}"]]
    Extract values from parties list     ${parties}
    compare lists    ${partySiteNumber_list}    ["${BO_partysite_number_1}", "${PS_partysite_number_1}", "${AP_partysite_number_1}", "${LR_partysite_number_1}", "${OR_partysite_number_1}", "${BO_partysite_number_1}", "${PS_partysite_number_1}", "${AP_partysite_number_1}", "${LR_partysite_number_1}", "${OR_partysite_number_1}"]
    compare lists    ${accountNumber_list}   ["${BO_account_number_1}", "${PS_account_number_1}", "${AP_account_number_1}", "${LR_account_number_1}", "${OR_account_number_1}", "${BO_account_number_1}", "${PS_account_number_1}", "${AP_account_number_1}", "${LR_account_number_1}", "${OR_account_number_1}"]
    compare lists    ${relationshipType_list}    ["${party_brand_owner}", "${party_production_site}", "${party_applicant}", "${party_local_representative}", "${party_owner_reference}", "${party_brand_owner}", "${party_production_site}", "${party_applicant}", "${party_local_representative}", "${party_owner_reference}"]

11b. Validate findKeys Lists Details
    [Tags]	Functional	asset   Search	POST    current
    Extract Certificate ccnList values from findKeys dictionary  ${certificate_findkeys}
    compare lists  ${FK_ccn_values}  ["${Scope_Code_1}", "${Scope_Code_2}"]