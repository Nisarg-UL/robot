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

1. Asset1 Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    create product1 asset	CreationOfRegressionProduct1_siscase1.json

2. Check for Asset1 State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_Asset_State": ${state}

3. Get the Colletion_ID
    [Tags]	Functional	current
    Get Collection_ID   ${asset_Id_Product1}
    set global variable     ${Product_Collection_Id}    ${Collection_Id}

4. Validate above Asset1's part of same collection
    [Tags]	Functional	GET    current
    ${response}  Get Collection Asset Link  ${Collection_Id}
    run keyword if  ${response} != (('${asset_Id_Product1}',),)    Fail	test1 Teardown

5. Asset2 Creation with POST Request
    [Tags]	Functional	asset	create	POST    current
    create Asset2 based on product1 Asset1   CreationOfRegressionProduct1Asset2_siscase1_withCol_ID.json

6. Validate above Asset2's part of same collection
    [Tags]	Functional	GET    current
    ${response}  Get Collection Asset Link  ${Collection_Id}
    run keyword if  ${response} != (('${asset_Id_Product1}',), ('${asset_Id_Product12}',))    Fail	test1 Teardown

7. Asset3 Creation with POST Request
    [Tags]	Functional	asset	create	POST    current
    create Asset3 based on product1 Asset1   CreationOfRegressionProduct1Asset3_siscase1_withCol_ID.json

8. Validate above Asset3's part of same collection
    [Tags]	Functional	GET    current
    ${response}  Get Collection Asset Link  ${Collection_Id}
    run keyword if  ${response} != (('${asset_Id_Product1}',), ('${asset_Id_Product12}',), ('${asset_Id_Product13}',))    Fail	test1 Teardown

9. Asset4 Creation with POST Request
    [Tags]	Functional	asset	create	POST    current
    create Asset4 based on product1 Asset1   CreationOfRegressionProduct1Asset4_siscase1_withCol_ID.json

10. Validate above Asset4's part of same collection
    [Tags]	Functional	GET    current
    ${response}  Get Collection Asset Link  ${Collection_Id}
    run keyword if  ${response} != (('${asset_Id_Product1}',), ('${asset_Id_Product12}',), ('${asset_Id_Product13}',), ('${asset_Id_Product14}',))    Fail	test1 Teardown

11. Asset5 Creation with POST Request
    [Tags]	Functional	asset	create	POST    current
    create Asset5 based on product1 Asset1   CreationOfRegressionProduct1Asset5_siscase1_withCol_ID.json

12. Validate above Asset5's part of same collection
    [Tags]	Functional	GET    current
    ${response}  Get Collection Asset Link  ${Collection_Id}
    run keyword if  ${response} != (('${asset_Id_Product1}',), ('${asset_Id_Product12}',), ('${asset_Id_Product13}',), ('${asset_Id_Product14}',), ('${asset_Id_Product15}',))    Fail	test1 Teardown

13. Validate and Update Compliance Collection Level
    [Tags]	Functional	current
    ${result}    Validate and Update Compliance Collection Level  Update_ComplianceAll.json  ${collection_Id}
	run keyword if	'${result}' != 'successfully validated'	Fail	test1a Teardown
	should not be empty  ${Validation_Errors}
	${msg}  Get Validation Error for Update Compliance Collection Level   ${response_api}    ${asset_Id_Product1}
	run keyword if  '${msg}' != 'No evaluation added for the model'  Fail	test1 Teardown
	log to console  ${msg}
    ${msg2}  Get Validation Error for Update Compliance Collection Level   ${response_api}    ${asset_Id_Product12}
	run keyword if  '${msg2}' != 'No evaluation added for the model'  Fail	test1 Teardown
	log to console  ${msg2}
	${msg3}  Get Validation Error for Update Compliance Collection Level   ${response_api}    ${asset_Id_Product13}
	run keyword if  '${msg3}' != 'No evaluation added for the model'  Fail	test1 Teardown
	log to console  ${msg3}
	${msg4}  Get Validation Error for Update Compliance Collection Level   ${response_api}    ${asset_Id_Product14}
	run keyword if  '${msg4}' != 'No evaluation added for the model'  Fail	test1 Teardown
	log to console  ${msg4}
	${msg5}  Get Validation Error for Update Compliance Collection Level   ${response_api}    ${asset_Id_Product15}
	run keyword if  '${msg5}' != 'No evaluation added for the model'  Fail	test1 Teardown
	log to console  ${msg5}
