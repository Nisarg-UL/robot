*** Settings ***
Documentation	SIS Regression TestSuite
Resource	../../../../resource/ApiFunctions.robot

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

4. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productevaluationsetup.json	${asset_Id_Product1}

5. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

6. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	Get AssesmentID	${asset_Id_Product1}

7. Requirement Assignment To Product
	[Tags]	Functional	POST	current
	Save Requirement	saverequirement_group1_01.json	${asset_Id_Product1}
	Save Requirement	saverequirement_group3_16.json	${asset_Id_Product1}

8. Get Assessment_ParamId
	[Tags]	Functional	GET	current
	Get Assesment_ParamID	${asset_Id_Product1}

9. Get Reviewer Summary Details
    [Tags]	Functional	GET	current
	${response}  Get Reviewer Summary Details For Multiple Subgroups    ${asset_Id_Product1}    ${assessmentId}
	run keyword if	${response[0]} != ""  Fail	test1 Teardown
    run keyword if	${response[1]} != "Group 1"  Fail	test1 Teardown
    run keyword if	${response[2]} != ""  Fail	test1 Teardown
    run keyword if	${response[3]} != "Test Case 1 - Implicit Pass and Fail - Short-circuit Functionality - Yes and No Functionality"  Fail	test1 Teardown
    run keyword if	${response[4]} != ""  Fail	test1 Teardown
    run keyword if	${response[5]} != ""  Fail	test1 Teardown
    run keyword if	${response[6]} != ""  Fail	test1 Teardown
    run keyword if	${response[7]} != {}  Fail	test1 Teardown
    run keyword if	${response[8]} != "${assessmentParamId}"  Fail	test1 Teardown
    run keyword if	${response[9]} != ""  Fail	test1 Teardown
    run keyword if	${response[10]} != "Group 3 - Data Linkage"  Fail	test1 Teardown
    run keyword if	${response[11]} != ""  Fail	test1 Teardown
    run keyword if	${response[12]} != "Test Case 16 - Integer Not Populated"  Fail	test1 Teardown
    run keyword if	${response[13]} != ""  Fail	test1 Teardown
    run keyword if	${response[14]} != ""  Fail	test1 Teardown
    run keyword if	${response[15]} != ""  Fail	test1 Teardown
    run keyword if	${response[16]} != {}  Fail	test1 Teardown
#    run keyword if	${response[17]} != "${assessmentParamId}"  Fail	test1 Teardown