*** Settings ***
Documentation	Private Label TestSuite
Resource	../../../resource/ApiFunctions.robot
Suite Setup  Link RegressionScheme-Scope-Product1
Suite Teardown  Unlink Scheme Scope    Unlink_ScopeScheme.json

*** Keywords ***


*** Test Cases ***
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
    create certificate   Certificate/CreationOfRegressionSchemeCertificate.json

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

11. Certify certificate
    [Tags]	Functional	certificate	create	POST    current
    Add Decisions to Certificate  Certificate/Certify_RegressionCertificate.json     ${Certificate_Id}

12. Create Private Label
    [Tags]	Functional	certificate	PL  create	POST    current
    Create private label    Private_Label/CreationOfPrivateLabel_RegressionSchemeCertificate.json
    should not be empty  ${PrivateLabel_Id}
    log to console  ${PrivateLabel_Id}

13. Add Asset To Private Label
    [Tags]	Functional	certificate	PL  create	POST    current
    ${pl_asset1}    Add Asset To Private Label  Private_Label/Add_Asset_To_Private_Label.json   ${PrivateLabel_Id}
    set global variable  ${PrivateLabel_Asset_Id1}   ${pl_asset1}
    ${pl_asset2}  Add Asset To Private Label  Private_Label/Add_Asset2_To_Private_Label.json   ${PrivateLabel_Id}
    set global variable  ${PrivateLabel_Asset_Id2}   ${pl_asset2}

14. View Private Label Assets
    [Tags]	Functional	certificate	PL  POST    current
    View Private Label Assets    ${PrivateLabel_Asset_Id1}
    should be equal  ${PL_Id}   ${PrivateLabel_Id}
    should be equal  ${PL_Asset_Id}   ${PrivateLabel_Asset_Id1}
    should be equal  ${pl_asset_model_name}   ["${pl_model_name_1}_${current_time}"]
    should be equal  ${pl_asset_ref_no}   ["PL_DEMOFILE01"]
    View Private Label Assets Content Attributes    ${PrivateLabel_Asset_Id1}
    should be equal  ${PL_Id}   ${PrivateLabel_Id}
    should be equal  ${PL_Asset_Id}   ${PrivateLabel_Asset_Id1}
    should be equal  ${pl_asset_model_nomenclature}  ${pl_modelNomenclature_1}

14. Edit Private Label Asset with Invalid model_nomenclature Object
    [Tags]	Functional	certificate	PL  create	POST    current
    run keyword and ignore error     Edit Private Label Asset taxonomy and model nomenclature  Edit_PL_Asset_Invalid_model_nomenclature_Object.json   ${PrivateLabel_Id}
    should be empty  ${pl_asset_edit_error}
    ${success_pl_assetId}   pl_asset_edit_values    ${pl_asset_edit_success}    ${plAssetId_key}
    should be equal  ${success_pl_assetId}   ["${PrivateLabel_Asset_Id1}"]
    ${success_assetId}   pl_asset_edit_values    ${pl_asset_edit_success}    ${AssetId_key}
    should be equal  ${success_assetId}   ["${asset_Id_Product1}"]

16. View Private Label Assets
    [Tags]	Functional	certificate	PL  POST    current
    View Private Label Assets    ${PrivateLabel_Asset_Id1}
    should be equal  ${PL_Id}   ${PrivateLabel_Id}
    should be equal  ${PL_Asset_Id}   ${PrivateLabel_Asset_Id1}
    should be equal  ${pl_asset_model_name}   ["${pl_model_name_1}_${current_time}"]
    should be equal  ${pl_asset_ref_no}   ["PL_DEMOFILE01"]
    View Private Label Assets Content Attributes    ${PrivateLabel_Asset_Id1}
    should be equal  ${PL_Id}   ${PrivateLabel_Id}
    should be equal  ${PL_Asset_Id}   ${PrivateLabel_Asset_Id1}
    should be equal  ${pl_asset_model_nomenclature}  ${pl_modelNomenclature_1}