*** Settings ***
Documentation	Reference Data Consumption TestSuite
Resource	../../../resource/ApiFunctions.robot
Suite Setup  Link RegressionScheme-Scope-Product1
Suite Teardown  Unlink Scheme Scope    Unlink_ScopeScheme.json

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

9. Link Product to Certificate
    [Tags]	Functional	certificate	create	POST    current
    ${Trans_Id1}     Get Certificate TransactionId using Certificate Details  ${Certificate_Name}    ${Cert_Owner_Ref}  ${scheme}
    set global variable	${Cert_Transaction_Id}	${Trans_Id1}
    log to console	"Transaction ID": ${Cert_Transaction_Id}
    ${response}  Get ULAssetID   ${asset_Id_Product1}
    set global variable	${ul_asset_Id}	${response}
    Add Assets to Certificate  Certificate/Link_Product1_Eval1_RegressionCertificate.json    ${Certificate_Id}

10. Unlink Scheme Scope ProductType
    [Tags]	Functional	current
    Unlink Scheme Scope ProductType    Unlink_SchemeScopeProductType.json

11. Validate Certificate Reference Attributes
    [Tags]	Functional	certificate    current
    Validate Certificate Reference Attributes   ${Certificate_Id}
    ${error_msg}    cert_ref_attributes_errors_msg  ${ref_attr_errors}   Regression_Test_Model_1_${current_time}
    run keyword if  '${error_msg}' != 'Product Type for the model is no longer valid. Unlink the model to proceed.'     Fail

12. Get Reference Attributes Details from ref_attributes Table
    [Tags]	Functional	certificate  current
	Get Reference Attributes from ref_attributes Table     ${Certificate_Id}
    run keyword if  '${Ref_attr_names}' != 'Certification Product Type, Standard'     Fail
    ${pk1}   Get Primary Keys from ref_attributes Table   ${Certificate_Id}  1
    run keyword if  '${pk1}' != '${scope_Id}, ${Validation_standard_Id}'     Fail
    ${pk2}   Get Primary Keys from ref_attributes Table   ${Certificate_Id}  2
    run keyword if  '${pk2}' != '${Regression_schemeScopeId}, ${Validation_standardLabel_Id}'     Fail
    ${pk3}   Get Primary Keys from ref_attributes Table   ${Certificate_Id}  3
    run keyword if  '${pk3}' != '${RegVal_schemeScopeStandardId}'     Fail
    Get version from ref_attributes Table     ${Certificate_Id}
    run keyword if  '${Ref_attr_ver}' != '1.0, 1.0'     Fail