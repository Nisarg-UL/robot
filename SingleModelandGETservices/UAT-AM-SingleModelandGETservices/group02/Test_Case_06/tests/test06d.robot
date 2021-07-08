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

15. View Private Label Asset details without using UserId & Role
	[Tags]	Functional	certificate create	POST    current
	${result}    View Private Label Assets using Certificate     ${Certificate_Id}  ${asset_Id_Product1}   ${EMPTY}
    run keyword if  "${result}" != "${asset_Id_Product1}"     Fail

16. Get Asset Details without using UserId & Role
	[Tags]	Functional	 create	POST    current
	Get Asset Details     ${asset_Id_Product1}
	should not be empty   ${Asset_attr}
    run keyword if  "${Asset_Collection_Id}" != "${Collection_Id}"     Fail
    ${attr_names}	get_attribute_names  ${Asset_attr}   name
    run keyword if  ${attr_names} != ['TP1 Attribute 1', 'TP1 Attribute 2', 'TP1 Attribute 3', 'TP1 Attribute 4', 'TP1 Attribute 5']    Fail
    ${attr_names}	get_attribute_names  ${Asset_attr}   displayName
    run keyword if  ${attr_names} != ['Mask for TP1 Att 1', 'Mask for TP1 Att 2', 'Mask for TP1 Att 3', 'Mask for TP1 Att 4', 'Mask for TP1 Att 5']    Fail

17. Disfigure Role With POST Request
	[Tags]	Functional	POST    current
    Disfigure Role Access    Product/DisfigureRole_Public_forProduct1.json   Asset
    should be equal  ${access_role}   Public