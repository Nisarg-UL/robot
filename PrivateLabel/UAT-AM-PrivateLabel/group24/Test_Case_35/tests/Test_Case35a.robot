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

2. Get the Colletion_ID
    [Tags]	Functional	current
    Get Collection_ID   ${asset_Id_Product1}
    set global variable     ${Product_Collection_Id}    ${Collection_Id}

3. Asset2 Creation with POST Request
    [Tags]	Functional	asset	create	POST    current
    create Asset2 based on product1 Asset1   CreationOfRegressionProduct1Asset2_siscase1_withCol_ID.json

4. Check Asset State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}
	${state}=	Get Asset State	${asset_Id_Product12}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

5. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productnoevalreqd.json	${asset_Id_Product1}
	standard assignment	productnoevalreqd.json	${asset_Id_Product12}

6. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}
	${state}=	Get Asset State	${asset_Id_Product12}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

7. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${assessmentId}  Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId1}	${assessmentId}
	${assessmentId2}  Get AssesmentID	${asset_Id_Product12}
	set global variable	${assessmentId2}	${assessmentId2}

8. Complete Evaluation for two Assets
	[Tags]	Functional	POST	current
	set global variable	${assessmentId}	${assessmentId1}
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
    set global variable	${assessmentId}	${assessmentId2}
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product12}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product12}

9. Check Asset State After Evaluation
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'immutable'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}
	${state}=	Get Asset State	${asset_Id_Product12}
	run keyword if	'${state}' != 'immutable'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

10. Certificate Creation
	[Tags]	Functional	certificate	create	POST    current
    create certificate   Certificate/CreationOfRegressionSchemeCertificate.json

11. Link Product to Certificate
    [Tags]	Functional	certificate	create	POST    current
    ${Trans_Id1}     Get Certificate TransactionId using Certificate Details  ${Certificate_Name}    ${Cert_Owner_Ref}  ${scheme}
    set global variable	${Cert_Transaction_Id}	${Trans_Id1}
    log to console	"Transaction ID": ${Cert_Transaction_Id}
    ${response}  Get ULAssetID   ${asset_Id_Product1}
    set global variable	${ul_asset_Id}	${response}
    ${response1}  Get ULAssetID   ${asset_Id_Product12}
    set global variable	${ul_asset_Id_2}	${response1}
    Add Assets to Certificate  Certificate/Link_Product1_&_Product2_Certificate.json    ${Certificate_Id}

12. Associate parties to certificate
    [Tags]	Functional	certificate	create	POST    current
    ${has_assets}    Get HasAssets using Certificate Details   Regression%20Scheme   ${Certificate_Name}    ${Cert_Owner_Ref}   ${Certificate_Id}
    Should not be Empty     ${has_assets}
    ${has_evaluations}    Get HasEvaluations using Certificate Details   Regression%20Scheme   ${Certificate_Name}    ${Cert_Owner_Ref}   ${Certificate_Id}
    Should not be Empty     ${has_evaluations}
    Add Parties to Certificate  Certificate/Associate_Parties_With2Product_Certificate.json  ${Certificate_Id}

13. Certify certificate
    [Tags]	Functional	certificate	create	POST    current
    Add Decisions to Certificate  Certificate/Certify_RegressionCertificate.json     ${Certificate_Id}

14. Create Private Label
    [Tags]	Functional	certificate	PL  create	POST    current
    Create private label    Private_Label/CreationOfPrivateLabel_RegressionSchemeCertificate.json
    should not be empty  ${PrivateLabel_Id}
    log to console  ${PrivateLabel_Id}

15. Add Asset To Private Label
    [Tags]	Functional	certificate	PL  create	POST    current
    ${pl_asset1}    Add Asset To Private Label  Private_Label/Add_Asset_To_Private_Label.json   ${PrivateLabel_Id}
    set global variable  ${PrivateLabel_Asset_Id1}   ${pl_asset1}
    ${pl_asset2}  Add Asset To Private Label  Private_Label/Add_Asset2_To_Private_Label.json   ${PrivateLabel_Id}
    set global variable  ${PrivateLabel_Asset_Id2}   ${pl_asset2}
    ${pl_asset12}  Add Asset To Private Label  Private_Label/Add_Second_Asset_To_Private_Label.json   ${PrivateLabel_Id}
    set global variable  ${PrivateLabel_Asset_Id12}   ${pl_asset12}

16. Edit Private Label Asset with Duplicate Taxonomy of different Base Asset & Existing Reference Number
    [Tags]	Functional	certificate	PL  create	POST    current
    Edit Private Label Asset taxonomy and model nomenclature  Edit_PL_Asset_DuplicateTaxonomy_OfDifferentBaseAsset_ExistingReferenceNumber_ChangeFlag_Y.json   ${PrivateLabel_Id}
    ${success_models}   pl_asset_edit_values    ${pl_asset_edit_success}    ${modelName_key}
    should be equal  ${success_models}   ["${pl_model_name_1}_${current_time}", "PL_Regression_Test_Model_12", "PL_Regression_Test_Model_12"]
    ${success_pl_assetId}  pl_asset_edit_values    ${pl_asset_edit_success}  ${plAssetId_key}
    should be equal  ${success_pl_assetId}   ["${PrivateLabel_Asset_Id1}", "${PrivateLabel_Asset_Id12}", "${PrivateLabel_Asset_Id2}"]
    ${success_assetId}   pl_asset_edit_values    ${pl_asset_edit_success}    ${AssetId_key}
    should be equal  ${success_assetId}   ["${asset_Id_Product1}", "${asset_Id_Product12}", "${asset_Id_Product1}"]
    should be empty  ${pl_asset_edit_error}

17. View Private Label Assets
    [Tags]	Functional	certificate	PL  POST    current
    View Private Label Assets Details    ${PrivateLabel_Id}
    should not be empty  ${pl_assets}
#    should be equal  ${PL_Id}   ["${PrivateLabel_Id}", "${PrivateLabel_Id}"]
    should be equal  ${PL_Asset_Id}   ["${PrivateLabel_Asset_Id1}", "${PrivateLabel_Asset_Id2}", "${PrivateLabel_Asset_Id12}"]
    should be equal  ${Asset_Id}   ["${asset_Id_Product1}", "${asset_Id_Product1}", "${asset_Id_Product12}"]
#    should be equal  ${UL_Asset_Id}   ["${asset_Id_Product1}", "${asset_Id_Product1}"]
    should be equal  ${pl_asset_model_name}   ["${pl_model_name_1}_${current_time}", "PL_Regression_Test_Model_12", "PL_Regression_Test_Model_12"]
    should be equal  ${pl_asset_ref_no}   ["PL_DEMOFILE01", "PL_DEMOFILE01", "PL_DEMOFILE01"]
