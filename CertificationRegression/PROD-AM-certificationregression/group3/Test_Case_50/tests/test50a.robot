*** Settings ***
Documentation	SIS Regression TestSuite
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
	${response}  Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId}     ${response}
	set global variable	${assessmentId1}	${assessmentId}

8. Requirement Assignment To Product
	[Tags]	Functional	POST	current
	Save Requirement	saverequirement_group1_01.json	${asset_Id_Product1}

9. Get Assessment_ParamId
	[Tags]	Functional	GET	current
	Get Assesment_ParamID	${asset_Id_Product1}

10. Render Verdict
	[Tags]	Functional	POST	current
	${response1}	Render Verdict  group3/Test_Case_50/inputrequest/request1.json	${asset_Id_Product1}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${response2}	Render Verdict	group3/Test_Case_50/inputrequest/request2.json	${asset_Id_Product1}
	run keyword if	${response2.status_code} != 200	Fail	test1 Teardown
	${response3}	Render Verdict	group3/Test_Case_50/inputrequest/request3.json	${asset_Id_Product1}
	run keyword if	${response3.status_code} != 200	Fail	test1 Teardown
	${clause}   has more clauses  ${response3.text}
    run keyword if  '${clause}' != 'False'  fatal error

11. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}
	${result}	Evaluation Summary	${asset_Id_Product1}
	run keyword if	'${result}' != '1 : PASS : Clause Group = a'	Fail	test1 Teardown
	log to console	Result - ${result} (Implicit)

12. Certificate creation
	[Tags]	Functional	certificate	create	POST    current
    create certificate   Certificate/CreationOfRegressionSchemeCertificate.json

13. Link Product and Evaluation to Certificate
    [Tags]	Functional	certificate	create	POST    current
    ${response}  Get ULAssetID   ${asset_Id_Product1}
    set global variable	${ul_asset_Id}  ${response}
    Link Product to Certificate  Certificate/Link_Product1_Eval1_RegressionCertificate.json

14. Search Certificate with Certificate Type and Product Type and Owner Reference and Certificate Name
    [Tags]	Functional	current
    ${response}  Search Certificate   certificateType=Regression%20Scheme&productType=Regression+Test+Product+1&ownerReference=${Cert_Owner_Ref}&certificateName=Regression-US001-1
    run keyword if  '${response}' != '${Cert_Owner_Ref}'     Fail

