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
	[Tags]	Functional	asset	create	POST    current
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
	Save Requirement	saverequirement_group4_subgrp3.json	${asset_Id_Product1}

8. Get Assessment_ParamId
	[Tags]	Functional	GET	current
	Get Assesment_ParamID	${asset_Id_Product1}

9. Render Verdict
	[Tags]	Functional	POST	current
	${response1}	Render Verdict  group4/Test_Case_30/case30q-edit2(2.4,2.6,2.7)/inputrequest/request1.json	${asset_Id_Product1}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${response2}	Render Verdict	group4/Test_Case_30/case30q-edit2(2.4,2.6,2.7)/inputrequest/request2.json	${asset_Id_Product1}
	run keyword if	${response2.status_code} != 200	Fail	test1 Teardown
	${response3}	Render Verdict	group4/Test_Case_30/case30q-edit2(2.4,2.6,2.7)/inputrequest/request3.json	${asset_Id_Product1}
	run keyword if	${response3.status_code} != 200	Fail	test1 Teardown
	${clause}   has more clauses  ${response3.text}
    run keyword if  '${clause}' != 'False'  fatal error
    ${result}	Evaluation Summary	${asset_Id_Product1}
	run keyword if	${result} != ['2.1, 2.2, 2.3 : PASS', '2.4, 2.6, 2.7 : PASS']   Fail	test1 Teardown
	log to console	Result Before Edit - ${result}
    ${response4}	Render Verdict	group4/Test_Case_30/case30q-edit2(2.4,2.6,2.7)/inputrequest/request4.json	${asset_Id_Product1}
	run keyword if	${response4.status_code} != 200	Fail	test1 Teardown
	${response5}	Render Verdict	group4/Test_Case_30/case30q-edit2(2.4,2.6,2.7)/inputrequest/request5.json	${asset_Id_Product1}
	run keyword if	${response5.status_code} != 200	Fail	test1 Teardown
	${response6}	Render Verdict	group4/Test_Case_30/case30q-edit2(2.4,2.6,2.7)/inputrequest/request6.json	${asset_Id_Product1}
	run keyword if	${response6.status_code} != 200	Fail	test1 Teardown

10. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}
	${result}	Evaluation Summary	${asset_Id_Product1}
	run keyword if	${result} != ['2.1, 2.2, 2.3 : PASS', '2.4 : NA', '2.6 : NA', '2.7 : NA']   Fail	test1 Teardown
	log to console	Result After Edit - ${result}
