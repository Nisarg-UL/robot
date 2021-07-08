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
    create product1_siscase2 asset	CreationOfRegressionProduct1_siscase2.json

2. Asset Creation With POST Request
	[Tags]	Functional	asset2	create	POST    Notcurrent
    create product2_siscase2 asset	CreationOfRegressionProduct2_siscase2.json

3. Asset Creation With POST Request
	[Tags]	Functional	asset3	create	POST    Notcurrent
    create product3_siscase2 asset	CreationOfRegressionProduct3_siscase2.json

4. Check for Asset State
	[Tags]	Functional	Get Notcurrent
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product1_Asset_State": ${state}
	${state}=	Get Asset State	${asset_Id_Product2}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product2_Asset_State": ${state}
	${state}=	Get Asset State	${asset_Id_Product3}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product3_Asset_State": ${state}

5. Get the Colletion_ID
    [Tags]	Functional	Notcurrent
    Get Collection_ID   ${asset_Id_Product2}
    set global variable     ${Product_Collection_Id}    ${Collection_Id}

6. Standard Assignment To Product2 (Product Evaluation Set Up)
	[Tags]	Functional	POST	Notcurrent
	standard assignment	productevaluationsetup.json	${asset_Id_Product2}

7. Check Product2 State After Associating Standard to Product
	[Tags]	Functional	Notcurrent
	${state}=	Get Asset State	${asset_Id_Product2}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product2_State after Standard Assigned To Product": ${state}

8. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	Notcurrent
	${result}   Get AssesmentID	${asset_Id_Product2}
	set global variable	${assessmentId2}    ${result}

9. Complete Evaluation for Product2
    [Tags]	Functional	POST	Notcurrent
    Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product2}
    Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product2}

10. Check Product2 State After Complete Evaluation
	[Tags]	Functional	Notcurrent
	${state}=	Get Asset State	${asset_Id_Product2}
	run keyword if	'${state}' != 'immutable'	Fail	test1a Teardown
	log to console	"Product2_State after Complete Evaluation": ${state}

11. Get the Colletion_ID
    [Tags]	Functional	Notcurrent
    Get Collection_ID   ${asset_Id_Product3}
    set global variable     ${Product_Collection_Id}    ${Collection_Id}

12. Link Product2 to product3
    [Tags]	Functional	Notcurrent
	${result}   Link Components to Asset    Link_Product2toProduct3_FU1_withoutLinkageDetails.json   ${asset_Id_Product3}
	set global variable	${assetLinkSeqId}	${result.json()["data"]["hasComponents"][0]["assetAssetLinkSeqId"]}
	log to console	${assetLinkSeqId}
	Should Be Equal As Strings	${result.json()["data"]["assetId"]}	${asset_Id_Product3}
	should be equal as strings	${result.json()["data"]["hasComponents"][0]["assetId"]}	${asset_Id_Product2}

13. Standard Assignment To Product3 (Product Evaluation Set Up)
	[Tags]	Functional	POST	Notcurrent
	standard assignment	productevaluationsetup.json	${asset_Id_Product3}

14. Check Product3 State After Associating Standard to Product
	[Tags]	Functional	Notcurrent
	${state}=	Get Asset State	${asset_Id_Product3}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product3_State after Standard Assigned To Product": ${state}

15. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	Notcurrent
	${result}   Get AssesmentID	${asset_Id_Product3}
    set global variable	${assessmentId3}    ${result}

16. Complete Evaluation for Product3
    [Tags]	Functional	POST	Notcurrent
    Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product3}
    Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product3}

17. Check Product3 State After Complete Evaluation
	[Tags]	Functional	Notcurrent
	${state}=	Get Asset State	${asset_Id_Product3}
	run keyword if	'${state}' != 'immutable'	Fail	test1a Teardown
	log to console	"Product3_State after Complete Evaluation": ${state}

18. Get the Colletion_ID
    [Tags]	Functional	Notcurrent
    Get Collection_ID   ${asset_Id_Product1}
    set global variable     ${Product_Collection_Id}    ${Collection_Id}

19. Link Product2 & Product3 to Product 1
    [Tags]	Functional	Notcurrent
	${result}   Link Components to Asset    Link_Product2&Product3toProduct1_FU1_withoutLinkageDetails.json   ${asset_Id_Product1}
	set global variable	${assetLinkSeqId}	${result.json()["data"]["hasComponents"][0]["assetAssetLinkSeqId"]}
	log to console	${assetLinkSeqId}
	Should Be Equal As Strings	${result.json()["data"]["assetId"]}	${asset_Id_Product1}

20. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	Notcurrent
	standard assignment	productevaluationsetup.json	${asset_Id_Product1}

21. Check Asset State After Associating Standard to Product
	[Tags]	Functional	Notcurrent
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product1_State after Standard Assigned To Product": ${state}

22. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	Notcurrent
	${result}   Get AssesmentID   ${asset_Id_Product1}
    set global variable	${assessmentId1}    ${result}

23. Requirement Assignment To Product
	[Tags]	Functional	POST	Notcurrent
	set global variable    ${assessmentId}    ${assessmentId1}
	Save Requirement	saverequirement_group3_18.json	${asset_Id_Product1}

24. Get Assessment_ParamId
	[Tags]	Functional	GET	Notcurrent
	Get Assesment_ParamID	${asset_Id_Product1}

25. Render Verdict
	[Tags]	Functional	POST	Notcurrent
	${response1}	Render Verdict	group03/Test_Case_18/case18b/inputrequest/request1.json	${asset_Id_Product1}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${clause}   has more clauses  ${response1.text}
    run keyword if  '${clause}' != 'False'  fatal error

26. Complete Evaluation
	[Tags]	Functional	POST	Notcurrent
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	${result}	Evaluation Summary	${asset_Id_Product1}
	run keyword if	'${result}' != '18 : PASS : Clause Group = c'	Fail	test1 Teardown
	${result2}  Clause ID  ${asset_Id_Product1}
	log to console	'Result = ${result} at Cl. ${result2}