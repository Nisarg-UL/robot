*** Settings ***
Documentation	SingleModel TestSuit
Resource	../../../resource/ApiFunctions.robot
Suite Setup  Link RegressionScheme-Scope-Product1
Suite Teardown  Unlink Scheme Scope    Unlink_ScopeScheme.json

*** Keywords ***

*** Test Cases ***
1. Role Access Configuration With POST Request
	[Tags]	Functional	POST    current
    Configure Role Access    Certificate/ConfigureRole_Public_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Public

2. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    create product1 asset	CreationOfRegressionProduct1_siscase1.json

3. Check for Asset State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_Asset_State": ${state}

4. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productnoevalreqd.json	${asset_Id_Product1}

5. Check Asset State After Associating Standard to Product
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'associated'	Fail	test1a Teardown
	log to console	"Product_State after Standard Assigned To Product": ${state}

6. Certificate creation
	[Tags]	Functional	certificate create	POST    current
    create certificate   Certificate/CreationOfRegressionSchemeCertificate_withReferenceAttributes.json

7. Get Certificate details using UserId
	[Tags]	Functional	certificate create	POST    current
	Get certificate Details using UserId     ${Certificate_Id}   81349
    should not be empty   ${cert_attr}
    ${attr_name}	get_attribute_names  ${cert_attr}   name
    run keyword if  ${attr_name} != ['Certificate Type', 'Issuing Body', 'Mark', 'Certificate Name', 'Owner Reference', 'Certification Scheme Owner', 'Model Numbers', 'Certification Scheme Product Type', 'Certification Scheme Product Type Code', 'Standard Number', 'Standard Code', 'Standard Detail', 'Standard Description', 'CCN', 'Complementary CCN', 'IR Reference', 'TGA Reference', 'Footnote Symbol', 'Footnote Text', 'Test Date', 'metadataId', 'Revision Number', 'Electrical Efficiency Rated', 'Energy Efficiency Rating']     Fail
    run keyword if  ${Cert_status} != "Under Revision"     Fail
    ${attr_name}	get_attribute_names  ${cert_attr}   displayName
    run keyword if  ${attr_name} != ['Certification Scheme', 'Certification Body', 'Mark', 'Certificate Name', 'Owner Reference', 'Certification Scheme Owner', 'Model Numbers', 'Certification Scheme Product Type', 'Certification Scheme Product Type Code', 'Standard Number', 'Standard Code', 'Standard Detail', 'Standard Description', 'CCN', 'Complementary CCN', 'IR Reference', 'TGA Reference', 'Footnote Symbol', 'Footnote Text', 'Test Date', 'Revision Number', 'Electrical Efficiency Rated', 'Energy Efficiency Rating']     Fail
    run keyword if  ${Cert_status} != "Under Revision"     Fail

8. Disfigure Role With POST Request
	[Tags]	Functional	POST    current
    Disfigure Role Access    Certificate/DisfigureRole_Public_forRegressionScheme.json   Certificate
    should be equal  ${access_role}   Public