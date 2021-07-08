*** Settings ***
Documentation	Multimodel Regression TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***
test1 Teardown
	Log To Console	test1a Teardown Beginning
	Expire The Asset	${asset_Id_Product1}
	Log To Console	test1a Teardown Finished

*** Test Cases ***
1. Validate Master Asset Template
	[Tags]	Functional	Test	GET    current
    ${coll_attr}     Get Collection Attributes       Regression%20test%20Product%201
    Compare lists   ${coll_attr}  ["Quote Number", "Order Number", "Collection Name", "Project Number"]
    ${shared_attr}     Get Shared Attributes       Regression%20test%20Product%201
    Compare lists   ${shared_attr}   ["Shared Attribute 10", "Shared Attribute 7", "Shared Attribute 11", "Shared Attribute 2", "Shared Attribute 9", "Shared Attribute 8", "Shared Attribute 3", "Shared Attribute 12", "Shared Attribute 4", "Shared Attribute 5", "Shared Attribute 1", "Shared Attribute 6"]
