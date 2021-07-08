*** Settings ***
Documentation	Taxonomy Modification TestSuite
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
    set global variable  ${product_collection_id}   ${collection_id}

4. Validate above Asset's part of same collection
    [Tags]	Functional	GET    current
    ${response}  Get Collection Asset Link  ${Collection_Id}
    run keyword if  ${response} != (('${asset_Id_Product1}',), )    Fail	test1 Teardown

5. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productevaluationsetup.json	${asset_Id_Product1}

6. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

7. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	Get AssesmentID	${asset_Id_Product1}

8. Requirement Assignment To Product
	[Tags]	Functional	POST	current
	Save Requirement	saverequirement_group1_01.json	${asset_Id_Product1}

9. Get Assessment_ParamId
	[Tags]	Functional	GET	current
	Get Assesment_ParamID	${asset_Id_Product1}

10. Render Verdict
	[Tags]	Functional	POST	current
	${response1}	Render Verdict  group/Test_Case_03/inputrequest/request1.json	${asset_Id_Product1}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${response2}	Render Verdict	group/Test_Case_03/inputrequest/request2.json	${asset_Id_Product1}
	run keyword if	${response2.status_code} != 200	Fail	test1 Teardown
	${response3}	Render Verdict	group/Test_Case_03/inputrequest/request3.json	${asset_Id_Product1}
	run keyword if	${response3.status_code} != 200	Fail	test1 Teardown
	${clause}   has more clauses  ${response3.text}
    run keyword if  '${clause}' != 'False'  Fail	test1 Teardown

11. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}
	${result}	Evaluation Summary	${asset_Id_Product1}
	run keyword if	'${result}' != '1 : PASS : Clause Group = a'	Fail	test1 Teardown
	log to console	Result - ${result} (Implicit)

12. Modify Asset1 Attribute
    [Tags]	Functional	asset	create	POST    current
    set global variable  ${old_asset_Id_Product1}  ${asset_Id_Product1}
    set global variable  ${old_Collection_Id}  ${Collection_Id}
    Edit Asset Collection Attribute 	ModifyCol_AttRegressionProduct1_siscase1_withoutCol_ID.json 	${asset_Id_Product1}
    run keyword if  '${old_asset_Id_Product1}' == '${asset_Id_Product1}'    Fail	test1 Teardown
    Get Collection_ID   ${asset_Id_Product1}
    run keyword if  '${old_Collection_Id}' == '${Collection_Id}'    Fail	test1 Teardown

13. Validate above Asset's part of different collection
    [Tags]	Functional	GET    current
    ${response}  Get Collection Asset Link  ${old_Collection_Id}
    run keyword if  ${response} != (('${old_asset_Id_Product1}',), )    Fail	test1 Teardown
    ${response}  Get Collection Asset Link  ${Collection_Id}
    run keyword if  ${response} != (('${asset_Id_Product1}',), )    Fail	test1 Teardown

#ModifyTaxonomyBulkmodelwithout Collection_Id
#Customer requests to change Reference Number (ver1.0) for one of Immutable Asset in collection
#-Reference Number -  (< 50 charachters)
14. Change Reference Number
    [Tags]	Functional	POST	current
    run keyword and ignore error  Modify Taxonomy Bulk_Model Without Collection_Id   change_refno_less_than_50_chars_Bulk_Model_after_version_up.json
    ${status}   api_message  ${response_api}
    run keyword if  "${status}" != "Taxonomy updated successfully"  Fail