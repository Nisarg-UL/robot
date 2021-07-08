*** Settings ***
Documentation	Validation and Complete TestSuite
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

4. Product 2 Asset1 Creation based on product1 Asset1
    [Tags]	Functional	asset	Test	create	POST    current
    create product2 asset   CreationOfRegressionProduct2_siscase1.json

5. Check for Asset State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product2}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Component_Asset_State": ${state}

6. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productevaluationsetup.json	${asset_Id_Product2}

7. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product2}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

8. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${response}  Get AssesmentID	${asset_Id_Product2}
	set global variable	${assessmentId}	${response}

9. Requirement Assignment To Product
	[Tags]	Functional	POST	current
	Save Requirement	saverequirement_group1_01.json	${asset_Id_Product2}

10. Get Assessment_ParamId
	[Tags]	Functional	GET	current
	Get Assesment_ParamID	${asset_Id_Product2}

11. Render Verdict
	[Tags]	Functional	POST	current
	${response1}	Render Verdict  group/Test_Case_06/inputrequest/request1.json	${asset_Id_Product1}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${response2}	Render Verdict	group/Test_Case_06/inputrequest/request2.json	${asset_Id_Product1}
	run keyword if	${response2.status_code} != 200	Fail	test1 Teardown
	${clause}   has more clauses  ${response2.text}
    run keyword if  '${clause}' != 'False'  fatal error

12. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product2}
	${result}	Evaluation Summary	${asset_Id_Product2}
	run keyword if	'${result}' != '1 : PASS : Clause Group = a'	Fail	test1 Teardown
	log to console	Result - ${result} (Implicit)

13. Link Product2 to Product 1
    [Tags]	Functional	current
	${file}=	Get File	input/Link_Product1toComponent1withoutLinkageDetails.json
	${JSON}=	replace variables	${file}
	${result}=	Post Data To Endpoint	/assets/createAssetDetails	${JSON}	200
	set global variable	${assetLinkSeqId}	${result.json()["data"]["hasComponents"][0]["assetAssetLinkSeqId"]}
	should not be empty  ${assetLinkSeqId}
	log to console  ${assetLinkSeqId}

14. Standard Assignment To Product1
	[Tags]	Functional	POST	current
	standard assignment	productevaluationsetup.json	${asset_Id_Product1}

15. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${result}   Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId}    ${result}

16. Requirement Assignment To Product
	[Tags]	Functional	POST	current
	Save Requirement	saverequirement_group1_01.json	${asset_Id_Product1}

17. Get Assessment_ParamId
	[Tags]	Functional	GET	current
	Get Assesment_ParamID	${asset_Id_Product1}

18. Render Verdict
	[Tags]	Functional	POST	current
	${response1}	Render Verdict  group/Test_Case_07/inputrequest/request1.json	${asset_Id_Product1}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${response2}	Render Verdict	group/Test_Case_07/inputrequest/request2.json	${asset_Id_Product1}
	run keyword if	${response2.status_code} != 200	Fail	test1 Teardown
	${clause}   has more clauses  ${response2.text}
    run keyword if  '${clause}' != 'False'  fatal error

19. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	${result}	Evaluation Summary	${asset_Id_Product1}
	run keyword if	'${result}' != '1 : PASS : Clause Group = a'	Fail	test1 Teardown
	log to console	Result - ${result} (Implicit)