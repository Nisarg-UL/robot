*** Settings ***
Documentation	Reference Data Consumption TestSuite
Resource	../../../resource/ApiFunctions.robot
Suite Setup  Link RegSchemeScopeProd1 & Reg2SchemeScope2Prod2
Suite Teardown  Unlink RegSchemeScopeProd1 & Reg2SchemeScope2Prod2

*** Keywords ***

*** Test Cases ***
1a. Role Access Configuration With POST Request
	[Tags]	Functional	POST    current
    Configure Role Access    Certificate/ConfigureRole_Public_RefAttributes_forRegScheme.json   Certificate
    should be equal  ${access_role}   Public

1. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    create product1 asset	CreationOfRegressionProduct1_siscase1.json

2. Check Asset State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

3. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productnoevalreqd.json	${asset_Id_Product1}

4. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

5. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${assessmentId}  Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId}	${assessmentId}

6. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}

7. Check Asset State After Evaluation
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'immutable'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

8. Certificate Creation
	[Tags]	Functional	certificate	create	POST    current
    create certificate   Certificate/CreationOfRegressionSchemeCertificate_withReferenceAttributes.json

9. Get certificate Details
    [Tags]	Functional	certificate    current
    Get certificate Details using Mode     ${Certificate_Id}    edit
    should not be empty  ${cert_ref_attr}
    length should be  ${cert_ref_attr}   2

10. Edit certificate
    [Tags]	Functional	certificate create	POST    current
    edit certificate  Certificate/EditOfRegressionSchemeCertificate_attribute&ReferenceAttributes.json    ${Certificate_Id}

11. Validate Certificate Reference Attributes
    [Tags]	Functional	certificate    current
    Validate Certificate Reference Attributes   ${Certificate_Id_Edit}
    should be empty  ${ref_attr_errors}

12. Certification Mark
    [Tags]	Functional	certificate create	current
    ${Result}   Certificate Mark
    log to console  ${Result}
    run keyword if  ${Result} != "Recognized"      Fail    test1 Teardown

13. Get certificate Details
    [Tags]	Functional	certificate    current
    Get certificate Details using Mode     ${Certificate_Id_Edit}    edit
    should not be empty  ${cert_ref_attr}
    length should be  ${cert_ref_attr}   2

14. Disfigure Role With POST Request
	[Tags]	Functional	POST    current
    Disfigure Role Access    Certificate/DisfigureRole_Public_RefAttributes_forRegScheme.json   Certificate
    should be equal  ${access_role}   Public
