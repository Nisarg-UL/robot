*** Settings ***
Documentation	Multimodel Regression TestSuite
Resource    ../../../resource/ApiFunctions.robot

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
    set global variable     ${Product_Collection_Id}    ${Collection_Id}

4. Asset2 Creation with POST Request
    [Tags]	Functional	asset	create	POST    current
    create Asset2 based on product1 Asset1   CreationOfRegressionProduct1Asset2_siscase1_withCol_ID.json

5. Validate above Asset's part of same collection
    [Tags]	Functional	GET    current
    ${response}  Get Collection Asset Link  ${Collection_Id}
    run keyword if  ${response} != (('${asset_Id_Product1}',), ('${asset_Id_Product12}',))    Fail	test1 Teardown

6. Lock the collection
    [Tags]	Functional	current
    ${response}  Lock Collection    Lock_Template.json    ${Collection_Id}
    run keyword if  ${response._content} != {"apiversion":"${Api_ver}","code":200,"status":"OK","message":"OK","data":{"id":"${Collection_Id}","status":"Collection locked successfully"}}  Fail	test1 Teardown
    log to console  ${response._content}

7. Unlock Asset
    [Tags]	Functional	current
    ${response}  Unlock Asset    Unlock_Template.json    ${asset_Id_Product1}
    run keyword if  ${response._content} != {"apiversion":"${Api_ver}","code":200,"status":"OK","message":"OK","data":{"id":"${asset_Id_Product1}","status":"Asset un-locked successfully"}}  Fail	test1 Teardown
    log to console  ${response._content}

8. Unlock Collection
    [Tags]	Functional	current
    ${response}  Unlock Collection    Unlock_Template_emptyUser.json    ${Collection_Id}
    run keyword if  ${response._content} != {"apiversion":"${Api_ver}","code":200,"status":"OK","message":"OK","data":{"id":"${Collection_Id}","status":"Collection un-locked successfully"}}  Fail	test1 Teardown
    log to console  ${response._content}

