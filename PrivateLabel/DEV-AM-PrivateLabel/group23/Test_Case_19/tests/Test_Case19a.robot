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

8. Certificate1 Creation
	[Tags]	Functional	certificate	create	POST    current
    create certificate   Certificate/CreationOfRegressionSchemeCertificate.json

9. Link Product to Certificate1
    [Tags]	Functional	certificate	create	POST    current
    ${Trans_Id1}     Get Certificate TransactionId using Certificate Details  ${Certificate_Name}    ${Cert_Owner_Ref}  ${scheme}
    set global variable	${Cert_Transaction_Id}	${Trans_Id1}
    log to console	"Transaction ID": ${Cert_Transaction_Id}
    ${response}  Get ULAssetID   ${asset_Id_Product1}
    set global variable	${ul_asset_Id}	${response}
    Add Assets to Certificate  Certificate/Link_Product1_Eval1_RegressionCertificate.json    ${Certificate_Id}

10. Associate parties to certificate1
    [Tags]	Functional	certificate	create	POST    current
    ${has_assets}    Get HasAssets using Certificate Details   Regression%20Scheme   ${Certificate_Name}    ${Cert_Owner_Ref}   ${Certificate_Id}
    Should not be Empty     ${has_assets}
    ${has_evaluations}    Get HasEvaluations using Certificate Details   Regression%20Scheme   ${Certificate_Name}    ${Cert_Owner_Ref}   ${Certificate_Id}
    Should not be Empty     ${has_evaluations}
    Add Parties to Certificate  Certificate/Associate_Parties_With2Product_Certificate.json  ${Certificate_Id}

11. Certify certificate1
    [Tags]	Functional	certificate	create	POST    current
    Add Decisions to Certificate  Certificate/Certify_RegressionCertificate.json     ${Certificate_Id}

12. Create Private Label1
    [Tags]	Functional	certificate	PL  create	POST    current
    Create private label    Private_Label/CreationOfPrivateLabel_RegressionSchemeCertificate.json

13. Add Asset To Private Label1
    [Tags]	Functional	certificate	PL  POST    current
    ${response}  Add Asset To PL  Private_Label/Add_Asset_To_Private_Label.json
    set global variable  ${PrivateLabel_Asset_Id}   ${response}

14. View Private Label1 Asset
    [Tags]	Functional	certificate	PL  POST    current
    ${result}  View Private Label Assets    ${PrivateLabel_Asset_Id}
    run keyword if  '${result}' != '${PrivateLabel_Asset_Id}'     Fail   test1 Teardown
    log to console  Private Lable Asset ID: ${result}

15. Add Party To Private Label1
    [Tags]	Functional	certificate	PL  POST    current
    Add Party To PL  Private_Label/Add_Parties_To_Private_Label.json

16. Certify Private Label1
    [Tags]	Functional	certificate	PL  POST    current
    Certify Private Label  Private_Label/Certify_PrivateLabelCertificate.json

17. Modify Asset1 Attribute
    [Tags]	Functional	asset	create	POST    current
    Modify Product1 Asset   ModifyAttRegressionProduct1_siscase1_withDiffColName.json    ${asset_Id_Product1}

18. Check for Asset State for modified Asset
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product12}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_Asset_State": ${state}

19. Get the Colletion_ID for modified Asset
    [Tags]	Functional	current
    Get Collection_ID   ${asset_Id_Product12}
    set global variable  ${product12_collection_id}   ${collection_id}

20. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productnoevalreqd.json	${asset_Id_Product12}

21. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product12}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

22. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	set global variable	${assessmentId1}	${assessmentId}
	${response}  Get AssesmentID	${asset_Id_Product12}
	set global variable	${assessmentId}     ${response}

23. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product12}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product12}

24. Modify base Certificate1
	[Tags]	Functional	certificate	create	POST    current
    Modify Certificate    Certificate/Modify_RegressionSchemeCertificate.json   ${Certificate_Id}
    run keyword if  '${Certificate_Id}' == '${Certificate_Id_Modify}'     Fail

25. Link Modified Product and Evaluation to Certificate
    [Tags]	Functional	certificate	create	POST    current
    ${Trans_Id1}     Get Certificate TransactionId using Certificate Details     ${Certificate_Name_Modify}  ${Cert_Owner_Ref_Modify}  ${scheme}
    set global variable	${Cert_Transaction_Id}	${Trans_Id1}
    log to console	"Transaction ID": ${Cert_Transaction_Id}
    ${response}  Get ULAssetID   ${asset_Id_Product12}
    set global variable	${ul_asset_Id}  ${response}
    Add Assets to Certificate  Certificate/Link_Product1_Eval1_RegressionCertificate_RevisionNo2.json    ${Certificate_Id_Modify}

26. Certify certificate1
    [Tags]	Functional	certificate	create	POST    current
#    set global variable  ${Certificate_Id}   ${Certificate_Id_Modify}
    Add Decisions to Certificate  Certificate/Certify_RegressionCertificatewithWDpriortoTodaysdate_AfterModify.json  ${Certificate_Id_Modify}

27. Validate Certificate Status
    [Tags]	Functional	certificate	create	current
    ${response1}  Get certificate status with certificateId   ${Certificate_Id_Modify}
    log to console  ${response1}
    run keyword if	${response1} != "Withdrawn"	Fail	test1 Teardown

28. Validate Private Label Status
    [Tags]	Functional	certificate PL	create	current
    ${response}  Get Private Label status   ${PrivateLabel_Id}
    log to console  ${response}
    run keyword if	${response} != "Withdrawn"	Fail	test1 Teardown

34. Modify base Certificate1 for version3
	[Tags]	Functional	certificate	create	POST    current
    Modify Certificate for Version3    Certificate/Modify_RegressionSchemeCertificate_Revision2.json   ${Certificate_Id_Modify}
    run keyword if  '${Certificate_Id_Modify}' == '${Certificate_Id_Modify2}'     Fail

35. Reinstate certificate1
    [Tags]	Functional	certificate	create	POST    current
    Add Decisions to Certificate  Certificate/Certify_RegressionCertificate_AfterModify2.json    ${Certificate_Id_Modify2}

36. Validate Certificate Status
    [Tags]	Functional	certificate	create	current
    ${response1}  Get certificate status with certificateId   ${Certificate_Id}
    log to console  ${response1}
    run keyword if	${response1} != "Active"	Fail	test1 Teardown
    ${response2}  Get certificate status with certificateId   ${Certificate_Id_Modify}
    log to console  ${response2}
    run keyword if	${response2} != "Withdrawn"	Fail	test1 Teardown
    ${response3}  Get certificate status with certificateId   ${Certificate_Id_Modify2}
    log to console  ${response3}
    run keyword if	${response3} != "Active"	Fail	test1 Teardown

37. Validate Private Label Status
    [Tags]	Functional	certificate PL	create	current
    ${response}  Get Private Label status   ${PrivateLabel_Id}
    log to console  ${response}
    run keyword if	${response} != "Withdrawn"	Fail	test1 Teardown