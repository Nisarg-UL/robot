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

2. Check for Asset State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_Asset_State": ${state}

3. Get the Colletion_ID
    [Tags]	Functional	current
    Get Collection_ID   ${asset_Id_Product1}
    set global variable  ${product_collection_id}   ${collection_id}

4. Validate above Asset's part of same collection
    [Tags]	Functional	GET    current
    ${response}  Get Collection Asset Link  ${Collection_Id}
    run keyword if  ${response} != (('${asset_Id_Product1}',), )    Fail	test1 Teardown

5. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productevaluationsetup.json	${asset_Id_Product1}

6. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

7. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${response}  Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId}     ${response}
	set global variable	${assessmentId1}	${assessmentId}

8. Requirement Assignment To Product
	[Tags]	Functional	POST	current
	Save Requirement	saverequirement_group1_01.json	${asset_Id_Product1}

9. Get Assessment_ParamId
	[Tags]	Functional	GET	current
	Get Assesment_ParamID	${asset_Id_Product1}

10. Render Verdict
	[Tags]	Functional	POST	current
	${response1}	Render Verdict  group20/Test_Case_01/inputrequest/request1.json	${asset_Id_Product1}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${response2}	Render Verdict	group20/Test_Case_01/inputrequest/request2.json	${asset_Id_Product1}
	run keyword if	${response2.status_code} != 200	Fail	test1 Teardown
	${response3}	Render Verdict	group20/Test_Case_01/inputrequest/request3.json	${asset_Id_Product1}
	run keyword if	${response3.status_code} != 200	Fail	test1 Teardown
	${clause}   has more clauses  ${response3.text}
    run keyword if  '${clause}' != 'False'  fatal error

11. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}
	${result}	Evaluation Summary	${asset_Id_Product1}
	run keyword if	'${result}' != '1 : PASS : Clause Group = a'	Fail	test1 Teardown
	log to console	Result - ${result} (Implicit)

12. Certificate creation
	[Tags]	Functional	certificate	create	POST    current
    create certificate   Certificate/CreationOfRegressionSchemeCertificate.json

13. Link Product and Evaluation to Certificate
    [Tags]	Functional	certificate	create	POST    current
    Get Certificate Transaction Id  ${Certificate_Name}
    ${response}  Get ULAssetID   ${asset_Id_Product1}
    set global variable	${ul_asset_Id}  ${response}
    Link Product to Certificate  Certificate/Link_Product1_Eval1_RegressionCertificate.json

14. Associate parties to certificate
    [Tags]	Functional	certificate	create	POST    current
    Get HasAssets   Regression%20Scheme   ${Certificate_Name}
    Get HasEvaluations  Regression%20Scheme   ${Certificate_Name}
    associate parties to certificate    Certificate/Associate_Parties_RegressionCertificate.json

15. Certify certificate
    [Tags]	Functional	certificate	create	POST    current
    Certify Certificate  Certificate/Certify_RegressionCertificate.json

16. Validate Certificate Status
    [Tags]	Functional	certificate	create	current
    ${response}  Get certificate status
    log to console  ${response}
    run keyword if	${response} != "Active"	Fail	test1 Teardown

17. Create Private Label
    [Tags]	Functional	certificate	PL  create	POST    current
    Create private label    Private_Label/CreationOfPrivateLabel_RegressionSchemeCertificate.json
    should not be empty  ${PrivateLabel_Id}
    log to console  ${PrivateLabel_Id}

18. Add Asset To Private Label
    [Tags]	Functional	certificate	PL  POST    current
    ${response}  Add Asset To PL  Private_Label/Add_Asset_To_Private_Label.json
    set global variable  ${PrivateLabel_Asset_Id}   ${response}

19. Get Private Label Details for a Base Certificate
    [Tags]	Functional	certificate	PL  create	POST    current
    ${result}  Get Private Label Details of a base Certificate  ${Certificate_Name}  Regression%20Scheme    ${Cert_Owner_Ref}
    run keyword if  '${result}' != '${PrivateLabel_Id}'     Fail   test1 Teardown
    log to console  Private Label ID: ${result}

20. View Private Label Asset
    [Tags]	Functional	certificate	PL  POST    current
    ${result}  View Private Label Assets    ${PrivateLabel_Asset_Id}
    run keyword if  '${result}' != '${PrivateLabel_Asset_Id}'     Fail   test1 Teardown
    log to console  Private Lable Asset ID: ${result}

21. Add Party To Private Label
    [Tags]	Functional	certificate	PL  POST    current
    Add Party To PL  Private_Label/Add_Parties_To_Private_Label.json

22. Certify Private Label
    [Tags]	Functional	certificate	PL  POST    current
    Certify Private Label  Private_Label/Certify_PrivateLabelCertificate.json

