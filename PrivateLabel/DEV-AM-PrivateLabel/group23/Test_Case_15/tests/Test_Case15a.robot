*** Settings ***
Documentation	Private Label TestSuite
Resource	../../../resource/ApiFunctions.robot
Suite Setup  Link RegSchemeScopeProd1 & Reg2SchemeScope2Prod1
Suite Teardown  Unlink RegSchemeScopeProd1 & Reg2SchemeScope2Prod2

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

2. Asset2 Creation with POST Request
    [Tags]	Functional	asset	create	POST    current
    Create Product1 Asset2   CreationOfRegressionProduct1Asset2_siscase1.json

3. Check Asset State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}
	${state}=	Get Asset State	${asset2_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

4. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productnoevalreqd.json	${asset_Id_Product1}
	standard assignment	productnoevalreqd.json	${asset2_Id_Product1}

5. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}
	${state}=	Get Asset State	${asset2_Id_Product1}
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

8. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${assessmentId2}  Get AssesmentID	${asset2_Id_Product1}
	set global variable	${assessmentId2}	${assessmentId2}

9. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset2_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset2_Id_Product1}

10. Check Asset State After Evaluation
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'immutable'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}
	${state}=	Get Asset State	${asset2_Id_Product1}
	run keyword if	'${state}' != 'immutable'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

11. Certificate1 Creation
	[Tags]	Functional	certificate	create	POST    current
    create certificate   Certificate/CreationOfRegression2SchemeCertificate.json

12. Link Product to Certificate1
    [Tags]	Functional	certificate	create	POST    current
    ${Trans_Id1}     Get Certificate TransactionId using Certificate Details  ${Certificate_Name}    ${Cert_Owner_Ref}  ${scheme}
    set global variable	${Cert_Transaction_Id}	${Trans_Id1}
    log to console	"Transaction ID": ${Cert_Transaction_Id}
    ${response}  Get ULAssetID   ${asset_Id_Product1}
    set global variable	${ul_asset_Id}	${response}
    Add Assets to Certificate  Certificate/Link_Product1_Eval1_Regression2Certificate.json    ${Certificate_Id}

13. Associate parties to certificate1
    [Tags]	Functional	certificate	create	POST    current
    ${has_assets}    Get HasAssets using Certificate Details   Regression2%20Scheme   Regression2-US001-1    ${Cert_Owner_Ref}   ${Certificate_Id}
    Should not be Empty     ${has_assets}
    ${has_evaluations}    Get HasEvaluations using Certificate Details   Regression2%20Scheme   Regression2-US001-1    ${Cert_Owner_Ref}   ${Certificate_Id}
    Should not be Empty     ${has_evaluations}
    Add Parties to Certificate  Certificate/Associate_Parties_RegressionCertificate.json  ${Certificate_Id}

14. Certify certificate1
    [Tags]	Functional	certificate	create	POST    current
    Add Decisions to Certificate  Certificate/Certify_Regression2Certificate.json     ${Certificate_Id}

15. Create Private Label1
    [Tags]	Functional	certificate	PL  create	POST    current
    Create private label    Private_Label/CreationOfPrivateLabel_Regression2SchemeCertificate.json

16. Add Asset To Private Label1
    [Tags]	Functional	certificate	PL  POST    current
    ${response}  Add Asset To PL  Private_Label/Add_Asset_To_Private_Label.json
    set global variable  ${PrivateLabel_Asset_Id}   ${response}

17. View Private Label1 Asset
    [Tags]	Functional	certificate	PL  POST    current
    ${result}  View Private Label Assets    ${PrivateLabel_Asset_Id}
    run keyword if  '${result}' != '${PrivateLabel_Asset_Id}'     Fail   test1 Teardown
    log to console  Private Lable Asset ID: ${result}

18. Add Party To Private Label1
    [Tags]	Functional	certificate	PL  POST    current
    Add Party To PL  Certificate/Associate_Parties_RegressionCertificate.json

19. Certify Private Label1
    [Tags]	Functional	certificate	PL  POST    current
    Certify Private Label  Private_Label/Certify_PrivateLabelCertificate.json

20. Certificate2 creation
	[Tags]	Functional	certificate	create	POST    current
    create certificate2   Certificate/CreationOfRegressionSchemeCertificate2.json

21. Link Product2 to Certificate2
    [Tags]	Functional	certificate	create	POST    current
    ${Trans_Id2}     Get Certificate TransactionId using Certificate Details  ${Certificate_Name2}    ${Cert_Owner_Ref2}  ${scheme}
    set global variable	${Cert2_Transaction_Id}	${Trans_Id2}
    log to console	"Transaction ID": ${Cert2_Transaction_Id}
    ${response}  Get ULAssetID   ${asset2_Id_Product1}
    set global variable	${ul_asset_Id_2}	${response}
    Add Assets to Certificate  Certificate/Link_Product1Asset2_RegressionCertificate.json     ${Certificate_Id2}

22. Associate parties to certificate2
    [Tags]	Functional	certificate	create	POST    current
    ${has_assets}    Get HasAssets using Certificate Details   Regression%20Scheme   Regression-US001-2    ${Cert_Owner_Ref2}   ${Certificate_Id2}
    Should not be Empty     ${has_assets}
    Add Parties to Certificate  Certificate/Associate_Parties_With2Product_Certificate.json  ${Certificate_Id2}

23. Certify certificate2
    [Tags]	Functional	certificate	create	POST    current
    Add Decisions to Certificate  Certificate/Certify_RegressionCertificate.json     ${Certificate_Id2}

