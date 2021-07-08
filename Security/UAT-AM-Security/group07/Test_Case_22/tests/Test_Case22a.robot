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
    Configure Role Access    Product/ConfigureRole_Owner_forProduct1.json   Asset
    should be equal  ${access_role}   Owner

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

9. Get Asset Details using UserId
	[Tags]	Functional	certificate create	POST    current
	Get Asset Details using UserId     ${asset_Id_Product1}   ${EMPTY}
	should be empty   ${Asset_attr}
    run keyword if  "${Asset_Collection_Id}" != "${Collection_Id}"     Fail

10. Disfigure Role With POST Request
	[Tags]	Functional	POST    current
    Disfigure Role Access    Product/DisfigureRole_Owner_forProduct1.json   Asset
    should be equal  ${access_role}   Owner