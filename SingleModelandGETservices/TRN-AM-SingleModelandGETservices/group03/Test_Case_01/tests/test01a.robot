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

3. Get Asset Details
	[Tags]	Functional	certificate create	POST    current
	Details of an Asset  ${asset_Id_Product1}   ContentType=true&user=${user_id}
	${modelNomenclature}    get_values_from_list_of_dictionaries    ${Asset_attributes}    ${modelNomenclature_name}
	should be equal  ${modelNomenclature}   ["Regression_Test_Model_Nomenclature_1"]