24. Create Private Labe2
    [Tags]	Functional	certificate	PL  create	POST    current
    Create private label2    Private_Label/CreationOfPrivateLabel_RegressionSchemeCertificate2.json

25. Add Asset To Private Label2
    [Tags]	Functional	certificate	PL  POST    current
    ${response}  Add Asset To Private Label  Private_Label/Add_Asset_To_Private_Label2.json   ${PrivateLabel_Id2}
    set global variable  ${PrivateLabel_Asset_Id2}   ${response}

26. View Private Label2 Asset
    [Tags]	Functional	certificate	PL  POST    current
    ${result}  View Private Label Assets    ${PrivateLabel_Asset_Id2}
    run keyword if  '${result}' != '${PrivateLabel_Asset_Id2}'     Fail   test1 Teardown
    log to console  Private Lable Asset ID: ${result}

27. Add Party To Private Label2
    [Tags]	Functional	certificate	PL  POST    current
    Add Parties To Private Label  Private_Label/Add_Parties_To_Private_Label.json    ${PrivateLabel_Id2}

28. Certify Private Label2
    [Tags]	Functional	certificate	PL  POST    current
    Certify Private Label  Private_Label/Certify_PrivateLabelCertificate2.json

29. Modify base Certificate1
	[Tags]	Functional	certificate	create	POST    current
    Modify Certificate    Certificate/Modify_Regression2SchemeCertificate.json   ${Certificate_Id}
    run keyword if  '${Certificate_Id}' == '${Certificate_Id_Modify}'     Fail

30. Certify certificate1
    [Tags]	Functional	certificate	create	POST    current
    Add Decisions to Certificate  Certificate/Certify_RegressionCertificate_withdraw.json  ${Certificate_Id_Modify}

31. Modify base Certificate2
	[Tags]	Functional	certificate	create	POST    current
    Modify Certificate2    Certificate/Modify_RegressionSchemeCertificate2.json   ${Certificate_Id2}
    run keyword if  '${Certificate_Id2}' == '${Certificate2_Id_Modify}'     Fail

32. Certify certificate2
    [Tags]	Functional	certificate	create	POST    current
    Add Decisions to Certificate  Certificate/Certify_RegressionCertificate2_withdraw.json   ${Certificate2_Id_Modify}

33. Validate Certificate Status
    [Tags]	Functional	certificate	create	current
    ${response1}  Get certificate status with certificateId   ${Certificate_Id_Modify}
    log to console  ${response1}
    run keyword if	${response1} != "Withdrawn"	Fail	test1 Teardown
    ${response2}  Get certificate status with certificateId   ${Certificate2_Id_Modify}
    log to console  ${response2}
    run keyword if	${response2} != "Withdrawn"	Fail	test1 Teardown

34. Modify base Certificate1 for version3
	[Tags]	Functional	certificate	create	POST    current
    Modify Certificate for Version3    Certificate/Modify_Regression2SchemeCertificate_Revision2.json   ${Certificate_Id_Modify}
    run keyword if  '${Certificate_Id_Modify}' == '${Certificate_Id_Modify2}'     Fail

35. Reinstate certificate1
    [Tags]	Functional	certificate	create	POST    current
    Add Decisions to Certificate  Certificate/Certify_RegressionCertificate_AfterModify2.json    ${Certificate_Id_Modify2}

36. Modify base Certificate2 for version3
	[Tags]	Functional	certificate	create	POST    current
    Modify Certificate2 for Version3    Certificate/Modify_RegressionSchemeCertificate2_Revision2.json   ${Certificate2_Id_Modify}
    run keyword if  '${Certificate2_Id_Modify}' == '${Certificate2_Id_Modify2}'     Fail

37. Reinstate certificate2
    [Tags]	Functional	certificate	create	POST    current
    Add Decisions to Certificate  Certificate/Certify_RegressionCertificate_AfterModify2.json   ${Certificate2_Id_Modify2}

38. Validate Certificate Status
    [Tags]	Functional	certificate	create	current
    ${response1}  Get certificate status with certificateId   ${Certificate_Id}
    log to console  ${response1}
    run keyword if	${response1} != "Active"	Fail	test1 Teardown
    ${response2}  Get certificate status with certificateId   ${Certificate_Id2}
    log to console  ${response2}
    run keyword if	${response2} != "Active"	Fail	test1 Teardown
    ${response3}  Get certificate status with certificateId   ${Certificate_Id_Modify}
    log to console  ${response3}
    run keyword if	${response3} != "Withdrawn"	Fail	test1 Teardown
    ${response4}  Get certificate status with certificateId   ${Certificate2_Id_Modify}
    log to console  ${response4}
    run keyword if	${response4} != "Withdrawn"	Fail	test1 Teardown
    ${response5}  Get certificate status with certificateId   ${Certificate_Id_Modify2}
    log to console  ${response5}
    run keyword if	${response5} != "Active"	Fail	test1 Teardown
    ${response6}  Get certificate status with certificateId   ${Certificate2_Id_Modify2}
    log to console  ${response6}
    run keyword if	${response6} != "Active"	Fail	test1 Teardown

39. Validate Private Label Status
    [Tags]	Functional	certificate PL	create	current
    ${response}  Get Private Label status   ${PrivateLabel_Id}
    log to console  ${response}
    run keyword if	${response} != "Withdrawn"	Fail	test1 Teardown
    ${response1}  Get Private Label status   ${PrivateLabel_Id2}
    log to console  ${response1}
    run keyword if	${response1} != "Withdrawn"	Fail	test1 Teardown