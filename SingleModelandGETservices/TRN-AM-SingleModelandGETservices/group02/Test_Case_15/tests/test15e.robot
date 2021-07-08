*** Settings ***
Documentation	SingleModel TestSuit
Resource	../../../resource/ApiFunctions.robot
Suite Setup  Link RegressionScheme-Scope-Product1
Suite Teardown  Unlink Scheme Scope    Unlink_ScopeScheme.json

*** Keywords ***

*** Test Cases ***
1. Role Access Configuration With POST Request
	[Tags]	Functional	POST    current
    Configure Role Access    Product/ConfigureRole_Public_forProduct1.json   Asset
    should be equal  ${access_role}   Public

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
    create certificate   Certificate/CreationOfRegressionSchemeCertificate_withReferenceAttributes.json

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
    Create private label    Private_Label/CreationOfPrivateLabel_RegressionSchemeCertificate_withReferenceAttributes.json
    should not be empty  ${PrivateLabel_Id}
    log to console  ${PrivateLabel_Id}

14. Add Asset To Private Label
    [Tags]	Functional	certificate	PL  create	POST    current
    ${response}  Add Asset To PL  Private_Label/Add_Asset_To_Private_Label.json
    set global variable  ${PrivateLabel_Asset_Id}   ${response}

15. View Private Label Asset details using Role
	[Tags]	Functional	certificate create	POST    current
	${result}    View Private Label Assets using Role     ${PrivateLabel_Asset_Id}   Public
    run keyword if  "${result}" != "${PrivateLabel_Asset_Id}"     Fail

