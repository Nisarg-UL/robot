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

4. Product 2 Asset1 Creation based on product1 Asset1
    [Tags]	Functional	asset	create	POST    current
    create product2 asset   CreationOfRegressionProduct2_siscase1.json
    set global variable  ${Component_ID}    ${asset_Id_Product2}

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
	Get AssesmentID	${asset_Id_Product2}

9. Requirement Assignment To Product
	[Tags]	Functional	POST	current
	Save Requirement	saverequirement_group1_01.json	${asset_Id_Product2}

10. Get Assessment_ParamId
	[Tags]	Functional	GET	current
	Get Assesment_ParamID	${asset_Id_Product2}

11. Render Verdict
	[Tags]	Functional	POST	current
	${response1}	Render Verdict  group22/Test_Case_133/inputrequest/request1.json	${asset_Id_Product2}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${response2}	Render Verdict	group22/Test_Case_133/inputrequest/request2.json	${asset_Id_Product2}
	run keyword if	${response2.status_code} != 200	Fail	test1 Teardown
	${response3}	Render Verdict	group22/Test_Case_133/inputrequest/request3.json	${asset_Id_Product2}
	run keyword if	${response3.status_code} != 200	Fail	test1 Teardown
	${clause}   has more clauses  ${response3.text}
    run keyword if  '${clause}' != 'False'  Fail	test1 Teardown

12. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product2}
	${result}	Evaluation Summary	${asset_Id_Product2}
	run keyword if	'${result}' != '1 : PASS : Clause Group = a'	Fail	test1 Teardown
	log to console	Result - ${result} (Implicit)

13. Link Product2 to Product 1
    [Tags]	Functional	current
    ${result}   Link Components to Asset    Link_Product1toComponent1withoutLinkageDetails.json     ${asset_Id_Product1}
	set global variable	${assetLinkSeqId}	${result.json()["data"]["hasComponents"][0]["assetAssetLinkSeqId"]}
	should not be empty  ${assetLinkSeqId}
	log to console  ${assetLinkSeqId}

14. Product 2 Asset2 Creation based on product1 Asset1
    [Tags]	Functional	asset	create	POST    current
    create product2 asset   CreationOfRegressionProduct2_siscase1.json

15. Link Alternate Component to Product 2
    [Tags]	Functional	current
    ${result}   Link Components to Asset    Link_Alternate_Component_To_Product2.json     ${asset_Id_Product1}
	Should Be Equal As Strings	${result.json()["data"]["assetId"]}	${asset_Id_Product1}

16. Asset Creation With POST Request
	[Tags]	Functional	asset	create	POST    current
    create Asset2 based on product1 Asset1     CreationOfRegressionProduct1Asset2_siscase1_withCol_ID.json

17. Check for Asset State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product12}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_Asset_State": ${state}

18. Product 3 Asset1 Creation based on product1 Asset1
    [Tags]	Functional	asset	create	POST    current
    create product3 asset   CreationOfRegressionProduct3_siscase1.json
    set global variable  ${Component_ID2}    ${asset_Id_Product3}

19. Check for Asset State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product3}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Component_Asset_State": ${state}

20. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productevaluationsetup.json	${asset_Id_Product3}

21. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product3}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

22. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	Get AssesmentID	${asset_Id_Product3}

23. Requirement Assignment To Product
	[Tags]	Functional	POST	current
	Save Requirement	saverequirement_group1_01.json	${asset_Id_Product3}

24. Get Assessment_ParamId
	[Tags]	Functional	GET	current
	Get Assesment_ParamID	${asset_Id_Product3}

25. Render Verdict
	[Tags]	Functional	POST	current
	${response1}	Render Verdict  group22/Test_Case_133/inputrequest/request1.json	${asset_Id_Product3}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${response2}	Render Verdict	group22/Test_Case_133/inputrequest/request2.json	${asset_Id_Product3}
	run keyword if	${response2.status_code} != 200	Fail	test1 Teardown
	${response3}	Render Verdict	group22/Test_Case_133/inputrequest/request3.json	${asset_Id_Product3}
	run keyword if	${response3.status_code} != 200	Fail	test1 Teardown
	${clause}   has more clauses  ${response3.text}
    run keyword if  '${clause}' != 'False'  Fail	test1 Teardown

26. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product3}
	${result}	Evaluation Summary	${asset_Id_Product3}
	run keyword if	'${result}' != '1 : PASS : Clause Group = a'	Fail	test1 Teardown
	log to console	Result - ${result} (Implicit)

27. Link Product2 to Product 1
    [Tags]	Functional	current
    ${result}   Link Components to Asset    Link_Product3toProduct1_FU1_withoutLinkageDetails.json     ${asset_Id_Product1}
	set global variable	${assetLinkSeqId2}	${result.json()["data"]["hasComponents"][0]["assetAssetLinkSeqId"]}
	should not be empty  ${assetLinkSeqId2}
	log to console  ${assetLinkSeqId2}

28. Get Component and Alternate of Asset in Collection
    [Tags]	Functional	current
    run keyword and ignore error    Get Error Message for Get Compoenent of Asset In Collection with asset_id  ${Product_Collection_Id}  0000XXXX-XXXX-00X0-X000-00X0XXXXXXX
    ${msg}  Get Error Message   ${response_api}
    should be equal  '${msg}'    'AssetIds are not part of the collection'