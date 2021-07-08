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

3. Check for Asset State
	[Tags]	Functional	Get     current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product1_Asset_State": ${state}
	${state}=	Get Asset State	${asset_Id_Product2}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product2_Asset_State": ${state}

4. Get the Colletion_ID
    [Tags]	Functional	current
    Get Collection_ID   ${asset_Id_Product2}
    set global variable     ${Product_Collection_Id}    ${Collection_Id}

5. Standard Assignment To Product2 (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productevaluationsetup.json	${asset_Id_Product2}

6. Check Product2 State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product2}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product2_State after Standard Assigned To Product": ${state}

7. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${result}   Get AssesmentID	${asset_Id_Product2}
	set global variable	${assessmentId2}    ${result}

8. Complete Evaluation for Product2
    [Tags]	Functional	POST	current
    Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product2}
    Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product2}

9. Check Product2 State After Complete Evaluation
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product2}
	run keyword if	'${state}' != 'immutable'	Fail	test1a Teardown
	log to console	"Product2_State after Complete Evaluation": ${state}

10. Link product2 to product1
    [Tags]	Functional	current
    ${result}   Link Components to Asset    Link_Product1toComponent1withoutLinkageDetails.json   ${asset_Id_Product1}
	set global variable	${assetLinkSeqId}	${result.json()["data"]["hasComponents"][0]["assetAssetLinkSeqId"]}
	log to console	${assetLinkSeqId}
	Should Be Equal As Strings	${result.json()["data"]["assetId"]}	${asset_Id_Product1}
	should be equal as strings	${result.json()["data"]["hasComponents"][0]["assetId"]}	${asset_Id_Product2}

11. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productevaluationsetup.json	${asset_Id_Product1}

12. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product1_State after Standard Assigned To Product": ${state}

13. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${result}   Get AssesmentID   ${asset_Id_Product1}
    set global variable	${assessmentId1}    ${result}

14. Requirement Assignment To Product
	[Tags]	Functional	POST	current
	set global variable    ${assessmentId}    ${assessmentId1}
	Save Requirement	saverequirement_group3_27_withcomponent1.json	${asset_Id_Product1}

15. Get Assessment_ParamId
	[Tags]	Functional	GET	current
	Get Assesment_ParamID	${asset_Id_Product1}

16. Render Verdict
	[Tags]	Functional	POST	current
	${response1}	Render Verdict  group05/Test_Case_03/case3a/inputrequest/request1.json	${asset_Id_Product1}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${clause}   has more clauses  ${response1.text}
    run keyword if  '${clause}' != 'False'  fatal error

17. Edit Product1 Attributes
    [Tags]	Functional	asset	create	POST    current
    Edit Product1 Asset	EditOfTp1Att8RegressionProduct1_siscase1_withoutCol_ID.json    ${asset_Id_Product1}
    ${response}  Get Asset From Endpoint   ${asset_Id_Product1}
    ${Att8_value}  Get TP1Attribute8  ${response}
    run keyword if  '${Att8_value}' != '-2'   Fail	test1 Teardown

18. Get Sub-Requirement
	[Tags]	Functional	GET	current
    ${response}     Get Sub-Requirement     ${asset_Id_Product1}    ${assessmentId}     Group%203%20-%20Data%20Linkage
    ${Impact_eval}   Get Impact Evaluation  ${response}     Test Case 27 - Integer Populated
    run keyword if  '${Impact_eval}' != 'True'   Fail	test1 Teardown
    ${Eval_comp}   Get Evaluation Complete  ${response}     Test Case 27 - Integer Populated
    run keyword if  '${Eval_comp}' != 'True'   Fail	test1 Teardown

19. Get Context
	[Tags]	Functional	GET	current
    ${response}     Get Context     ${asset_Id_Product1}    ${assessmentId}     Group%203%20-%20Data%20Linkage   Test%20Case%2027%20-%20Integer%20Populated
    ${Context_desc}   Get Context Description  ${response}  ${asset_Id_Product2}    ${assessmentParamId}
    run keyword if  '${Context_desc}' != 'Automation_component1_context'   Fail	test1 Teardown
    ${Asset_linkages}   Get Asset Linkages  ${response}   ${asset_Id_Product2}  ${assessmentParamId}
    should not be empty     ${Asset_linkages}
    ${Eval_clauses}   Get Evaluated Clauses  ${response}    ${assessmentParamId}
    run keyword if  '${Eval_clauses}' != 'True'   Fail	test1 Teardown
    ${Verdict_render}   Get Verdict Rendered  ${response}   ${assessmentParamId}
    run keyword if  '${Verdict_render}' != 'True'   Fail	test1 Teardown

