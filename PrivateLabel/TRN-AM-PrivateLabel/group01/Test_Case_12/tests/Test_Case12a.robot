*** Settings ***
Documentation	Private Label TestSuite
Resource	../../../resource/ApiFunctions.robot
Suite Setup  Link RegressionScheme-Scope-Product1
Suite Teardown  Unlink Scheme Scope    Unlink_ScopeScheme.json

*** Keywords ***
test1 Teardown
	Log To Console	test1a Teardown Beginning
	Expire The Asset	${asset_Id_Product1}
	Log To Console	test1a Teardown Finished

*** Test Cases ***
1. Create Private Label
    [Tags]	Functional	certificate	PL  create	POST    current
    run keyword and ignore error    Create private label    Private_Label/CreationOfPL_RegressionSchemeCert_withFalseBaseCertificateparameters.json
    ${response}  Get Error Message  ${response_api}
    log to console  ${response}
    run keyword if  "${response}" != "Certificate doesn't exists for the given unique certificate identifiers"   Fail	test1 Teardown