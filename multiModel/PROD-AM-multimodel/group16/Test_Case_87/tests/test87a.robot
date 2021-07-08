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
    set global variable     ${Product_Collection_Id}    ${Collection_Id}

4. Product 2 Asset1 Creation based on product1 Asset1
    [Tags]	Functional	asset	create	POST    Notcurrent
    create product2 asset   CreationOfRegressionProduct2_siscase1.json
    set global variable  ${Component_ID}    ${asset_Id_Product2}

5. Check for Asset State
	[Tags]	Functional	Notcurrent
	${state}=	Get Asset State	${asset_Id_Product2}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Component_Asset_State": ${state}

6. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	Notcurrent
	standard assignment	productevaluationsetup.json	${asset_Id_Product2}

7. Check Asset State After Associating Standard to Product
	[Tags]	Functional	Notcurrent
	${state}=	Get Asset State	${asset_Id_Product2}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

8. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	Notcurrent
	Get AssesmentID	${asset_Id_Product2}

9. Requirement Assignment To Product
	[Tags]	Functional	POST	Notcurrent
	Save Requirement	saverequirement_group1_01.json	${asset_Id_Product2}

10. Get Assessment_ParamId
	[Tags]	Functional	GET	Notcurrent
	Get Assesment_ParamID	${asset_Id_Product2}

11. Render Verdict
	[Tags]	Functional	POST	Notcurrent
	${response1}	Render Verdict  group16/Test_Case_87/inputrequest/request1.json	${asset_Id_Product2}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${response2}	Render Verdict	group16/Test_Case_87/inputrequest/request2.json	${asset_Id_Product2}
	run keyword if	${response2.status_code} != 200	Fail	test1 Teardown
	${response3}	Render Verdict	group16/Test_Case_87/inputrequest/request3.json	${asset_Id_Product2}
	run keyword if	${response3.status_code} != 200	Fail	test1 Teardown
	${clause}   has more clauses  ${response3.text}
    run keyword if  '${clause}' != 'False'  Fail	test1 Teardown

12. Complete Evaluation
	[Tags]	Functional	POST	Notcurrent
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product2}
    Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product2}
	${result}	Evaluation Summary	${asset_Id_Product2}
	run keyword if	'${result}' != '1 : PASS : Clause Group = a'	Fail	test1 Teardown
	log to console	Result - ${result} (Implicit)

13. Link Product2 to Product 1
    [Tags]	Functional	Notcurrent
	${file}=	Get File	input/Link_Product1toComponent1withoutLinkageDetails.json
	${JSON}=	replace variables	${file}
	${result}=	Post Data To Endpoint	/assets/createAssetDetails	${JSON}	200
	set global variable	${assetLinkSeqId}	${result.json()["data"]["hasComponents"][0]["assetAssetLinkSeqId"]}
	should not be empty  ${assetLinkSeqId}
	log to console  ${assetLinkSeqId}

14. Unlink Component
    [Tags]	Functional	Notcurrent

