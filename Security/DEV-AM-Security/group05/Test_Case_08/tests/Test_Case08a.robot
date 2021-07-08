*** Settings ***
Documentation	Security TestSuite
Resource	../../../resource/ApiFunctions.robot
Suite Setup  Link RegressionScheme-Scope-Product1
Suite Teardown  Unlink Scheme Scope    Unlink_ScopeScheme.json

*** Keywords ***
test1 Teardown
	Log To Console	test1a Teardown Beginning
	Expire The Asset	${asset_Id_Product1}
	Log To Console	test1a Teardown Finished

*** Test Cases ***
1a. Setting up Environment
	set global variable	${asset_Id_Product1}

1. Role Access Configuration With POST Request
	[Tags]	Functional	POST    current
	Configure Role Access    Certificate/ConfigureRole_Public_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Public
    Configure Role Access    Certificate/ConfigureRole_Owner_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Owner
    Configure Role Access    Certificate/ConfigureRole_BrandOwner_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Brand Owner
    Configure Role Access    Certificate/ConfigureRole_ProductionSite_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Production Site
    Configure Role Access    Certificate/ConfigureRole_LocalRepresentative_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Local Representative
    Configure Role Access    Certificate/ConfigureRole_Applicant_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Applicant

2. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    create product1 asset	CreationOfRegressionProduct1_siscase1.json

3. Check Asset State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

4. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productnoevalreqd.json	${asset_Id_Product1}

5. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

6. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${assessmentId}  Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId}	${assessmentId}

7. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}

8. Check Asset State After Evaluation
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'immutable'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

9. Certificate Creation
	[Tags]	Functional	certificate	create	POST    current
    create certificate   Certificate/CreationOfRegressionSchemeCertificate.json

10. Link Product to Certificate
    [Tags]	Functional	certificate	create	POST    current
    ${Trans_Id1}     Get Certificate TransactionId using Certificate Details  ${Certificate_Name}    ${Cert_Owner_Ref}  ${scheme}
    set global variable	${Cert_Transaction_Id}	${Trans_Id1}
    log to console	"Transaction ID": ${Cert_Transaction_Id}
    ${response}  Get ULAssetID   ${asset_Id_Product1}
    set global variable	${ul_asset_Id}	${response}
    Add Assets to Certificate  Certificate/Link_Product1_Eval1_RegressionCertificate.json    ${Certificate_Id}

11. Associate parties to certificate
    [Tags]	Functional	certificate	create	POST    current
    ${has_assets}    Get HasAssets using Certificate Details   Regression%20Scheme   ${Certificate_Name}    ${Cert_Owner_Ref}   ${Certificate_Id}
    Should not be Empty     ${has_assets}
    ${has_evaluations}    Get HasEvaluations using Certificate Details   Regression%20Scheme   ${Certificate_Name}    ${Cert_Owner_Ref}   ${Certificate_Id}
    Should not be Empty     ${has_evaluations}
    Add Parties to Certificate  Certificate/Associate_Parties_With2Product_Certificate.json  ${Certificate_Id}

12. Certify certificate
    [Tags]	Functional	certificate	create	POST    current
    Add Decisions to Certificate  Certificate/Certify_RegressionCertificate.json     ${Certificate_Id}

13. Create Private Label
    [Tags]	Functional	certificate	PL  create	POST    current
    Create private label    Private_Label/CreationOfPrivateLabel_RegressionSchemeCertificate.json

14. View Private Label details using Role
	[Tags]	Functional	certificate create	POST    current
	View Private Label details using Role     ${PrivateLabel_Id}   Public;Owner;Brand%20Owner;Production%20Site;Local%20Representative;Applicant
    should not be empty   ${cert_attr}
    ${attr_name}	get_attribute_names  ${cert_attr}   name
    compare lists  ${attr_name}  ['Certificate Type', 'Issuing Body', 'Mark', 'Certificate Name', 'Revision Number', 'Owner Reference', 'Certification Scheme Owner', 'CCN', 'Model Numbers', 'Certification Scheme Product Type', 'Certification Scheme Product Type Code', 'Standard Number', 'Standard Code', 'Standard Detail', 'Standard Description', 'IR Reference', 'TGA Reference', 'Footnote Symbol', 'Footnote Text', 'Test Date', 'Electrical Efficiency Rated', 'Energy Efficiency Rating']
    run keyword if  ${pl_status} != "Under Revision"     Fail

15. Disfigure Role With POST Request
	[Tags]	Functional	POST    current
	Disfigure Role Access    Certificate/DisfigureRole_Public_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Public
    Disfigure Role Access    Certificate/DisfigureRole_Owner_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Owner
    Disfigure Role Access    Certificate/DisfigureRole_BrandOwner_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Brand Owner
    Disfigure Role Access    Certificate/DisfigureRole_ProductionSite_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Production Site
    Disfigure Role Access    Certificate/DisfigureRole_LocalRepresentative_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Local Representative
    Disfigure Role Access    Certificate/DisfigureRole_Applicant_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Applicant