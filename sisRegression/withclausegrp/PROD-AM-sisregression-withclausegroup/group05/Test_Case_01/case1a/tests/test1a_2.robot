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
	Save Requirement	saverequirement_group1_08_withcomponent1.json	${asset_Id_Product1}

15. Get Assessment_ParamId
	[Tags]	Functional	GET	current
	Get Assesment_ParamID	${asset_Id_Product1}

16. Get Sub-Requirement
	[Tags]	Functional	GET	current
    ${response}     Get Sub-Requirement     ${asset_Id_Product1}    ${assessmentId}     Group%201
    ${Impact_eval}   Get Impact Evaluation  ${response}     Test Case 8 - Add Test
    run keyword if  '${Impact_eval}' != 'False'   Fail	test1 Teardown
    ${Eval_comp}   Get Evaluation Complete  ${response}     Test Case 8 - Add Test
    run keyword if  '${Eval_comp}' != 'False'   Fail	test1 Teardown

17. Get Context
	[Tags]	Functional	GET	current
    ${response}     Get Context     ${asset_Id_Product1}    ${assessmentId}     Group%201   Test%20Case%208%20-%20Add%20Test
    ${Context_desc}   Get Context Description  ${response}  ${asset_Id_Product2}    ${assessmentParamId}
    run keyword if  '${Context_desc}' != 'Automation_component1_context'   Fail	test1 Teardown
    ${Asset_linkages}   Get Asset Linkages  ${response}   ${asset_Id_Product2}  ${assessmentParamId}
    should not be empty     ${Asset_linkages}
    ${Eval_clauses}   Get Evaluated Clauses  ${response}    ${assessmentParamId}
    run keyword if  '${Eval_clauses}' != 'False'   Fail	test1 Teardown
    ${Verdict_render}   Get Verdict Rendered  ${response}   ${assessmentParamId}
    run keyword if  '${Verdict_render}' != 'False'   Fail	test1 Teardown

