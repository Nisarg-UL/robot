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

2. Check for Asset State
	[Tags]	Functional	Notcurrent
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_Asset_State": ${state}

3. Get the Colletion_ID
    [Tags]	Functional	Notcurrent
    Get Collection_ID   ${asset_Id_Product1}
    set global variable     ${Product_Collection_Id}    ${Collection_Id}

4. Asset2 Creation with POST Request
    [Tags]	Functional	asset	create	POST    Notcurrent
    create Asset2 based on product1 Asset1   CreationOfRegressionProduct1Asset2_siscase1_withCol_ID.json

5. Check for Asset State
	[Tags]	Functional	Notcurrent
	${state}=	Get Asset State	${asset_Id_Product12}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Component_Asset_State": ${state}

6. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	Notcurrent
	standard assignment	productevaluationsetup.json	${asset_Id_Product1}
	standard assignment	productevaluationsetup.json	${asset_Id_Product12}

7. Check Asset State After Associating Standard to Product
	[Tags]	Functional	Notcurrent
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}
	${state}=	Get Asset State	${asset_Id_Product12}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

8. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	Notcurrent
	${response}  Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId1}	${response}

10. Requirement Assignment To Product
	[Tags]	Functional	POST	Notcurrent
	Save Requirement	saverequirement_group1_01.json	${asset_Id_Product1}

11. Get Assessment_ParamId
	[Tags]	Functional	GET	Notcurrent
	Get Assesment_ParamID	${asset_Id_Product1}

12. Render Verdict
	[Tags]	Functional	POST	Notcurrent
	${response1}	Render Verdict  group02/Test_Case_10/inputrequest/request1.json	${asset_Id_Product1}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${response2}	Render Verdict	group02/Test_Case_10/inputrequest/request2.json	${asset_Id_Product1}
	run keyword if	${response2.status_code} != 200	Fail	test1 Teardown
	${response3}	Render Verdict	group02/Test_Case_10/inputrequest/request3.json	${asset_Id_Product1}
	run keyword if	${response3.status_code} != 200	Fail	test1 Teardown
	${clause}   has more clauses  ${response3.text}
    run keyword if  '${clause}' != 'False'  Fail	test1 Teardown

13. Complete Evaluation
	[Tags]	Functional	POST	Notcurrent
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	${result}	Evaluation Summary	${asset_Id_Product1}
	run keyword if	'${result}' != '1 : PASS : Clause Group = a'	Fail	test1 Teardown
	log to console	Result - ${result} (Implicit)

14. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	Notcurrent
	${response}  Get AssesmentID	${asset_Id_Product12}
	set global variable	${assessmentId2}	${assessmentId}

15. Requirement Assignment To Product
	[Tags]	Functional	POST	Notcurrent
	Save Requirement	saverequirement_group1_01.json	${asset_Id_Product12}

16. Get Assessment_ParamId
	[Tags]	Functional	GET	Notcurrent
	Get Assesment_ParamID	${asset_Id_Product12}

17. Render Verdict
	[Tags]	Functional	POST	Notcurrent
	${response1}	Render Verdict  group02/Test_Case_10/inputrequest/request1.json	${asset_Id_Product12}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${response2}	Render Verdict	group02/Test_Case_10/inputrequest/request2.json	${asset_Id_Product12}
	run keyword if	${response2.status_code} != 200	Fail	test1 Teardown
	${response3}	Render Verdict	group02/Test_Case_10/inputrequest/request3.json	${asset_Id_Product12}
	run keyword if	${response3.status_code} != 200	Fail	test1 Teardown
	${clause}   has more clauses  ${response3.text}
    run keyword if  '${clause}' != 'False'  fatal error

16. Complete Evaluation
	[Tags]	Functional	POST	Notcurrent
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product12}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product12}
	${result}	Evaluation Summary	${asset_Id_Product12}
	run keyword if	'${result}' != '1 : PASS : Clause Group = a'	Fail	test1 Teardown
	log to console	Result - ${result} (Implicit)

17. Certificate creation
	[Tags]	Functional	certificate	create	POST    Notcurrent
    create certificate   Certificate/CreationOfRegressionSchemeCertificate.json

18. Link Product and Evaluation to Certificate
    [Tags]	Functional	certificate	create	POST    Notcurrent
    Get Certificate Transaction Id  ${Certificate_Name}
    ${response}  Get ULAssetID   ${asset_Id_Product1}
    set global variable	${ul_asset_Id}	${response}
    ${response}  Get ULAssetID   ${asset_Id_Product12}
    set global variable	${ul_asset_Id_2}	${response}
    Link Product to Certificate  Link_Product1_&_Product2_Certificate.json

19. Associate parties to certificate
    [Tags]	Functional	certificate	create	POST    Notcurrent
    Get HasAssets   Regression%20Scheme   ${Certificate_Name}
    Get HasEvaluations  Regression%20Scheme   ${Certificate_Name}
    Get HasAssets_2   Regression%20Scheme   ${Certificate_Name}
    Get HasEvaluations_2  Regression%20Scheme   ${Certificate_Name}
    Get TransactionId_2   Regression%20Scheme   ${Certificate_Name}
    Get CertificateId_2   Regression%20Scheme   ${Certificate_Name}
    associate parties to certificate  Associate_Parties_With2Product_Certificate.json

20. Certify certificate
    [Tags]	Functional	certificate	create	POST    Notcurrent
    Certify Certificate  Certify_RegressionCertificate.json

21. Create Private Label
    [Tags]	Functional	certificate	PL  create	POST    Notcurrent
    Create private label    Private_Label/CreationOfPrivateLabel_RegressionSchemeCertificate.json

22. Add Asset To Private Label
    [Tags]	Functional	certificate	PL  create	POST    current1
    Add Asset To PL  Private_Label/Add_Asset_To_Private_Label.json
    Add Asset To PL  Private_Label/Add_Second_Asset_To_Private_Label_With_Same_Taxonomy.json