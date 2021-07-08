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
	Save Requirement	saverequirement_group8_12.json	${asset_Id_Product1}

8. Get Assessment_ParamId
	[Tags]	Functional	GET	current
	Get Assesment_ParamID	${asset_Id_Product1}

9. Render Verdict
	[Tags]	Functional	POST	current
	${response1}	Render Verdict  group08/Test_Case_34/case34a/inputrequest/request1.json	${asset_Id_Product1}
	run keyword if	${response1.status_code} != 200	Fail	test1 Teardown
	${result}  Get Guidance Notes AP1_2   ${response_api}
	run keyword if	'${result}' != '2000 characters o sit amet, consectetur adipiscing elit. Morbi volutpat eleifend suscipit. Integer eu ornare nisl. Nulla volutpat tellus et sem pulvinar, non auctor urna tempor. Maecenas nisi est, faucibus euismod leo ultricies, porttitor congue metus. Mauris ut urna nisi. Suspendisse at dapibus ipsum. Suspendisse bibendum mi vitae nibh lacinia dictum. Nam cursus mollis dignissim. Nunc nec mattis dui. Pellentesque in est lorem. Integer laoreet, velit et egestas porttitor, ex tortor fringilla eros, quis aliquam tortor nulla et felis. Vivamus dolor sapien, consectetur non vulputate rhoncus, tincidunt in eros. Nunc id tortor est. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Etiam lobortis justo quis tempus posuere. Praesent in malesuada tortor, eget rutrum lacus. Vestibulum ultricies diam ligula, eu luctus dui sollicitudin malesuada. In hac habitasse platea dictumst. Aenean malesuada orci vitae ante semper posuere. Vestibulum dictum, sem eu ullamcorper suscipit, eros dolor imperdiet nunc, vitae accumsan nulla velit eget velit. Proin a mattis dolor. Aliquam et malesuada ipsum. In posuere massa dui, ut vestibulum sem eleifend non. Quisque mauris odio, eleifend id tellus vestibulum, sollicitudin euismod nulla. Aliquam auctor dui eu erat lacinia volutpat. Sed tincidunt libero at tellus lobortis pulvinar. Duis a consequat lorem. Quisque sit amet metus id quam efficitur sodales et sed massa. Quisque quis vulputate ipsum. Maecenas a nisi eget augue pulvinar eleifend. Quisque leo nibh, aliquet eu convallis in, euismod vitae massa. Duis metus enim, imperdiet vel lacus vel, convallis maximus sapien. Suspendisse pulvinar hendrerit nunc ut bibendum. Sed pharetra scelerisque convallis. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Donec aliquet fermentum mi, nec blandit lacus fermentum a. Fusce ullamcorper leo nibh, quis pulvinar urna lobortis et. Aliquam vel sagittis dui. Name ultricies.'	Fail	test1 Teardown
	log to console  ${result}
	${response2}	Render Verdict	group08/Test_Case_34/case34a/inputrequest/request2.json	${asset_Id_Product1}
	run keyword if	${response2.status_code} != 200	Fail	test1 Teardown
	${clause}   has more clauses  ${response2.text}
	run keyword if  '${clause}' != 'False'  fatal error

10. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}
	${result}	Evaluation Summary	${asset_Id_Product1}
	run keyword if	'${result}' != '12 : PASS : Clause Group = l'	Fail	test1 Teardown
	log to console	Result - ${result} (Implicit)