16. Get Asset Details using UserId & Role
	[Tags]	Functional	certificate create	POST    current
	Get Asset Details using UserId & Role     ${asset_Id_Product1}   81349   Public
	should not be empty   ${Asset_attr}
    run keyword if  "${Asset_Collection_Id}" != "${Collection_Id}"     Fail
    ${attr_names}	get_attribute_names  ${Asset_attr}   name
    should not be empty  ${attr_names}
    run keyword if  ${attr_names} != ['Product Type', 'Owner Reference (Party Site ID)', 'Reference Number', 'Family / Series', 'Model Name', 'Creation Date', 'TP1 Attribute 1', 'TP1 Attribute 2', 'TP1 Attribute 3', 'TP1 Attribute 4', 'TP1 Attribute 5', 'TP1 Attribute 6', 'TP1 Attribute 7', 'TP1 Attribute 8', 'TP1 Attribute 9', 'TP1 Attribute 10', 'TP1 Attribute 11', 'TP1 Attribute 12', 'TP1 Attribute 13', 'TP1 Attribute 14', 'TP1 Attribute 15', 'TP1 Attribute 16', 'TP1 Attribute 17', 'TP1 Attribute 18', 'TP1 Attribute 19', 'TP1 Attribute 20', 'TP1 Attribute 21', 'TP1 Attribute 22', 'TP1 Attribute 23', 'TP1 Attribute 24', 'TP1 Attribute 25', 'TP1 Attribute 25', 'TP1 Attribute 25', 'TP1 Attribute 26', 'TP1 Attribute 26', 'TP1 Attribute 26', 'TP1 Attribute 27', 'TP1 Attribute 28', 'TP1 Attribute 29', 'TP1 Attribute 30', 'TP1 Attribute 31', 'TP1 Attribute 32', 'TP1 Attribute 32', 'TP1 Attribute 33', 'TP1 Attribute 33', 'TP1 Attribute 34', 'TP1 Attribute 34', 'TP1 Attribute 35', 'TP1 Attribute 35', 'TP1 Attribute 36', 'TP1 Attribute 36', 'TP1 Attribute 38', 'TP1 Attribute 40', 'TP1 Attribute 40', 'TP1 Attribute 42', 'TP1 Attribute 42', 'TP1 Attribute 42', 'TP1 Attribute 44', 'TP1 Attribute 46', 'TP1 Attribute 49', 'TP1 Attribute 51', 'TP1 Attribute 51', 'TP1 Attribute 53', 'TP1 Attribute 53', 'TP1 Attribute 53', 'TP1 Attribute 55', 'TP1 Attribute 55', 'TP1 Attribute 57', 'TP1 Attribute 57', 'TP1 Attribute 57', 'TP1 Attribute 62', 'TP1 Attribute 62', 'TP1 Attribute 63', 'TP1 Attribute 63', 'TP1 Attribute 63', 'TP1 Attribute 64', 'TP1 Attribute 64', 'TP1 Attribute 64', 'TP1 Attribute 65', 'TP1 Attribute 65', 'TP1 Attribute 65', 'TP1 Attribute 66', 'TP1 Attribute 66', 'TP1 Attribute 67', 'TP1 Attribute 68', 'TP1 Attribute 69', 'TP1 Attribute 69', 'TP1 Attribute 70', 'TP1 Attribute 70', 'TP1 Attribute 71', 'TP1 Attribute 71', 'TP1 Attribute 72', 'TP1 Attribute 73', 'metadataId', 'CCN', 'Collection Name', 'Order Number', 'Project Number', 'Quote Number', 'Shared Attribute 1', 'Shared Attribute 2', 'Shared Attribute 3', 'Shared Attribute 4', 'Shared Attribute 5', 'Shared Attribute 6', 'Shared Attribute 7', 'Shared Attribute 8', 'Shared Attribute 9', 'Shared Attribute 10', 'Shared Attribute 11', 'Shared Attribute 12']   Fail
    ${attr_display_names}	get_attribute_names  ${Asset_attr}   displayName
    should not be empty  ${attr_display_names}
    run keyword if  ${attr_display_names} != ['Product Type', 'Owner Reference (Party Site Number)', 'Reference Number (ex. File Number)', 'Family / Series', 'Model Name', 'Creation Date', 'Mask for TP1 Att 1', 'Mask for TP1 Att 2', 'Mask for TP1 Att 3', 'Mask for TP1 Att 4', 'Mask for TP1 Att 5', 'Mask for TP1 Att 6', 'Mask for TP1 Att 7', 'Mask for TP1 Att 8', 'Mask for TP1 Att 9', 'Mask for TP1 Att 10', 'Mask for TP1 Att 11', 'Mask for TP1 Att 12', 'Mask for TP1 Att 13', 'Mask for TP1 Att 14', 'Mask for TP1 Att 15', 'Mask for TP1 Att 16', 'Mask for TP1 Att 17', 'Mask for TP1 Att 18', 'Mask for TP1 Att 19', 'Mask for TP1 Att 20', 'Mask for TP1 Att 21', 'Mask for TP1 Att 22', 'Mask for TP1 Att 23', 'Mask for TP1 Att 24', 'Mask for TP1 Att 25', 'Mask for TP1 Att 25', 'Mask for TP1 Att 25', 'Mask for TP1 Att 26', 'Mask for TP1 Att 26', 'Mask for TP1 Att 26', 'Mask for TP1 Att 27', 'Mask for TP1 Att 28', 'Mask for TP1 Att 29', 'Mask for TP1 Att 30', 'Mask for TP1 Att 31', 'Mask for TP1 Att 32', 'Mask for TP1 Att 32', 'Mask for TP1 Att 33', 'Mask for TP1 Att 33', 'Mask for TP1 Att 34', 'Mask for TP1 Att 34', 'Mask for TP1 Att 35', 'Mask for TP1 Att 35', 'Mask for TP1 Att 36', 'Mask for TP1 Att 36', 'Mask for TP1 Att 38', 'Mask for TP1 Att 40', 'Mask for TP1 Att 40', 'Mask for TP1 Att 42', 'Mask for TP1 Att 42', 'Mask for TP1 Att 42', 'Mask for TP1 Att 44', 'Mask for TP1 Att 46', 'Mask for TP1 Att 49', 'Mask for TP1 Att 51', 'Mask for TP1 Att 51', 'Mask for TP1 Att 53', 'Mask for TP1 Att 53', 'Mask for TP1 Att 53', 'Mask for TP1 Att 55', 'Mask for TP1 Att 55', 'Mask for TP1 Att 57', 'Mask for TP1 Att 57', 'Mask for TP1 Att 57', 'Mask for TP1 Att 62', 'Mask for TP1 Att 62', 'Mask for TP1 Att 63', 'Mask for TP1 Att 63', 'Mask for TP1 Att 63', 'Mask for TP1 Att 64', 'Mask for TP1 Att 64', 'Mask for TP1 Att 64', 'Mask for TP1 Att 65', 'Mask for TP1 Att 65', 'Mask for TP1 Att 65', 'Mask for TP1 Att 66', 'Mask for TP1 Att 66', 'Mask for TP1 Att 67', 'Mask for TP1 Att 68', 'Mask for TP1 Att 69', 'Mask for TP1 Att 69', 'TP1 Attribute 70', 'TP1 Attribute 70', 'TP1 Attribute 71', 'TP1 Attribute 71', 'TP1 Attribute 72', 'TP1 Attribute 73', 'CCN', 'Collection Name', 'Order Number', 'Project Number', 'Quote Number', 'Mask for Shared Att 1', 'Mask for Shared Att 2', 'Mask for Shared Att 3', 'Mask for Shared Att 4', 'Mask for Shared Att 5', 'Mask for Shared Att 6', 'Mask for Shared Att 7', 'Mask for Shared Att 8', 'Mask for Shared Att 9', 'Mask for Shared Att 10', 'Mask for Shared Att 11', 'Mask for Shared Att 12']  Fail

17. Disfigure Role With POST Request
	[Tags]	Functional	POST    current
    Disfigure Role Access    Product/DisfigureRole_Public_forProduct1.json   Asset
    should be equal  ${access_role}   Public