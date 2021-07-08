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

4. Validate above Asset's part of same collection
    [Tags]	Functional	GET    Notcurrent
    ${response}  Get Collection Asset Link  ${Collection_Id}
    run keyword if  ${response} != (('${asset_Id_Product1}',),)    Fail	test1 Teardown

5. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	Notcurrent
	standard assignment	productevaluationsetup.json	${asset_Id_Product1}

6. Check Asset State After Associating Standard to Product
	[Tags]	Functional	Notcurrent
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

7. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	Notcurrent
	Get AssesmentID	${asset_Id_Product1}

8. Requirement Assignment To Product
	[Tags]	Functional	POST	Notcurrent
	Save Requirement	saverequirement_group1_01.json	${asset_Id_Product1}

9. Get Assessment_ParamId
	[Tags]	Functional	GET	Notcurrent
	Get Assesment_ParamID	${asset_Id_Product1}

10. Render Verdict
	[Tags]	Functional	POST	Notcurrent
	${response1}	Render Verdict  group04/Test_Case_12/inputrequest/request1.json	${asset_Id_Product1}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${response2}	Render Verdict	group04/Test_Case_12/inputrequest/request2.json	${asset_Id_Product1}
	run keyword if	${response2.status_code} != 200	Fail	test1 Teardown
	${response3}	Render Verdict	group04/Test_Case_12/inputrequest/request3.json	${asset_Id_Product1}
	run keyword if	${response3.status_code} != 200	Fail	test1 Teardown
	${clause}   has more clauses  ${response3.text}
    run keyword if  '${clause}' != 'False'  Fail	test1 Teardown

11. Complete Evaluation
	[Tags]	Functional	POST	Notcurrent
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	${result}	Evaluation Summary	${asset_Id_Product1}
	run keyword if	'${result}' != '1 : PASS : Clause Group = a'	Fail	test1 Teardown
	log to console	Result - ${result} (Implicit)

12. Validate above Asset's part of same collection
    [Tags]	Functional	GET    Notcurrent
    ${response}  Get Collection Asset Link  ${Collection_Id}
    run keyword if  ${response} != (('${asset_Id_Product1}',),)    Fail	test1 Teardown

13. Edit Asset1 Col_Attribute
    [Tags]	Functional	asset	create	POST    Notcurrent
    log to console   "Project_No before Edit: " ${Collection_Project_no}
    set global variable  ${old_collection_ID}   ${Collection_Id}
    Edit Asset Collection Attribute	 EditOfCol_AttRegressionProduct1_siscase1_withoutCol_ID.json
    run keyword if  ${Asset_Owner_Ref_edit} != ${Asset_Owner_Ref}   Fail	test1 Teardown
    run keyword if  ${Collection_Order_no_edit} != ${Collection_Order_no}   Fail	test1 Teardown
    run keyword if  ${Collection_Quote_no_edit} != ${Collection_Quote_no}   Fail	test1 Teardown
    run keyword if  ${Collection_Project_no_edit} == ${Collection_Project_no}   Fail	test1 Teardown
    log to console   "Project_No After Edit: " ${Collection_Project_no_edit}

14. Get the Colletion_ID
    [Tags]	Functional	Notcurrent
    Get Collection_ID   ${asset_Id_Product1}

15. Validate Assst is part of New collection only
    [Tags]	Functional	GET    Notcurrent
    ${response}  Get Collection Asset Link  ${Collection_Id}
    run keyword if  ${response} != (('${asset_Id_Product1}',),)    Fail	test1 Teardown

16. Validate Assst is Not part of Old collection and Old collection End dated
    [Tags]	Functional	GET    Notcurrent
    ${response}  Get Asset Effective_END_DATE  ${Collection_Id}
    run keyword if  '${response}' != '((datetime.datetime(2999, 12, 31, 23, 59, 59),),)'    Fail	test1 Teardown
    log to console  "asset_pseudo_taxonomy_link Effective_END_Date For NEw Collection_ID": ${response}
    ${response}  Get Asset Effective_END_DATE  ${old_collection_ID}
    run keyword if  '${response}' != '((datetime.datetime(2999, 12, 31, 23, 59, 59),),)'    Fail	test1 Teardown
    log to console  "asset_pseudo_taxonomy_link Effective_END_Date For OLD Collection_ID": ${response}

