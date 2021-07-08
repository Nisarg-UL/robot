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

1. Role Access Configuration With POST Request
	[Tags]	Functional	POST    current
    Configure Role Access    Product/ConfigureRole_Public_forProduct1.json   Asset
    should be equal  ${access_role}   Public

2. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    create product1 asset	CreationOfRegressionProduct1_siscase1.json

3. Check Asset State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

4. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productnoevalreqd.json	${asset_Id_Product1}

5. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

6. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${assessmentId}  Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId}	${assessmentId}

7. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}

8. Check Asset State After Evaluation
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'immutable'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

9. Get Asset Details using UserId & Role
	[Tags]	Functional	certificate create	POST    current
	Get Asset Details using UserId & Role     ${asset_Id_Product1}   ${user_id}  Applicant
	should not be empty   ${Asset_attr}
    run keyword if  "${Asset_Collection_Id}" != "${Collection_Id}"     Fail
    ${attr_names}	get_attribute_names  ${Asset_attr}   name
    Compare lists    ${attr_names}   ['Product Type', 'Owner Reference (Party Site ID)', 'Reference Number', 'Family / Series', 'Model Name', 'Creation Date', 'TP1 Attribute 1', 'TP1 Attribute 2', 'TP1 Attribute 3', 'TP1 Attribute 4', 'TP1 Attribute 5', 'TP1 Attribute 6', 'TP1 Attribute 7', 'TP1 Attribute 8', 'TP1 Attribute 9', 'TP1 Attribute 10', 'TP1 Attribute 11', 'TP1 Attribute 12', 'TP1 Attribute 13', 'TP1 Attribute 14', 'TP1 Attribute 15', 'TP1 Attribute 16', 'TP1 Attribute 17', 'TP1 Attribute 18', 'TP1 Attribute 19', 'TP1 Attribute 20', 'TP1 Attribute 21', 'TP1 Attribute 22', 'TP1 Attribute 23', 'TP1 Attribute 24', 'TP1 Attribute 25', 'TP1 Attribute 25', 'TP1 Attribute 25', 'TP1 Attribute 26', 'TP1 Attribute 26', 'TP1 Attribute 26', 'TP1 Attribute 27', 'TP1 Attribute 28', 'TP1 Attribute 29', 'TP1 Attribute 30', 'TP1 Attribute 31', 'TP1 Attribute 32', 'TP1 Attribute 32', 'TP1 Attribute 33', 'TP1 Attribute 33', 'TP1 Attribute 34', 'TP1 Attribute 34', 'TP1 Attribute 35', 'TP1 Attribute 35', 'TP1 Attribute 36', 'TP1 Attribute 36', 'TP1 Attribute 38', 'TP1 Attribute 40', 'TP1 Attribute 40', 'TP1 Attribute 42', 'TP1 Attribute 42', 'TP1 Attribute 42', 'TP1 Attribute 44', 'TP1 Attribute 46', 'TP1 Attribute 49', 'TP1 Attribute 51', 'TP1 Attribute 51', 'TP1 Attribute 53', 'TP1 Attribute 53', 'TP1 Attribute 53', 'TP1 Attribute 55', 'TP1 Attribute 55', 'TP1 Attribute 57', 'TP1 Attribute 57', 'TP1 Attribute 57', 'TP1 Attribute 62', 'TP1 Attribute 62', 'TP1 Attribute 63', 'TP1 Attribute 63', 'TP1 Attribute 63', 'TP1 Attribute 64', 'TP1 Attribute 64', 'TP1 Attribute 64', 'TP1 Attribute 65', 'TP1 Attribute 65', 'TP1 Attribute 65', 'TP1 Attribute 66', 'TP1 Attribute 66', 'TP1 Attribute 67', 'TP1 Attribute 68', 'TP1 Attribute 69', 'TP1 Attribute 69', 'TP1 Attribute 70', 'TP1 Attribute 70', 'TP1 Attribute 71', 'TP1 Attribute 71', 'TP1 Attribute 72', 'TP1 Attribute 73', 'metadataId', 'CCN', 'Collection Name', 'Order Number', 'Project Number', 'Quote Number', 'Shared Attribute 1', 'Shared Attribute 2', 'Shared Attribute 3', 'Shared Attribute 4', 'Shared Attribute 5', 'Shared Attribute 6', 'Shared Attribute 7', 'Shared Attribute 8', 'Shared Attribute 9', 'Shared Attribute 10', 'Shared Attribute 11', 'Shared Attribute 12']

10. Disfigure Role With POST Request
	[Tags]	Functional	POST    current
    Disfigure Role Access    Product/DisfigureRole_Public_forProduct1.json   Asset
    should be equal  ${access_role}   Public
