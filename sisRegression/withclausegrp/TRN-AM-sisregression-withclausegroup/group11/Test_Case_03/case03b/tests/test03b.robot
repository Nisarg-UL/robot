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
	[Tags]	Functional	asset	Test	create	POST    Notcurrent
    create product1 asset	CreationOfRegressionProduct1_siscase3.json

2. Check for Asset State
	[Tags]	Functional	Notcurrent
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_Asset_State": ${state}

3. Get the Colletion_ID
    [Tags]	Functional	Notcurrent
    Get Collection_ID   ${asset_Id_Product1}
    set global variable     ${Product_Collection_Id}    ${Collection_Id}


4. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	Notcurrent
	standard assignment	productevaluationsetup.json	${asset_Id_Product1}

5. Check Asset State After Associating Standard to Product
	[Tags]	Functional	Notcurrent
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

6. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	Notcurrent
	Get AssesmentID	${asset_Id_Product1}

7. Requirement Assignment To Product
	[Tags]	Functional	POST	Notcurrent
	Save Requirement	SaveRequirement_group10-15/saverequirement_group11_03.json	${asset_Id_Product1}

8. Get Assessment_ParamId
	[Tags]	Functional	GET	Notcurrent
	Get Assesment_ParamID	${asset_Id_Product1}

9. Render Verdict
	[Tags]	Functional	POST	Notcurrent
	${response1}	Render Verdict	group11/Test_Case_03/case03a/inputrequest/request1.json	${asset_Id_Product1}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${clause}   has more clauses  ${response1.text}
    run keyword if  '${clause}' != 'False'  fatal error

10. Complete Evaluation
	[Tags]	Functional	POST	Notcurrent
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}
	${result}	Evaluation Summary	${asset_Id_Product1}
	run keyword if	'${result}' != '2 : NA : Clause Group = 2'	Fail	test1 Teardown
	${result1}	Clause Text  ${asset_Id_Product1}
	log to console	'Result = ${result} at cl. ${result1}