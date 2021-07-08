*** Settings ***
Documentation	Reference Data Consumption TestSuite
Resource	../../../resource/ApiFunctions.robot
Suite Setup  Link RegressionScheme-Scope-Product1
Suite Teardown   Unlink Scheme Scope    Unlink_ScopeScheme.json
*** Keywords ***

*** Test Cases ***
1a. Role Access Configuration With POST Request
	[Tags]	Functional	POST    current
    Configure Role Access    Certificate/ConfigureRole_Public_RefAttributes_forRegScheme.json   Certificate
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
#	set global variable  ${RegressionScheme_schemeScopeId}   ${EMPTY}
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
    Add Parties to Certificate  Certificate/Associate_Parties_With2Product_Certificate.json  ${Certificate_Id}

11. Validate Certificate Reference Attributes
    [Tags]	Functional	certificate    current
    Validate Certificate Reference Attributes   ${Certificate_Id}
    should be empty  ${ref_attr_errors}

12. Certify certificate
    [Tags]	Functional	certificate	create	POST    current
    Add Decisions to Certificate  Certificate/Certify_RegressionCertificate.json     ${Certificate_Id}

13. Validate Certificate Status
    [Tags]	Functional	certificate	create	current
    ${response}  Get certificate status
    log to console  ${response}
    run keyword if	${response} != "Active"	Fail	test1 Teardown

14. Create Private Label
    [Tags]	Functional	certificate	PL  create	POST    current
    Create private label    Private_Label/CreationOfPrivateLabel_RegressionSchemeCertificate_withReferenceAttributes.json
    should not be empty  ${PrivateLabel_Id}
    log to console  ${PrivateLabel_Id}

15. Add Asset To Private Label
    [Tags]	Functional	certificate	PL  POST    current
    ${response}  Add Asset To PL  Private_Label/Add_Asset_To_Private_Label.json
    set global variable  ${PrivateLabel_Asset_Id}   ${response}

16. Validate Certificate Reference Attributes
    [Tags]	Functional	certificate    current
    Validate Certificate Reference Attributes   ${PrivateLabel_Id}
    should be empty  ${ref_attr_errors}

17. Get Private Label Details
    [Tags]	Functional	certificate    current
    View Private Label Details using Mode     ${PrivateLabel_Id}    edit
    should not be empty  ${pl_ref_attr}
    length should be  ${pl_ref_attr}   2

18. Edit Private Label
    [Tags]	Functional	certificate	PL  Edit    POST    current
    set test variable  ${Regression_schemeScopeId}   ${EMPTY}
    set test variable  ${RegVal_schemeScopeStandardId}   ${EMPTY}
    Edit Private Label    Private_Label/EditOfPrivateLabel_RegressionSchemeCertificate_withReferenceAttributes.json    ${PrivateLabel_Id}
    log to console  ${PrivateLabel_Id_Edit}

19. Validate Certificate Reference Attributes
    [Tags]	Functional	certificate    current
    Validate Certificate Reference Attributes   ${PrivateLabel_Id_Edit}
    should be empty  ${ref_attr_errors}

20. Get Private Label Details
    [Tags]	Functional	certificate    current
    View Private Label Details using Mode     ${PrivateLabel_Id_Edit}    edit
    should not be empty  ${pl_ref_attr}
    length should be  ${pl_ref_attr}   2

21. Disfigure Role With POST Request
	[Tags]	Functional	POST    current
    Disfigure Role Access    Certificate/DisfigureRole_Public_RefAttributes_forRegScheme.json   Certificate
    should be equal  ${access_role}   Public