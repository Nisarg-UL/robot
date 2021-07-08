*** Settings ***
Documentation	SingleModel TestSuit
Resource	../../../resource/ApiFunctions.robot
Suite Setup  Link RegressionScheme-Scope-Product1
Suite Teardown  Unlink Scheme Scope    Unlink_ScopeScheme.json

*** Keywords ***

*** Test Cases ***
1a. Setting up Environment
    [Tags]	Functional	POST    current
	set global variable	${asset_Id_Product1}
	set global variable  ${entity_name}    Regression Scheme
	set global variable  ${tab_name}    CERTIFY
	set global variable  ${role}    Public
	set global variable  ${user}    ManojAutomation
	set global variable  ${read_access}    Y

1b. Role Access Configuration With POST Request
	[Tags]	Functional	POST    current
    Configure Role Access    ConfigureRole_CertificateCertify.json   Certificate
    should be equal  ${access_role}   Public

1. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    create product1 asset	CreationOfRegressionProduct1_siscase1.json

2. Check Asset State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

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
	${assessmentId}  Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId}	${assessmentId}

6. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}

7. Check Asset State After Evaluation
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'immutable'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

8. Certificate Creation
	[Tags]	Functional	certificate	create	POST    current
    create certificate   Certificate/CreationOfRegressionSchemeCertificate_withReferenceAttributes.json

9. Link Product to Certificate
    [Tags]	Functional	certificate	create	POST    current
    ${Trans_Id1}     Get Certificate TransactionId using Certificate Details  ${Certificate_Name}    ${Cert_Owner_Ref}  ${scheme}
    set global variable	${Cert_Transaction_Id}	${Trans_Id1}
    log to console	"Transaction ID": ${Cert_Transaction_Id}
    ${response}  Get ULAssetID   ${asset_Id_Product1}
    set global variable	${ul_asset_Id}	${response}
    Add Assets to Certificate  Certificate/Link_Product1_Eval1_RegressionCertificate.json    ${Certificate_Id}

10. Associate parties to certificate
    [Tags]	Functional	certificate	create	POST    current
    ${has_assets}    Get HasAssets using Certificate Details   Regression%20Scheme   ${Certificate_Name}    ${Cert_Owner_Ref}   ${Certificate_Id}
    Should not be Empty     ${has_assets}
    ${has_evaluations}    Get HasEvaluations using Certificate Details   Regression%20Scheme   ${Certificate_Name}    ${Cert_Owner_Ref}   ${Certificate_Id}
    Should not be Empty     ${has_evaluations}
    Add Parties to Certificate  Certificate/Associate_Parties_RegressionCertificate.json  ${Certificate_Id}

11. Certify certificate with Decisioning
    [Tags]	Functional	certificate	create	POST    current
    Add Decisions to Certificate  Certificate/Add_DecisionsToCertificate_RegressionScheme.json    ${Certificate_Id}

12. Validate Certificate Status
    [Tags]	Functional	certificate	create	current
    ${response}  Get certificate status
    log to console  ${response}
    run keyword if	${response} != "Active"	Fail	test1 Teardown

13. Certificate Audit using UserId & Role
    [Tags]	Functional	current
    ${response}  Certificate Audit  certificateId=${Certificate_Id}&user=81349&role=Pubic
    ${attr_names}	projectHistory_certify_attributes  ${response}    name
    run keyword if  ${attr_names} != ['Issue Date', 'Revision Date', 'Withdrawal Date', 'Expiry Date', 'Certification Comment', 'Certifier Employee Name', 'Certifier Employee Number']     Fail
    ${attr_display_names}	projectHistory_certify_attributes  ${response}    displayName
    run keyword if  ${attr_display_names} != ['Date of Issue', 'Date of Revision', 'Date of Withdrawn', 'Date of Expiry', 'Certification Comment', 'Certifier Employee Name', 'Certifier Employee Number']     Fail

14. Disfigure Role With POST Request
	[Tags]	Functional	POST    current
	set global variable  ${read_access}    N
    Disfigure Role Access    ConfigureRole_CertificateCertify.json   Certificate
    should be equal  ${access_role}   Public