23. Validate Private Label Status
    [Tags]	Functional	certificate PL	create	current
    ${response}  Get Private Label status   ${PrivateLabel_Id}
    log to console  ${response}
    run keyword if	${response} != "Active"	Fail	test1 Teardown

24. Modify Asset1 Attribute
    [Tags]	Functional	asset	create	POST    current
    Modify Product1 Asset   ModifyAttRegressionProduct1_siscase1_withDiffColName.json    ${asset_Id_Product1}

25. Check for Asset State for modified Asset
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product12}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_Asset_State": ${state}

26. Get the Colletion_ID for modified Asset
    [Tags]	Functional	current
    Get Collection_ID   ${asset_Id_Product12}
    set global variable  ${product12_collection_id}   ${collection_id}

27. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productevaluationsetup.json	${asset_Id_Product12}

28. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product12}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

29. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	set global variable	${assessmentId1}	${assessmentId}
	${response}  Get AssesmentID	${asset_Id_Product12}
	set global variable	${assessmentId}     ${response}

30. Requirement Assignment To Product
	[Tags]	Functional	POST	current
	Save Requirement	saverequirement_group1_01.json	${asset_Id_Product12}

31. Get Assessment_ParamId
	[Tags]	Functional	GET	current
	Get Assesment_ParamID	${asset_Id_Product12}

32. Render Verdict
	[Tags]	Functional	POST	current
	${response1}	Render Verdict  group20/Test_Case_01/inputrequest/request1.json	${asset_Id_Product12}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${response2}	Render Verdict	group20/Test_Case_01/inputrequest/request2.json	${asset_Id_Product12}
	run keyword if	${response2.status_code} != 200	Fail	test1 Teardown
	${response3}	Render Verdict	group20/Test_Case_01/inputrequest/request3.json	${asset_Id_Product12}
	run keyword if	${response3.status_code} != 200	Fail	test1 Teardown
	${clause}   has more clauses  ${response3.text}
    run keyword if  '${clause}' != 'False'  fatal error

33. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product12}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product12}
	${result}	Evaluation Summary	${asset_Id_Product12}
	run keyword if	'${result}' != '1 : PASS : Clause Group = a'	Fail	test1 Teardown
	log to console	Result - ${result} (Implicit)

34. Modify base Certificate
	[Tags]	Functional	certificate	create	POST    current
    Modify Certificate    Certificate/Modify_RegressionSchemeCertificate.json   ${Certificate_Id}
    run keyword if  '${Certificate_Id}' == '${Certificate_Id_Modify}'     Fail

35. Link Modified Product and Evaluation to Certificate
    [Tags]	Functional	certificate	create	POST    current
    set global variable	${Certificate_Id}	${Certificate_Id_Modify}
    Get Certificate Transaction Id  ${Certificate_Name}
    ${response}  Get ULAssetID   ${asset_Id_Product12}
    set global variable	${ul_asset_Id}  ${response}
    Link Product2 to Certificate  Certificate/Link_Product1_Eval1_RegressionCertificate_RevisionNo2.json

36. Certify certificate
    [Tags]	Functional	certificate	create	POST    current
    set global variable  ${Certificate_Id}   ${Certificate_Id_Modify}
    Certify Certificate  Certificate/Certify_RegressionCertificate_RevisionNo3.json

37. Validate Certificate Status
    [Tags]	Functional	certificate	create	current
    ${response}  Get certificate status
    log to console  ${response}
    run keyword if	${response} != "Active"	Fail	test1 Teardown

38. View Private Label Assets of a modified base asset
    [Tags]	Functional	certificate	PL  POST    current
    ${response}  View Private Label Assets of a base Asset_one_asset_Id    ${asset_Id_Product1}
    run keyword if  '${response}' != '${PrivateLabel_Asset_Id}'  Fail	test1 Teardown
    set global variable  ${PrivateLabel_Asset_Id1}  ${response}

39. Get Private Label Impact Details for a Base Certificate
    [Tags]	Functional	certificate	PL  create	POST    current
    ${result}  Get Private Label Impact Details of a base Certificate    certificateName=${Certificate_Name}&&certificateType=Regression%20Scheme&&ownerReference=${cert_owner_ref}
    run keyword if  '${result}' != 'Y'     Fail   test1 Teardown

40. Unlink Impacted Asset from Private Label and Link the latest asset to Private Label
	[Tags]	Functional	POST	current
    ${result}  Update Impacted model for Private Label   Unlink_Asset_Template.json   ${PrivateLabel_Asset_Id1}

41. Get Private Label Impact Details for a Base Certificate
    [Tags]	Functional	certificate	PL  create	POST    current
    ${result}  Get Private Label Impact Details of a base Certificate    certificateName=${Certificate_Name}&&certificateType=Regression%20Scheme&&ownerReference=${cert_owner_ref}
    run keyword if  '${result}' != 'N'     Fail   test1 Teardown