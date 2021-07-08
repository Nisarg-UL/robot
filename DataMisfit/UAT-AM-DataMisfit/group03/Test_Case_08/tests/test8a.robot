*** Settings ***
Documentation	Data Misfit TestSuite
Resource	../../../resource/ApiFunctions.robot

*** Keywords ***
test1 Teardown
	Log To Console	test1a Teardown Beginning
	Expire The Asset	${asset_Id_Product1}
	Log To Console	test1a Teardown Finished

*** Test Cases ***
1a. Setting up Environment
	set global variable	${asset_Id_Product1}

1. End Date Misfit Testing PET_V2
	[Tags]	Functional	POST	current
	Expire PET   ${data_misfit_testing_v2_hierarchy_Id}

2. Post Date Misfit Testing PET_V1
	[Tags]	Functional	POST	current
	Activate PET   ${data_misfit_testing_v1_hierarchy_Id}

3. Asset Creation With POST Request
	[Tags]	Functional	asset	Test	create	POST    current
    create product1 asset	group03/Test_Case_08/inputrequest/CreateProduct1.json

4. Check for Asset State
	[Tags]	Functional	current
	${state}=	Get Asset State	${asset_Id_Product1}
	run keyword if	'${state}' != 'scratchpad'	Fail	test1a Teardown
	log to console	"Product_Asset_State": ${state}

5. Get the Colletion_ID
    [Tags]	Functional	current
    Get Collection_ID   ${asset_Id_Product1}
    set global variable  ${product_collection_id}   ${collection_id}

6. Validate above Asset's part of same collection
    [Tags]	Functional	GET    current
    ${response}  Get Collection Asset Link  ${Collection_Id}
    run keyword if  ${response} != (('${asset_Id_Product1}',), )    Fail	test1 Teardown

7. Standard Assignment To Product (Product Evaluation Set Up)
	[Tags]	Functional	POST	current
	standard assignment	productnoevalreqd.json	${asset_Id_Product1}

8. Get AssessmentId with Get Standards Associated With an Asset API
	[Tags]	Functional	GET	current
	${response}  Get AssesmentID	${asset_Id_Product1}
	set global variable	${assessmentId}     ${response}
	set global variable	${assessmentId1}	${assessmentId}

9. Complete Evaluation
	[Tags]	Functional	POST	current
	Complete Evaluation	markevaluationcomplete.json	${asset_Id_Product1}
	Complete Evaluation	markcollectioncomplete.json	${asset_Id_Product1}

10. End Date Misfit Testing PET_V1
	[Tags]	Functional	POST	current
	Expire PET   ${data_misfit_testing_v1_hierarchy_Id}

11. Post Date Misfit Testing PET_V2
	[Tags]	Functional	POST	current
	Activate PET   ${data_misfit_testing_v2_hierarchy_Id}

12. View Asset Details
	[Tags]	Functional	POST	current
    Get Asset Details   ${asset_Id_Product1}

13. Modify Product1
	[Tags]	Functional	POST	current
    Modify Product1 Asset   group03/Test_Case_08/inputrequest/ModifyProduct1.json    ${asset_Id_Product1}

14. Get Details of an Asset for Content Type
	[Tags]	Functional	POST	current
    ${response}     Details of an Asset for Content Type     ${asset_Id_Product12}
    set test variable	${card_change_cont1}	${response["data"]["attributes"][0]["value"]}
	run keyword if  '${card_change_cont1}' != 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam est lectus, auctor in justo a, gravida pellentesque neque. Curabitur nec massa metus.'  Fail	test1 Teardown
	set test variable	${card_change_cont2}	${response["data"]["attributes"][1]["value"]}
	run keyword if  '${card_change_cont2}' != 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam est lectus, auctor in justo a, gravida pellentesque neque. Curabitur nec massa metus. Lorem ipsum'  Fail	test1 Teardown
	set test variable	${card_change_cont3}	${response["data"]["attributes"][2]["value"]}
	run keyword if  '${card_change_cont3}' != 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce sed efficitur ex. In porttitor sed velit id porta. Donec rutrum dictum est ut sollicitudin. Pellentesque libero nibh, pretium ut elementum sit amet, convallis ac enim. Vivamus nec congue est, quis porta ex. Quisque urna dolor, dapibus tincidunt mauris quis, consequat sagittis mi. Etiam eget elit id urna luctus placerat eget nec massa. Donec at lorem nulla. Proin ultrices quis nisl consequat vulputate. Vestibulum euismod cursus eros, id posuere est. Phasellus turpis ex, pretium at tortor quis, maximus laoreet erat. Nunc lacinia ex quis augue gravida, quis mattis purus semper. Proin in tellus quam. Suspendisse ut feugiat purus. Suspendisse iaculis eros eget sollicitudin tincidunt. Curabitur ac eros vitae justo porttitor maximus sit amet vel sapien. Nam nec erat facilisis, interdum sem imperdiet, accumsan ipsum. Aenean venenatis nulla non lectus consectetur sollicitudin. Pellentesque pellentesque, arcu vel pharetra iaculis, turpis ex placerat odio, vitae imperdiet neque ligula a metus. Proin eu magna ornare, elementum ligula eget, placerat dolor. Pellentesque consectetur a nibh auctor porttitor. Duis tristique felis metus, eget ultricies est tempor quis. Aliquam condimentum, sem sit amet vehicula tincidunt, est nulla suscipit mauris, nec semper leo augue sit amet enim. Donec augue lectus, bibendum a sapien eget, consectetur imperdiet mi. In at elit non lorem hendrerit feugiat. Etiam aliquam enim arcu, nec imperdiet odio eleifend id. Ut eget varius enim, sit amet vehicula est. Morbi at dictum arcu, non feugiat arcu. Sed dignissim ultrices justo, sit amet ornare dui congue et. Maecenas eleifend mattis dignissim. Aenean bibendum rutrum pellentesque. Proin quis efficitur lorem. Morbi gravida tellus non rhoncus hendrerit. Aliquam placerat, risus a placerat aliquam, mi eros auctor ligula, sit amet tristique velit magna nec arcu. Pellentesque id vulputate eros. Sed malesuada lobortis orci, non viverra ante volutpa'  Fail	test1 Teardown

