*** Settings ***
Documentation	Multimodel Regression TestSuite
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
    set global variable  ${product_collection_id}   ${collection_id}

4. Asset2 Creation with POST Request
    [Tags]	Functional	asset	create	POST    Notcurrent
    create Asset2 based on product1 Asset1   CreationOfRegressionProduct1Asset2_siscase1_withCol_ID.json

5. Validate above Asset's part of same collection
    [Tags]	Functional	GET    Notcurrent
    ${response}  Get Collection Asset Link  ${Collection_Id}
    run keyword if  ${response} != (('${asset_Id_Product1}',), ('${asset_Id_Product12}',))    Fail	test1 Teardown

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
	Get AssesmentID	${asset_Id_Product1}

9. Requirement Assignment To Product
	[Tags]	Functional	POST	Notcurrent
	Save Requirement	saverequirement_group1_01.json	${asset_Id_Product1}

10. Get Assessment_ParamId
	[Tags]	Functional	GET	Notcurrent
	Get Assesment_ParamID	${asset_Id_Product1}

11. Render Verdict
	[Tags]	Functional	POST	Notcurrent
	${response1}	Render Verdict  group04/Test_Case_20/inputrequest/request1.json	${asset_Id_Product1}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${response2}	Render Verdict	group04/Test_Case_20/inputrequest/request2.json	${asset_Id_Product1}
	run keyword if	${response2.status_code} != 200	Fail	test1 Teardown
	${response3}	Render Verdict	group04/Test_Case_20/inputrequest/request3.json	${asset_Id_Product1}
	run keyword if	${response3.status_code} != 200	Fail	test1 Teardown
	${clause}   has more clauses  ${response3.text}
    run keyword if  '${clause}' != 'False'  Fail	test1 Teardown

12. Complete Evaluation
	[Tags]	Functional	POST	Notcurrent
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	${result}	Evaluation Summary	${asset_Id_Product1}
	run keyword if	'${result}' != '1 : PASS : Clause Group = a'	Fail	test1 Teardown
	log to console	Result - ${result} (Implicit)

13. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	Notcurrent
	Get AssesmentID	${asset_Id_Product12}

14. Requirement Assignment To Product
	[Tags]	Functional	POST	Notcurrent
	Save Requirement	saverequirement_group1_01.json	${asset_Id_Product12}

15. Get Assessment_ParamId
	[Tags]	Functional	GET	Notcurrent
	Get Assesment_ParamID	${asset_Id_Product12}

16. Render Verdict
	[Tags]	Functional	POST	Notcurrent
	${response1}	Render Verdict  group04/Test_Case_20/inputrequest/request1.json	${asset_Id_Product12}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${response2}	Render Verdict	group04/Test_Case_20/inputrequest/request2.json	${asset_Id_Product12}
	run keyword if	${response2.status_code} != 200	Fail	test1 Teardown
	${response3}	Render Verdict	group04/Test_Case_20/inputrequest/request3.json	${asset_Id_Product12}
	run keyword if	${response3.status_code} != 200	Fail	test1 Teardown
	${clause}   has more clauses  ${response3.text}
    run keyword if  '${clause}' != 'False'  Fail	test1 Teardown

17. Complete Evaluation
	[Tags]	Functional	POST	Notcurrent
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product12}
	${result}	Evaluation Summary	${asset_Id_Product12}
	run keyword if	'${result}' != '1 : PASS : Clause Group = a'	Fail	test1 Teardown
	log to console	Result - ${result} (Implicit)

18. Validate above Asset's part of same collection
    [Tags]	Functional	GET    Notcurrent
    ${response}  Get Collection Asset Link  ${Collection_Id}
    run keyword if  ${response} != (('${asset_Id_Product1}',), ('${asset_Id_Product12}',))    Fail	test1 Teardown

19. Edit Asset1 Col_Attribute
    [Tags]	Functional	asset	create	POST    Notcurrent
    ${response}  create Product 2 Asset1 based on product1 Asset1	EditOfCol_AttRegressionProduct1_siscase1_withCol_ID.json
    run keyword if  '${response}' != 'Collection cannot have assets with different states'    Fail	test1 Teardown
    log to console  ${response}

