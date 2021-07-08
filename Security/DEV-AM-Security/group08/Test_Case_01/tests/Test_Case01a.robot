*** Settings ***
Documentation	Security TestSuite
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
    create product2 asset	CreationOfRegressionProduct2_siscase1.json

2. Check Asset State
	[Tags]	Functional	Notcurrent
	${state}=	Get Asset State	${asset_Id_Product2}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

3. Product 2 Asset1 Creation based on product1 Asset1
    [Tags]	Functional	asset	create	POST    Notcurrent
    create product1 asset   CreationOfRegressionProduct1_siscase1.json

4. Check for Asset State
	[Tags]	Functional	Notcurrent
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Component_Asset_State": ${state}

5. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	Notcurrent
	standard assignment	productnoevalreqd.json	${asset_Id_Product1}

6. Check Asset State After Associating Standard to Product
	[Tags]	Functional	Notcurrent
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

7. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	Notcurrent
	${assessmentId}  Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId}	${assessmentId}

8. Complete Evaluation
	[Tags]	Functional	POST	Notcurrent
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}

9. Check Asset State After Evaluation
	[Tags]	Functional	Notcurrent
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'immutable'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

10. Link Product2 to Product 1
    [Tags]	Functional	Notcurrent
    ${result}   Link Components to Asset    Link_Product1toProduct2_FU1_withoutLinkageDetails.json     ${asset_Id_Product2}
	set global variable	${assetLinkSeqId}	${result.json()["data"]["hasComponents"][0]["assetAssetLinkSeqId"]}
	should not be empty  ${assetLinkSeqId}
	log to console  ${assetLinkSeqId}

11. Get Component details using UserId
	[Tags]	Functional	certificate create	POST    Notcurrent
	Get Component Details using UserId     ${asset_Id_Product2}   ${user_id}
	should not be empty   ${components}
    run keyword if  "${comp_asset_id}" != "${asset_Id_Product1}"     Fail
    ${asset_linkage_names}	get_asset_linkage_names  ${components}   ${asset_Id_Product1}   name
    run keyword if  ${asset_linkage_names} != ['Functional Use', 'Component Name', 'AL-RTP2-FU1 Attribute 1', 'AL-RTP2-FU1 Attribute 2', 'AL-RTP2-FU1 Attribute 3', 'AL-RTP2-FU1 Attribute 4', 'AL-RTP2-FU1 Attribute 5', 'AL-RTP2-FU1 Attribute 6', 'AL-RTP2-FU1 Attribute 7', 'AL-RTP2-FU1 Attribute 8', 'AL-RTP2-FU1 Attribute 9', 'AL-RTP2-FU1 Attribute 10', 'AL-RTP2-FU1 Attribute 11', 'AL-RTP2-FU1 Attribute 12', 'AL-RTP2-FU1 Attribute 13', 'AL-RTP2-FU1 Attribute 14', 'AL-RTP2-FU1 Attribute 15', 'AL-RTP2-FU1 Attribute 16', 'AL-RTP2-FU1 Attribute 17', 'AL-RTP2-FU1 Attribute 18', 'AL-RTP2-FU1 Attribute 19', 'AL-RTP2-FU1 Attribute 20', 'AL-RTP2-FU1 Attribute 21', 'AL-RTP2-FU1 Attribute 22', 'AL-RTP2-FU1 Attribute 23', 'AL-RTP2-FU1 Attribute 24', 'AL-RTP2-FU1 Attribute 25', 'AL-RTP2-FU1 Attribute 26', 'AL-RTP2-FU1 Attribute 27', 'AL-RTP2-FU1 Attribute 28', 'AL-RTP2-FU1 Attribute 29', 'AL-RTP2-FU1 Attribute 30', 'AL-RTP2-FU1 Attribute 31', 'AL-RTP2-FU1 Attribute 32', 'AL-RTP2-FU1 Attribute 33', 'AL-RTP2-FU1 Attribute 34', 'AL-RTP2-FU1 Attribute 35', 'AL-RTP2-FU1 Attribute 36']    Fail

