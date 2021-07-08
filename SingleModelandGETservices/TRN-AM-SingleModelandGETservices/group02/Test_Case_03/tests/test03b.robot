*** Settings ***
Documentation	SingleModel TestSuit
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***

*** Test Cases ***
1. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    create product1 asset	CreationOfRegressionProduct1_siscase1.json

2. Check Asset State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

3. Product 2 Asset1 Creation based on product1 Asset1
    [Tags]	Functional	asset	create	POST    current
    create product2 asset   CreationOfRegressionProduct2_siscase1.json
    set global variable  ${Component_ID}    ${asset_Id_Product2}

4. Check for Asset State
	[Tags]	Functional	current
	${state}=	Get Asset State	${Component_ID}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Component_Asset_State": ${state}

5. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productnoevalreqd.json	${Component_ID}

6. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${Component_ID}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

7. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${assessmentId}  Get AssesmentID	${Component_ID}
	set global variable	${assessmentId}	${assessmentId}

8. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${Component_ID}
	Complete Evaluation	markcollectioncomplete.json	${Component_ID}

9. Check Asset State After Evaluation
	[Tags]	Functional	current
	${state}=	Get Asset State	${Component_ID}
	run keyword if	'${state}' != 'immutable'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

10. Link Product2 to Product 1
    [Tags]	Functional	current
    ${result}   Link Components to Asset    Link_Product1toComponent1withoutLinkageDetails.json     ${asset_Id_Product1}
	set global variable	${assetLinkSeqId}	${result.json()["data"]["hasComponents"][0]["assetAssetLinkSeqId"]}
	should not be empty  ${assetLinkSeqId}
	log to console  ${assetLinkSeqId}

11. Get Component details
	[Tags]	Functional	certificate create	POST    current
	Get Component Details   ${asset_Id_Product1}   user=81349
	should not be empty   ${components}
    run keyword if  "${comp_asset_id}" != "${Component_ID}"     Fail
    ${al_names}	get_asset_linkage_names  ${components}   ${Component_ID}   name
    run keyword if  ${al_names} != ['Functional Use', 'Component Name', 'AL-RTP2-FU1 Attribute 1', 'AL-RTP2-FU1 Attribute 2', 'AL-RTP2-FU1 Attribute 3', 'AL-RTP2-FU1 Attribute 4', 'AL-RTP2-FU1 Attribute 5', 'AL-RTP2-FU1 Attribute 6', 'AL-RTP2-FU1 Attribute 7', 'AL-RTP2-FU1 Attribute 8', 'AL-RTP2-FU1 Attribute 9', 'AL-RTP2-FU1 Attribute 10', 'AL-RTP2-FU1 Attribute 11', 'AL-RTP2-FU1 Attribute 12', 'AL-RTP2-FU1 Attribute 13', 'AL-RTP2-FU1 Attribute 14', 'AL-RTP2-FU1 Attribute 15', 'AL-RTP2-FU1 Attribute 16', 'AL-RTP2-FU1 Attribute 17', 'AL-RTP2-FU1 Attribute 18', 'AL-RTP2-FU1 Attribute 19', 'AL-RTP2-FU1 Attribute 20', 'AL-RTP2-FU1 Attribute 21', 'AL-RTP2-FU1 Attribute 22', 'AL-RTP2-FU1 Attribute 23', 'AL-RTP2-FU1 Attribute 24', 'AL-RTP2-FU1 Attribute 25', 'AL-RTP2-FU1 Attribute 26', 'AL-RTP2-FU1 Attribute 27', 'AL-RTP2-FU1 Attribute 28', 'AL-RTP2-FU1 Attribute 29', 'AL-RTP2-FU1 Attribute 30', 'AL-RTP2-FU1 Attribute 31', 'AL-RTP2-FU1 Attribute 32', 'AL-RTP2-FU1 Attribute 33', 'AL-RTP2-FU1 Attribute 34', 'AL-RTP2-FU1 Attribute 35', 'AL-RTP2-FU1 Attribute 36', 'AL-RTP2-FU1 Attribute 37', 'AL-RTP2-FU1 Attribute 38', 'AL-RTP2-FU1 Attribute 39', 'AL-RTP2-FU1 Attribute 40', 'AL-RTP2-FU1 Attribute 41', 'AL-RTP2-FU1 Attribute 42', 'AL-RTP2-FU1 Attribute 43', 'AL-RTP2-FU1 Attribute 44']    Fail
    ${al_displaynames}	get_asset_linkage_names  ${components}   ${Component_ID}   displayName
    run keyword if  ${al_displaynames} != ['Functional Use', 'Component Name', 'Mask for AL-RTP2-FU1 Att 1', 'Mask for AL-RTP2-FU1 Att 2', 'Mask for AL-RTP2-FU1 Att 3', 'Mask for AL-RTP2-FU1 Att 4', 'Mask for AL-RTP2-FU1 Att 5', 'Mask for AL-RTP2-FU1 Att 6', 'Mask for AL-RTP2-FU1 Att 7', 'Mask for AL-RTP2-FU1 Att 8', 'Mask for AL-RTP2-FU1 Att 9', 'Mask for AL-RTP2-FU1 Att 10', 'Mask for AL-RTP2-FU1 Att 11', 'Mask for AL-RTP2-FU1 Att 12', 'Mask for AL-RTP2-FU1 Att 13', 'Mask for AL-RTP2-FU1 Att 14', 'Mask for AL-RTP2-FU1 Att 15', 'Mask for AL-RTP2-FU1 Att 16', 'Mask for AL-RTP2-FU1 Att 17', 'Mask for AL-RTP2-FU1 Att 18', 'Mask for AL-RTP2-FU1 Att 19', 'Mask for AL-RTP2-FU1 Att 20', 'Mask for AL-RTP2-FU1 Att 21', 'Mask for AL-RTP2-FU1 Att 22', 'Mask for AL-RTP2-FU1 Att 23', 'Mask for AL-RTP2-FU1 Att 24', 'Mask for AL-RTP2-FU1 Att 25', 'Mask for AL-RTP2-FU1 Att 26', 'Mask for AL-RTP2-FU1 Att 27', 'Mask for AL-RTP2-FU1 Att 28', 'Mask for AL-RTP2-FU1 Att 29', 'Mask for AL-RTP2-FU1 Att 30', 'Mask for AL-RTP2-FU1 Att 31', 'Mask for AL-RTP2-FU1 Att 32', 'Mask for AL-RTP2-FU1 Att 33', 'Mask for AL-RTP2-FU1 Att 34', 'Mask for AL-RTP2-FU1 Att 35', 'Mask for AL-RTP2-FU1 Att 36', 'Mask for AL-RTP2-FU1 Att 37', 'Mask for AL-RTP2-FU1 Att 38', 'Mask for AL-RTP2-FU1 Att 39', 'Mask for AL-RTP2-FU1 Att 40', 'Mask for AL-RTP2-FU1 Att 41', 'Mask for AL-RTP2-FU1 Att 42', 'Mask for AL-RTP2-FU1 Att 43', 'Mask for AL-RTP2-FU1 Att 44']    Fail

