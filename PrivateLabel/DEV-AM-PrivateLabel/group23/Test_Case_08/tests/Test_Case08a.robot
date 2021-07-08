*** Settings ***
Documentation	Private Label TestSuite
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

1. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    Notcurrent
    create product1 asset	CreationOfRegressionProduct1_siscase1.json

2. Check Asset State
	[Tags]	Functional	Notcurrent
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

3. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	Notcurrent
	standard assignment	productnoevalreqd.json	${asset_Id_Product1}

4. Check Asset State After Associating Standard to Product
	[Tags]	Functional	Notcurrent
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

5. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	Notcurrent
	${assessmentId}  Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId}	${assessmentId}

6. Complete Evaluation
	[Tags]	Functional	POST	Notcurrent
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}

7. Check Asset State After Evaluation
	[Tags]	Functional	Notcurrent
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'immutable'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

8. Certificate1 Creation
	[Tags]	Functional	certificate	create	POST    Notcurrent
    create certificate   Certificate/CreationOfRegressionSchemeCertificate.json

9. Link Product to Certificate1
    [Tags]	Functional	certificate	create	POST    Notcurrent
    ${Trans_Id1}     Get Certificate TransactionId using Certificate Details  ${Certificate_Name}    ${Cert_Owner_Ref}  ${scheme}
    set global variable	${Cert_Transaction_Id}	${Trans_Id1}
    log to console	"Transaction ID": ${Cert_Transaction_Id}
    ${response}  Get ULAssetID   ${asset_Id_Product1}
    set global variable	${ul_asset_Id}	${response}
    Add Assets to Certificate  Certificate/Link_Product1_Eval1_RegressionCertificate.json    ${Certificate_Id}

10. Associate parties to certificate1
    [Tags]	Functional	certificate	create	POST    Notcurrent
    ${has_assets}    Get HasAssets using Certificate Details   Regression%20Scheme   ${Certificate_Name}    ${Cert_Owner_Ref}   ${Certificate_Id}
    Should not be Empty     ${has_assets}
    ${has_evaluations}    Get HasEvaluations using Certificate Details   Regression%20Scheme   ${Certificate_Name}    ${Cert_Owner_Ref}   ${Certificate_Id}
    Should not be Empty     ${has_evaluations}
    Add Parties to Certificate  Certificate/Associate_Parties_With2Product_Certificate.json  ${Certificate_Id}

11. Certify certificate1
    [Tags]	Functional	certificate	create	POST    Notcurrent
    Add Decisions to Certificate  Certificate/Certify_RegressionCertificate.json     ${Certificate_Id}

12. Create Private Label1
    [Tags]	Functional	certificate	PL  create	POST    Notcurrent
    Create private label    Private_Label/CreationOfPrivateLabel_RegressionSchemeCertificate.json

13. Add Asset To Private Label1
    [Tags]	Functional	certificate	PL  POST    Notcurrent
    ${response}  Add Asset To PL  Private_Label/Add_Asset_To_Private_Label.json
    set global variable  ${PrivateLabel_Asset_Id}   ${response}

14. View Private Label1 Asset
    [Tags]	Functional	certificate	PL  POST    Notcurrent
    ${result}  View Private Label Assets    ${PrivateLabel_Asset_Id}
    run keyword if  '${result}' != '${PrivateLabel_Asset_Id}'     Fail   test1 Teardown
    log to console  Private Lable Asset ID: ${result}

15. Add Party To Private Label1
    [Tags]	Functional	certificate	PL  POST    Notcurrent
    Add Party To PL  Private_Label/Add_Parties_To_Private_Label.json

16. Certify Private Label1
    [Tags]	Functional	certificate	PL  POST    Notcurrent
    Certify Private Label  Private_Label/Certify_PrivateLabelCertificate.json

17. Modify Asset1 Attribute
    [Tags]	Functional	asset	create	POST    Notcurrent
    Modify Product1 Asset   ModifyAttRegressionProduct1_siscase1_withDiffColName.json    ${asset_Id_Product1}

18. Check for Asset State for modified Asset
	[Tags]	Functional	Notcurrent
	${state}=	Get Asset State	${asset_Id_Product12}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_Asset_State": ${state}

19. Modify base Certificate1
	[Tags]	Functional	certificate	create	POST    Notcurrent
    Modify Certificate    Certificate/Modify_RegressionSchemeCertificate.json   ${Certificate_Id}
    run keyword if  '${Certificate_Id}' == '${Certificate_Id_Modify}'     Fail

20. Link Modified Product and Evaluation to Certificate
    [Tags]	Functional	certificate	create	POST    Notcurrent
#    set global variable	${Certificate_Id}	${Certificate_Id_Modify}
    Get Certificate Transaction Id  ${Certificate_Name}
    ${response}  Get ULAssetID   ${asset_Id_Product12}
    set global variable	${ul_asset_Id}  ${response}
    Link Product2 to Certificate  Certificate/Link_Product1_Eval1_RegressionCertificate_RevisionNo2.json

21. Certify certificate1
    [Tags]	Functional	certificate	create	POST    Notcurrent
#    set global variable  ${Certificate_Id}   ${Certificate_Id_Modify}
    run keyword and ignore error     Add Decisions to Certificate  Certificate/Certify_RegressionCertificatewithWDpriortoTodaysdate_AfterModify.json  ${Certificate_Id_Modify}
    ${response}  Get Error Message  ${response_api}
    log to console  ${response}

#22. Validate Certificate Status
#    [Tags]	Functional	certificate	create	Notcurrent
#    ${response1}  Get certificate status with certificateId   ${Certificate_Id_Modify}
#    log to console  ${response1}
#    run keyword if	${response1} != "Withdrawn"	Fail	test1 Teardown
#
#23. Validate Private Label Status
#    [Tags]	Functional	certificate PL	create	Notcurrent
#    ${response}  Get Private Label status   ${PrivateLabel_Id}
#    log to console  ${response}
#    run keyword if	${response} != "Withdrawn"	Fail	test1 Teardown