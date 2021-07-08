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

1. End Date CET_V1
	[Tags]	Functional	POST	current
	Expire CET   ${certificate_hierarchy_Id}

2. Post Date CET_V2.2
	[Tags]	Functional	POST	current
	Activate CET   ${certificate_hierarchy_IdV2.2}

3. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    create product1 asset	CreationOfRegressionProduct1_siscase1.json

4. Check for Asset State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_Asset_State": ${state}

5. Get the Colletion_ID
    [Tags]	Functional	current
    Get Collection_ID   ${asset_Id_Product1}
    set global variable  ${product_collection_id}   ${collection_id}

6. Validate above Asset's part of same collection
    [Tags]	Functional	GET    current
    ${response}  Get Collection Asset Link  ${Collection_Id}
    run keyword if  ${response} != (('${asset_Id_Product1}',), )    Fail	test1 Teardown

7. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productevaluationsetup.json	${asset_Id_Product1}

8. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

9. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${response}  Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId}     ${response}
	set global variable	${assessmentId1}	${assessmentId}

10. Requirement Assignment To Product
	[Tags]	Functional	POST	current
	Save Requirement	saverequirement_group1_01.json	${asset_Id_Product1}

11. Get Assessment_ParamId
	[Tags]	Functional	GET	current
	Get Assesment_ParamID	${asset_Id_Product1}

12. Render Verdict
	[Tags]	Functional	POST	current
	${response1}	Render Verdict  group22/Test_Case_01/inputrequest/request1.json	${asset_Id_Product1}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${response2}	Render Verdict	group22/Test_Case_01/inputrequest/request2.json	${asset_Id_Product1}
	run keyword if	${response2.status_code} != 200	Fail	test1 Teardown
	${response3}	Render Verdict	group22/Test_Case_01/inputrequest/request3.json	${asset_Id_Product1}
	run keyword if	${response3.status_code} != 200	Fail	test1 Teardown
	${clause}   has more clauses  ${response3.text}
    run keyword if  '${clause}' != 'False'  fatal error

13. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}
	${result}	Evaluation Summary	${asset_Id_Product1}
	run keyword if	'${result}' != '1 : PASS : Clause Group = a'	Fail	test1 Teardown
	log to console	Result - ${result} (Implicit)

14. Certificate creation
	[Tags]	Functional	certificate	create	POST    current
    create certificate   Certificate/CreationOfRegressionSchemeCertificate.json

15. Link Product and Evaluation to Certificate
    [Tags]	Functional	certificate	create	POST    current
    Get Certificate Transaction Id  ${Certificate_Name}
    ${response}  Get ULAssetID   ${asset_Id_Product1}
    set global variable	${ul_asset_Id}  ${response}
    Link Product to Certificate  Certificate/Link_Product1_Eval1_RegressionCertificate.json

16. Associate parties to certificate
    [Tags]	Functional	certificate	create	POST    current
    Get HasAssets   Regression%20Scheme   ${Certificate_Name}
    Get HasEvaluations  Regression%20Scheme   ${Certificate_Name}
    associate parties to certificate    Certificate/Associate_Parties_Owner_Applicant_Reference_RegressionCertificate.json

17. Certify certificate
    [Tags]	Functional	certificate	create	POST    current
    Certify Certificate  Certificate/Certify_RegressionCertificate.json

18. Validate Certificate Status
    [Tags]	Functional	certificate	create	current
    ${response}  Get certificate status
    log to console  ${response}
    run keyword if	${response} != "Active"	Fail	test1 Teardown

19. Create Private Label
    [Tags]	Functional	certificate	PL  create	POST    current
    Create private label    Private_Label/CreationOfPrivateLabel_RegressionSchemeCertificate.json
    should not be empty  ${PrivateLabel_Id}
    log to console  ${PrivateLabel_Id}

20. Get Private Label certificate status
    [Tags]	Functional	PL	current
    ${response}  Get Private Label status   ${PrivateLabel_Id}
    log to console  ${response}
    run keyword if	${response} != "Under Revision"	Fail	test1 Teardown

21. Get Private Label details from Private Label Table
    [Tags]	Functional	certificate	PL  create	POST    current
    Get PrivateLabelId from Private Label Table     ${Certificate_Id}
    run keyword if  '${PrivateLabel_Id}' != '${pl_Id}'     Fail
    Get Unique PrivateLabelId from Private Label Table   ${pl_Id}
    run keyword if  '${Unique_PrivateLabel_Id}' != '${pl_Id}'     Fail
    Get Private Label Version from Private Label Table   ${Unique_PrivateLabel_Id}
    run keyword if  '${PrivateLabel_Ver}' != '1.0'     Fail

22. Add Asset To Private Label
    [Tags]	Functional	certificate	PL  POST    current
    ${response}  Add Asset To PL  Private_Label/Add_Asset_To_Private_Label.json
    set global variable  ${PrivateLabel_Asset_Id}   ${response}

23. Add Party To Private Label
    [Tags]	Functional	certificate	PL  POST    current
    Add Parties To Private Label  Private_Label/Associate_Parties_Owner_Applicant_Reference_RegressionCertificate.json  ${PrivateLabel_Id}

24. Certify Private Label
    [Tags]	Functional	certificate	PL  POST    current
    Certify Private Label  Private_Label/Certify_PrivateLabelCertificate.json

25. Get Private Label certificate status
    [Tags]	Functional	PL	current
    ${response}  Get Private Label status   ${PrivateLabel_Id}
    log to console  ${response}
    run keyword if	${response} != "Active"	Fail	test1 Teardown

26. End Date CET_V2.2
	[Tags]	Functional	POST	current
	Expire CET   ${certificate_hierarchy_IdV2.2}

27. Post Date CET_V1
	[Tags]	Functional	POST	current
	Activate CET     ${certificate_hierarchy_Id}

28. Modify Private Label
    [Tags]	Functional	certificate	PL  POST    current
    Modify Private Lable    Private_Label/Modify_PrivateLabelCertificate.json   ${PrivateLabel_Id}
    run keyword if  '${PrivateLabel_Id}' == '${PrivateLabel_Id_Modify}'     Fail

29. Certify Private Label
    [Tags]	Functional	certificate	PL  POST    current
    ${response}     run keyword and ignore error    Certify Private Label  Private_Label/Certify_PrivateLabelCertificate_Version2.json
    ${msg}  Get Error Message  ${response_api}
	run keyword if  "${msg}" != " Error: Required information is missing from the Parties tab. Please add mandatory role(s) - localRepresentative, productionSite. "  Fail	test1 Teardown
	log to console  ${msg}