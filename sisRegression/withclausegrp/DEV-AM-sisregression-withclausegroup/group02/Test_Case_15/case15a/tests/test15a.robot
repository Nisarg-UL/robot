*** Settings ***
Documentation	SIS Regression TestSuite
Resource	../../../../resource/ApiFunctions.robot

*** Keywords ***

*** Test Cases ***
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


4. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productevaluationsetup.json	${asset_Id_Product1}

5. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

6. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	Get AssesmentID	${asset_Id_Product1}

7. Requirement Assignment To Product
	[Tags]	Functional	POST	current
	Save Requirement	saverequirement_group2_15.json	${asset_Id_Product1}

8. Get Assessment_ParamId
	[Tags]	Functional	GET	current
	Get Assesment_ParamID	${asset_Id_Product1}

9. Render Verdict
	[Tags]	Functional	POST	current
	${response1}	Render Verdict	group02/Test_Case_15/case15a/inputrequest/request1.json	${asset_Id_Product1}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${response2}	Render Verdict	group02/Test_Case_15/case15a/inputrequest/request2.json	${asset_Id_Product1}
	run keyword if	${response2.status_code} != 200	Fail	test1 Teardown
	${clause}   has more clauses  ${response2.text}
    run keyword if  '${clause}' != 'False'  fatal error

10. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}
	${result}	Evaluation Summary	${asset_Id_Product1}
	run keyword if	${result} != ['i1 : NA : Clause Group = ', 'i2 : NA : Clause Group = ', 'j1 : NA : Clause Group = ', 'j2 : NA : Clause Group = ', 'j3 : NA : Clause Group = ']	Fail	test1 Teardown

11. Get Reviewer Summary Details
    [Tags]	Functional	GET	current
	Get Reviewer Summary Details    ${asset_Id_Product1}    ${assessmentId}
	${summary}  reviewer_summary    ${response_search_api}
	should be equal  	"${summary}"    "[['i2', 'Test Case 15 - Evaluation Not Required on Sub-Group - Data Linked Scenarios - Single Clause Group, multiple Data linkages down a Column', 'Group 2 - Evaluation Not Required Tests'], ['j1', 'Test Case 15 - Evaluation Not Required on Sub-Group - Data Linked Scenarios - Single Clause Group, multiple Data linkages down a Column', 'Group 2 - Evaluation Not Required Tests'], ['j2', 'Test Case 15 - Evaluation Not Required on Sub-Group - Data Linked Scenarios - Single Clause Group, multiple Data linkages down a Column', 'Group 2 - Evaluation Not Required Tests'], ['j3', 'Test Case 15 - Evaluation Not Required on Sub-Group - Data Linked Scenarios - Single Clause Group, multiple Data linkages down a Column', 'Group 2 - Evaluation Not Required Tests'], ['i1', 'Test Case 15 - Evaluation Not Required on Sub-Group - Data Linked Scenarios - Single Clause Group, multiple Data linkages down a Column', 'Group 2 - Evaluation Not Required Tests']]"