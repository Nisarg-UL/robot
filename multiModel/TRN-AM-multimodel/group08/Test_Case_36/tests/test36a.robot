*** Settings ***
Documentation	Multimodel Regression TestSuite
Resource    ../../../resource/ApiFunctions.robot

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

4. Asset2 Creation with POST Request
    [Tags]	Functional	asset	create	POST    current
    create Asset2 based on product1 Asset1   CreationOfRegressionProduct1Asset2_siscase1_withCol_ID.json

5. Product 2 Asset1 Creation based on product1 Asset1
    [Tags]	Functional	asset	create	POST    current
    create product2 asset   CreationOfRegressionProduct2_siscase1.json

6. Check for Asset State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product2}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Component_Asset_State": ${state}

7. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productevaluationsetup.json	${asset_Id_Product2}

8. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product2}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

9. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	Get AssesmentID	${asset_Id_Product2}

10. Requirement Assignment To Product
	[Tags]	Functional	POST	current
	Save Requirement	saverequirement_group1_01.json	${asset_Id_Product2}

11. Get Assessment_ParamId
	[Tags]	Functional	GET	current
	Get Assesment_ParamID	${asset_Id_Product2}

12. Render Verdict
	[Tags]	Functional	POST	current
	${response1}	Render Verdict  group08/Test_Case_36/inputrequest/request1.json	${asset_Id_Product2}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${response2}	Render Verdict	group08/Test_Case_36/inputrequest/request2.json	${asset_Id_Product2}
	run keyword if	${response2.status_code} != 200	Fail	test1 Teardown
	${response3}	Render Verdict	group08/Test_Case_36/inputrequest/request3.json	${asset_Id_Product2}
	run keyword if	${response3.status_code} != 200	Fail	test1 Teardown
	${clause}   has more clauses  ${response3.text}
    run keyword if  '${clause}' != 'False'  Fail	test1 Teardown

13. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product2}
	${result}	Evaluation Summary	${asset_Id_Product2}
	run keyword if	'${result}' != '1 : PASS : Clause Group = a'	Fail	test1 Teardown
	log to console	Result - ${result} (Implicit)

14. Link Product2 to Product 1
    [Tags]	Functional	current
    ${result}   Link Components to Asset    Link_Product1toComponent1withoutLinkageDetails.json     ${asset_Id_Product1}
#	${file}=	Get File	input/Link_Product1toComponent1withoutLinkageDetails.json
#	${JSON}=	replace variables	${file}
#	${result}=	Post Data To Endpoint	/assets/createAssetDetails	${JSON}	200
	set global variable	${assetLinkSeqId}	${result.json()["data"]["hasComponents"][0]["assetAssetLinkSeqId"]}
	should not be empty  ${assetLinkSeqId}
	log to console  ${assetLinkSeqId}

15. Validate above Asset's part of same collection
    [Tags]	Functional	GET    current
    ${response}  Get Collection Asset Link  ${Product_Collection_Id}
    run keyword if  ${response} != (('${asset_Id_Product1}',), ('${asset_Id_Product12}',))    Fail	test1 Teardown

