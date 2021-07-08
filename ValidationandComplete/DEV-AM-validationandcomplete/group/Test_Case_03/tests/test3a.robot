*** Settings ***
Documentation	Validation and Complete TestSuite
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
    ${File}=	GET FILE    input/CreationOfRegressionProduct1_siscase1withemptytaxonomy.json
    ${File1}	extract and replace random owner ref	${File}
    ${FILE2}	extract and replace date	${File1}
    ${JSON}	replace variables	${FILE2}
    ${headers}=	Create Dictionary	Content-Type=application/json
    Create Session	thePost	${API_ENDPOINT}	headers=${headers}
    ${response}=	Post Request	thePost	/assets/createAssetDetails	${JSON}
    log to console  ${response.text[54:-2]}
    pass execution if  '${response}' == '400'   Estimated test failure






