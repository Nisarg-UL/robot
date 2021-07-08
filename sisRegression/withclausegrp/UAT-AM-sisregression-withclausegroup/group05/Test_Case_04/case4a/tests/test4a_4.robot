*** Settings ***
Documentation	SIS Regression TestSuite
Resource	../../../../resource/ApiFunctions.robot

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

2. Asset Creation With POST Request
	[Tags]	Functional	asset2	create	POST    current
    create product2 asset	CreationOfRegressionProduct2_siscase1.json

3. Asset Creation With POST Request
	[Tags]	Functional	asset3	create	POST    current
    create product3 asset	CreationOfRegressionProduct3_siscase1.json

4. Check for Asset State
	[Tags]	Functional	Get current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product1_Asset_State": ${state}
	${state}=	Get Asset State	${asset_Id_Product2}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product2_Asset_State": ${state}
	${state}=	Get Asset State	${asset_Id_Product3}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product3_Asset_State": ${state}

5. Get the Colletion_ID
    [Tags]	Functional	current
    Get Collection_ID   ${asset_Id_Product2}
    set global variable     ${Product_Collection_Id}    ${Collection_Id}

6. Standard Assignment To Product2 (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productevaluationsetup.json	${asset_Id_Product2}

7. Check Product2 State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product2}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product2_State after Standard Assigned To Product": ${state}

8. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${result}   Get AssesmentID	${asset_Id_Product2}
	set global variable	${assessmentId2}    ${result}

9. Complete Evaluation for Product2
    [Tags]	Functional	POST	current
    Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product2}
    Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product2}

10. Check Product2 State After Complete Evaluation
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product2}
	run keyword if	'${state}' != 'immutable'	Fail	test1a Teardown
	log to console	"Product2_State after Complete Evaluation": ${state}

11. Standard Assignment To Product3 (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productevaluationsetup.json	${asset_Id_Product3}

12. Check Product3 State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product3}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product3_State after Standard Assigned To Product": ${state}

13. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${result}   Get AssesmentID	${asset_Id_Product3}
    set global variable	${assessmentId3}    ${result}

14. Complete Evaluation for Product3
    [Tags]	Functional	POST	current
    Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product3}
    Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product3}

15. Check Product3 State After Complete Evaluation
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product3}
	run keyword if	'${state}' != 'immutable'	Fail	test1a Teardown
	log to console	"Product3_State after Complete Evaluation": ${state}

16. Get the Colletion_ID
    [Tags]	Functional	current
    Get Collection_ID   ${asset_Id_Product1}
    set global variable     ${Product_Collection_Id}    ${Collection_Id}

17. Link Product2 & Product3 to Product 1
    [Tags]	Functional	current
    ${result}   Link Components to Asset    Link_Product2&Product3toProduct1_FU1_withoutLinkageDetails.json   ${asset_Id_Product1}
    ${SeqId}    Get Asset Link Seq_Id   ${result.json()}   ${asset_Id_Product2}
	set global variable	${assetLinkSeqId}   ${SeqId}
	log to console	${assetLinkSeqId}   ${SeqId}
    ${SeqId1}    Get Asset Link Seq_Id   ${result.json()}   ${asset_Id_Product3}
   	set global variable	${assetLinkSeqId1}	${SeqId1}
	log to console	${assetLinkSeqId1}  ${SeqId1}
	Should Be Equal As Strings	${result.json()["data"]["assetId"]}	${asset_Id_Product1}

18. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productevaluationsetup.json	${asset_Id_Product1}

19. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product1_State after Standard Assigned To Product": ${state}

20. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${result}   Get AssesmentID   ${asset_Id_Product1}
    set global variable	${assessmentId1}    ${result}

21. Requirement Assignment To Product
	[Tags]	Functional	POST	current
	set global variable    ${assessmentId}    ${assessmentId1}
	Save Requirement	saverequirement_group1_08_with2components.json	${asset_Id_Product1}

22. Get Assessment_ParamId
	[Tags]	Functional	GET	current
	Get Assesment_ParamID	${asset_Id_Product1}

23. Render Verdict
	[Tags]	Functional	POST	current
	${response1}	Render Verdict  group05/Test_Case_02/case2a/inputrequest/request1.json	${asset_Id_Product1}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${response2}	Render Verdict	group05/Test_Case_02/case2a/inputrequest/request2.json	${asset_Id_Product1}
	run keyword if	${response2.status_code} != 200	Fail	test1 Teardown
	${clause}   has more clauses  ${response2.text}
    run keyword if  '${clause}' != 'False'  fatal error

24. Edit Product1 Attributes
    [Tags]	Functional	asset	create	POST    current
    Edit Product1 Asset	EditOfAttRegressionProduct1_siscase1_withoutCol_ID.json    ${asset_Id_Product1}
    ${response}  Get Asset From Endpoint   ${asset_Id_Product1}
    ${Att6_value}  Get TP1Attribute6  ${response}
    run keyword if  '${Att6_value}' != 'F'   Fail	test1 Teardown

25. Get Sub-Requirement
	[Tags]	Functional	GET	current
    ${response}     Get Sub-Requirement     ${asset_Id_Product1}    ${assessmentId}     Group%201
    ${Impact_eval}   Get Impact Evaluation  ${response}     Test Case 8 - Add Test
    run keyword if  '${Impact_eval}' != 'False'   Fail	test1 Teardown
    ${Eval_comp}   Get Evaluation Complete  ${response}     Test Case 8 - Add Test
    run keyword if  '${Eval_comp}' != 'True'   Fail	test1 Teardown

26. Get Context
	[Tags]	Functional	GET	current
    ${response}     Get Context     ${asset_Id_Product1}    ${assessmentId}     Group%201   Test%20Case%208%20-%20Add%20Test
    ${Context_desc}   Get Context Description  ${response}  ${asset_Id_Product2}    ${assessmentParamId}
    run keyword if  '${Context_desc}' != 'Automation_component1_context'   Fail	test1 Teardown
    ${Asset_linkages}   Get Asset Linkages  ${response}   ${asset_Id_Product2}  ${assessmentParamId}
    should not be empty     ${Asset_linkages}
    ${Context_desc1}   Get Context Description  ${response}  ${asset_Id_Product3}   ${assessmentParamId}
    run keyword if  '${Context_desc1}' != 'Automation_component2_context'   Fail	test1 Teardown
    ${Asset_linkages1}   Get Asset Linkages  ${response}   ${asset_Id_Product3}  ${assessmentParamId}
    should not be empty     ${Asset_linkages1}
    ${Eval_clauses}   Get Evaluated Clauses  ${response}    ${assessmentParamId}
    run keyword if  '${Eval_clauses}' != 'True'   Fail	test1 Teardown
    ${Verdict_render}   Get Verdict Rendered  ${response}   ${assessmentParamId}
    run keyword if  '${Verdict_render}' != 'True'   Fail	test1 Teardown
