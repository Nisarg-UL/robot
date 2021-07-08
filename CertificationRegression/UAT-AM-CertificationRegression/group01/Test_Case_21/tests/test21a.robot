*** Settings ***
Documentation	Certification Regression TestSuite
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
    set global variable     ${Product_Collection_Id}    ${Collection_Id}

4. Asset2 Creation with POST Request
    [Tags]	Functional	asset	create	POST    current
    create Asset2 based on product1 Asset1   CreationOfRegressionProduct1Asset2_siscase1_withCol_ID.json

5. Check for Asset State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product12}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Component_Asset_State": ${state}

6. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productevaluationsetup.json	${asset_Id_Product1}
	standard assignment	productevaluationsetup.json	${asset_Id_Product12}

7. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}
	${state}=	Get Asset State	${asset_Id_Product12}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

8. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${response}  Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId1}	${response}

9. Requirement Assignment To Product
	[Tags]	Functional	POST	current
	Save Requirement	saverequirement_group1_01.json	${asset_Id_Product1}

10. Get Assessment_ParamId
	[Tags]	Functional	GET	current
	Get Assesment_ParamID	${asset_Id_Product1}

11. Render Verdict
	[Tags]	Functional	POST	current
	${response1}	Render Verdict  group01/Test_Case_15/inputrequest/request1.json	${asset_Id_Product1}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${response2}	Render Verdict	group01/Test_Case_15/inputrequest/request2.json	${asset_Id_Product1}
	run keyword if	${response2.status_code} != 200	Fail	test1 Teardown
	${response3}	Render Verdict	group01/Test_Case_15/inputrequest/request3.json	${asset_Id_Product1}
	run keyword if	${response3.status_code} != 200	Fail	test1 Teardown
	${clause}   has more clauses  ${response3.text}
    run keyword if  '${clause}' != 'False'  Fail	test1 Teardown

12. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	${result}	Evaluation Summary	${asset_Id_Product1}
	run keyword if	'${result}' != '1 : PASS : Clause Group = a'	Fail	test1 Teardown
	log to console	Result - ${result} (Implicit)

13. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${response}  Get AssesmentID	${asset_Id_Product12}
	set global variable	${assessmentId2}	${assessmentId}

14. Requirement Assignment To Product
	[Tags]	Functional	POST	current
	Save Requirement	saverequirement_group1_01.json	${asset_Id_Product12}

15. Get Assessment_ParamId
	[Tags]	Functional	GET	current
	Get Assesment_ParamID	${asset_Id_Product12}

16. Render Verdict
	[Tags]	Functional	POST	current
	${response1}	Render Verdict  group01/Test_Case_15/inputrequest/request1.json	${asset_Id_Product12}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${response2}	Render Verdict	group01/Test_Case_15/inputrequest/request2.json	${asset_Id_Product12}
	run keyword if	${response2.status_code} != 200	Fail	test1 Teardown
	${response3}	Render Verdict	group01/Test_Case_15/inputrequest/request3.json	${asset_Id_Product12}
	run keyword if	${response3.status_code} != 200	Fail	test1 Teardown
	${clause}   has more clauses  ${response3.text}
    run keyword if  '${clause}' != 'False'  fatal error

17. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product12}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product12}
	${result}	Evaluation Summary	${asset_Id_Product12}
	run keyword if	'${result}' != '1 : PASS : Clause Group = a'	Fail	test1 Teardown
	log to console	Result - ${result} (Implicit)

18. Modify Regression Product 2 by Selecting As Template
	[Tags]	Functional	asset2	create	POST    current
    Modify Product1 Asset  SelectAsTemplateRegressionProduct1_siscase1.json     ${asset_Id_Product12}

19. Check Asset State After Modify
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1_2}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product1_State after Modify": ${state}

20. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
    standard assignment	productevaluationsetup.json	${asset_Id_Product1_2}

21. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${response}  Get AssesmentID	${asset_Id_Product1_2}
	set global variable	${assessmentId}	${response}
	set global variable	${assessmentId2_modified}	${assessmentId}

22. Requirement Assignment To Product
	[Tags]	Functional	POST	current
	Save Requirement	saverequirement_group1_01.json	${asset_Id_Product1_2}

23. Get Assessment_ParamId
	[Tags]	Functional	GET	current
	Get Assesment_ParamID	${asset_Id_Product1_2}

24. Render Verdict
	[Tags]	Functional	POST	current
	${response1}	Render Verdict  group01/Test_Case_15/inputrequest/request1.json	${asset_Id_Product1_2}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${response2}	Render Verdict	group01/Test_Case_15/inputrequest/request2.json	${asset_Id_Product1_2}
	run keyword if	${response2.status_code} != 200	Fail	test1 Teardown
	${response3}	Render Verdict	group01/Test_Case_15/inputrequest/request3.json	${asset_Id_Product1_2}
	run keyword if	${response3.status_code} != 200	Fail	test1 Teardown
	${clause}   has more clauses  ${response3.text}
    run keyword if  '${clause}' != 'False'  fatal error

25. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1_2}
	${result}	Evaluation Summary	${asset_Id_Product1_2}
	run keyword if	'${result}' != '1 : PASS : Clause Group = a'	Fail	test1 Teardown
	log to console	Result - ${result} (Implicit)

26. Certificate creation
	[Tags]	Functional	certificate	create	POST    current
    create certificate   Certificate/CreationOfRegressionSchemeCertificate.json

27. Link Product and Evaluation to Certificate
    [Tags]	Functional	certificate	create	POST    current
    Get Certificate Transaction Id  ${Certificate_Name}
    ${response}  Get ULAssetID   ${asset_Id_Product1}
    set global variable	${ul_asset_Id}	${response}
    ${response}  Get ULAssetID   ${asset_Id_Product1_2}
    set global variable	${ul_asset_Id_2}	${response}
    Link Product to Certificate  Certificate/Link_Product1_&_Product2-version2_Certificate.json

28. Associate parties to certificate
    [Tags]	Functional	certificate POST    current
    associate parties to certificate    Certificate/Associate_Parties_RegressionCertificate.json

29. Unlink Product and Evaluation to Certificate
    [Tags]	Functional	certificate	create	POST    current
    Get TransactionId_2  ${scheme}  ${Certificate_Name}
    Get CertificateId_2  ${scheme}  ${Certificate_Name}
    Link Product to Certificate  Unlink_Product&Evaluation_Product1_&_Product2-version2.json