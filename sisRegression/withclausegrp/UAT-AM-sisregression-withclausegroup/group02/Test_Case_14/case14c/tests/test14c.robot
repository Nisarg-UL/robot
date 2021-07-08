*** Settings ***
Documentation	SIS Regression TestSuite
Resource	../../../../resource/ApiFunctions.robot

*** Keywords ***

*** Test Cases ***
1a. Setting up Environment
	set global variable	${asset_Id_Product1}

1. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    create product1 asset	CreationOfRegressionProduct1_siscase2.json

2. Check for Asset State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_Asset_State": ${state}

3. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productevaluationsetup.json	${asset_Id_Product1}

4. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

5. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	Get AssesmentID	${asset_Id_Product1}

6. Requirement Assignment To Product
	[Tags]	Functional	POST	current
	Save Requirement	saverequirement_group2_14b.json	${asset_Id_Product1}

7. Get Assessment_ParamId
	[Tags]	Functional	GET	current
	Get Assesment_ParamID	${asset_Id_Product1}

8. Render Verdict
	[Tags]	Functional	POST	current
	${response1}	Render Verdict	group02/Test_Case_14/case14c/inputrequest/request1.json	${asset_Id_Product1}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${response2}	Render Verdict	group02/Test_Case_14/case14c/inputrequest/request2.json	${asset_Id_Product1}
	run keyword if	${response2.status_code} != 200	Fail	test1 Teardown
	${response3}	Render Verdict	group02/Test_Case_14/case14c/inputrequest/request3.json	${asset_Id_Product1}
	run keyword if	${response3.status_code} != 200	Fail	test1 Teardown
	${response4}	Render Verdict	group02/Test_Case_14/case14c/inputrequest/request4.json	${asset_Id_Product1}
	run keyword if	${response4.status_code} != 200	Fail	test1 Teardown
	${response5}	Render Verdict	group02/Test_Case_14/case14c/inputrequest/request5.json	${asset_Id_Product1}
	run keyword if	${response5.status_code} != 200	Fail	test1 Teardown
	${clause}   has more clauses  ${response5.text}
    run keyword if  '${clause}' != 'False'  fatal error

9. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	${result}	Evaluation Summary	${asset_Id_Product1}
#	run keyword if	${result} != ['14-Q1 : NA : Clause Group = b', '14-Q2 : NA : Clause Group = c']	Fail	test1 Teardown
	run keyword if	${result} != ['1.1 : NA : Clause Group = ', '1.2 : NA : Clause Group = ', '1.3 : NA : Clause Group = ', '1.4 : NA : Clause Group = ']	Fail	test1 Teardown
	log to console	'Result = ${result}

10. Get Reviewer Summary Details
    [Tags]	Functional	GET	current
	Get Reviewer Summary Details    ${asset_Id_Product1}    ${assessmentId}
	${summary}  reviewer_summary    ${response_search_api}
	should be equal  	"${summary}"    "[['1.1', 'Test Case 14b - Evaluation Not Required on Sub-Group - Clause Navigation', 'Group 2 - Evaluation Not Required Tests'], ['1.2', 'Test Case 14b - Evaluation Not Required on Sub-Group - Clause Navigation', 'Group 2 - Evaluation Not Required Tests'], ['1.3', 'Test Case 14b - Evaluation Not Required on Sub-Group - Clause Navigation', 'Group 2 - Evaluation Not Required Tests'], ['1.4', 'Test Case 14b - Evaluation Not Required on Sub-Group - Clause Navigation', 'Group 2 - Evaluation Not Required Tests']]"