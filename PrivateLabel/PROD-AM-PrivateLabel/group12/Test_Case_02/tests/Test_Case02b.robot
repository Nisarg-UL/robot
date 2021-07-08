*** Settings ***
Documentation	Private Label TestSuite
Resource	../../../resource/ApiFunctions.robot

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
	${response1}	Render Verdict  group12/Test_Case_02/inputrequest/request1.json	${asset_Id_Product1}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${response2}	Render Verdict	group12/Test_Case_02/inputrequest/request2.json	${asset_Id_Product1}
	run keyword if	${response2.status_code} != 200	Fail	test1 Teardown
	${response3}	Render Verdict	group12/Test_Case_02/inputrequest/request3.json	${asset_Id_Product1}
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
	${response1}	Render Verdict  group12/Test_Case_02/inputrequest/request1.json	${asset_Id_Product12}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${response2}	Render Verdict	group12/Test_Case_02/inputrequest/request2.json	${asset_Id_Product12}
	run keyword if	${response2.status_code} != 200	Fail	test1 Teardown
	${response3}	Render Verdict	group12/Test_Case_02/inputrequest/request3.json	${asset_Id_Product12}
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

18. Certificate creation
	[Tags]	Functional	certificate	create	POST    current
    create certificate   Certificate/CreationOfRegressionSchemeCertificate.json

19. Link Product and Evaluation to Certificate
    [Tags]	Functional	certificate	create	POST    current
    ${response}  Get ULAssetID   ${asset_Id_Product1}
    set global variable	${ul_asset_Id}	${response}
    ${response}  Get ULAssetID   ${asset_Id_Product12}
    set global variable	${ul_asset_Id_2}	${response}
    Link Product to Certificate  Certificate/Link_Product1_&_Product2_Certificate.json
    Get CertificateId_2   Regression%20Scheme   Regression-US001-1
    unlock certificate  Unlock_Template.json   ${Certificate_Id_2}

20. Associate parties to certificate
    [Tags]	Functional	certificate	create	POST    current
    Get HasAssets   Regression%20Scheme   Regression-US001-1
    Get HasEvaluations  Regression%20Scheme   Regression-US001-1
    Get HasAssets_2   Regression%20Scheme   Regression-US001-1
    Get HasEvaluations_2  Regression%20Scheme   Regression-US001-1
    Get TransactionId_2   Regression%20Scheme   Regression-US001-1
    Get CertificateId_2   Regression%20Scheme   Regression-US001-1
    associate parties to certificate  Certificate/Associate_Parties_With2Product_Certificate.json

21. Certify certificate
    [Tags]	Functional	certificate	create	POST    current
    Certify Certificate  Certificate/Certify_RegressionCertificate_with2assets.json

22. Create Private Label
    [Tags]	Functional	certificate	PL  create	POST    current
    Create private label    Private_Label/CreationOfPrivateLabel_RegressionSchemeCertificate.json

23. Add Assets To Private Label
    [Tags]	Functional	certificate	PL  create	POST    current
    Add Asset To PL  Private_Label/Add_Asset_To_Private_Label.json
    ${response}  Get Private Lable Asset ID   ${response_api}
    should not be empty  ${response}
    set global variable  ${PL_Asset_Id1}   ${response}
    log to console   Private Lable Asset_ID1: ${PL_Asset_Id1}
    Add Asset To PL  Private_Label/Add_Second_Asset_To_Private_Label.json
    ${response}  Get Private Lable Asset ID   ${response_api}
    should not be empty  ${response}
    set global variable  ${PL_Asset_Id2}   ${response}
    log to console   Private Lable Asset_ID2: ${PL_Asset_Id2}

24. Unlink Asset From Private Label
    [Tags]	Functional	certificate	PL	POST    current
    ${result}    run keyword and ignore error     Unlink Asset from Private Label     Unlink_Asset_Template.json  abcdef
    run keyword if  ${result} != (b'FAIL', '200 != 400')  Fail	test1 Teardown
