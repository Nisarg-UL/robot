*** Settings ***
Library	HttpLibrary.HTTP
Library	OperatingSystem
Library	urllib2
Library	../resource/RequestsKeywords.py
Library	../resource/JParser.py
Library	../resource/FileExtractor.py
Library	../resource/Database.py
Library	../resource/Linkage.py
Library	json
Library	DatabaseLibrary
Library	pymysql
Library	../resource/RegExp.py
Library  Collections


*** Variables ***
${API_ENDPOINT}	https://dev.informationplatform.ul.com/InformationPlatformServices/api/v${Api_ver}	#For DEV

@{database}  pymysql    infopltfrm_transDBv07  ul_transUser    29LPMW6Ljv  usnbkinpt018d.global.ul.com    3316	#DB for DEV

${db}         @{database}[1]
${user}       @{database}[2]
${pass_wd}    @{database}[3]
${host}       @{database}[4]
${port}       @{database}[5]

${Api_ver}  5.23

${certificate_hierarchy_Id}     35072a92-ccd3-49d8-8705-d02bc37d1008           #for DEV
${certificate2_hierarchy_Id}    c8ef6737-3597-443e-979c-b3d3fde0b426           #for DEV
#${certificate3_hierarchy_Id}                                                  #for DEV
${certificate_metadataId}       3596aa8b-c7af-4bef-9643-0dcb064d30bb           #for DEV
${certificate2_metadataId}      74ed5969-ae09-45ba-8ad0-235eb5eb6cf8           #for DEV
#${certificate3_metadataId}                                                    #for DEV
${standard_hierarchy_Id}	cee668aa-cfda-4191-8d55-b4c0ead85da3               #for DEV - with clause group
${standard_hierarchy_Id}	14f8ddd8-afa2-48f4-8234-88698628c44c               #for DEV - no clause group
${Reg_prod1_metadataId} 	930d2a66-0594-4735-82a2-9253401b0443               #for DEV
${Reg_prod2_metadataId} 	e71b801d-a53e-42d7-9610-e4f2bc941bb5               #for DEV
${Reg_prod3_metadataId} 	f20fb627-b719-4364-af6e-484f1972075e               #for DEV
${noEvalReqd_hierarchy_Id}     cee668aa-cfda-4191-8d55-b4c0ead85da3            #for DEV
${regression_product_1_hierarchy_id}    561cab90-43ec-4472-92c1-091bebe4cb80   #for DEV
${regression_product_2_hierarchy_id}    fe4b0025-f555-455d-ae9f-b264e78300dd   #for DEV
${regression_product_3_hierarchy_id}    349ab8bb-63e6-457b-a115-a19539502878   #for DEV
${certificate_hierarchy_IdV2.1}     6b6db87e-3115-4455-8ad3-f874e896a977       #for DEV
${certificate_metadataIdV2.1}       ee7c7e90-b095-49a0-8335-cea95f2339ab       #for DEV
${certificate_hierarchy_IdV2.2}     8d191dcf-ce02-49df-a069-c71749ff1d31       #for DEV
${certificate_metadataIdV2.2}       7543eca8-65a1-460e-9caa-f210f58540a6       #for DEV
${Validation_standard_Id}	        172d5c17-85ed-11e9-9323-005056ac4531       #for DEV
${Validation_standardLabel_Id}	    a589a6b9-875f-11e9-9323-005056ac4531       #for DEV
${Validation_standardLabel2_Id}	    91fe8ebe-89f0-11e9-9323-005056ac4531       #for DEV

${data_misfit_testing_v1_hierarchy_Id}  b37a5231-e6c3-4a85-88e9-fdd6f5a90668   #for DEV
${data_misfit_testing_v2_hierarchy_Id}  f5d19e53-7105-40a7-82a0-b00ff978ac61   #for DEV
${misfit_v1_metadataId}         fe499f63-a2c1-4011-94dd-4a3cfe45f088           #for DEV
${misfit_v2_metadataId}         e6026ace-6c6c-43fa-8504-c41ed0f0acbe           #for DEV


${\n}
${asset_Id_Product1}
${asset_Id_Product2}
${asset_Id_Product3}
${asset_Id_Product12}
${old_asset_Id_Product1}
${Asset_Owner_Ref}
${Asset_Ref_No}
${assetLinkSeqId}
${assetLinkSeqId_2}
${assessmentId}
${assessmentId1}
${assessmentId2}
${assessmentParamId}
${Component_ID}
${Component_ID2}
${Taxonomy_id}
${old_collection_ID}
${Collection_Id}
${Product_Collection_Id}
${Collection_Project_no}
${Collection_Order_no}
${Collection_Quote_no}
${Collection_Project_no_edit}
${Collection_Order_no_edit}
${Collection_Quote_no_edit}
${PrivateLabel_Id}
${PrivateLabel_Id1}
${PrivateLabel_Message}
${PrivateLabel_Asset_Id}
${PrivateLabel_Party_Id}
${local_representative_party_id}
${temp}
${Certificate_Id}
${Certificate_Type}
${ul_asset_Id}
${Cert_Owner_Ref}
${PL_Asset_Id1}
${PL_Asset_Id2}
${scheme}
@{status_code}	200 202
${db_state}
${output}
${response_api}
${response_search_api}




*** Keywords ***
Post Data To Endpoint
    [Arguments]	${endpoint}	${data}	${expectedStatusCode}=200
    ${headers}=	Create Dictionary	Content-Type=application/json
    Create Session	thePost	${API_ENDPOINT}	headers=${headers}
    ${response}=	Post Request	thePost	${endpoint}	${data}
    set global variable  ${response_api}    ${response._content}
    set global variable  ${response_code}    ${response.status_code}
    run keyword if  ${response.status_code}!=200    Should Be Equal As Strings	${expectedStatusCode}	${response.status_code}
    [Return]	${response}

	
Post Data To Endpoint for 202
    [Arguments]	${endpoint}	${data}	${expectedStatusCode}=202
    ${headers}=	Create Dictionary	Content-Type=application/json
    Create Session	thePost	${API_ENDPOINT}	headers=${headers}
    ${response}=	Post Request	thePost	${endpoint}	${data}
    Should Be Equal As Strings	${expectedStatusCode}	${response.status_code}
    [Return]	${response}

	
Get Asset From Endpoint
    [Arguments]	${assetId}	${expectedStatusCode}=200
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/assetDetails/${assetId}
    ${json_convert}	json load data	${response}
    ${result}	convert	${json_convert}
    [Return]	${result}

	
Create Product1 Asset
    [Arguments]	${assettemplate}
    Sleep	3
    ${File}=	GET FILE	${assettemplate}
    ${File1}	extract and replace random owner ref	${File}
    ${File2}	extract and replace random project no  	${File1}
    ${File3}	extract and replace random quote no  	${File2}
    ${File4}	extract and replace random order no  	${File3}
    ${FILE5}	extract and replace date	${File4}
    ${JSON}	replace variables	${FILE5}
    ${result}=	Post Data To Endpoint	/assets	${JSON}	200
    set global variable  ${response_api}    ${result}
    set test variable	${asset_Id}	${result.json()["data"]["assetId"]}
    set global variable	${asset_Id_Product1}	${asset_Id}
    log to console	"Asset Product1_ID": ${asset_Id_Product1}
    set test variable	${owner_ref}	${result.json()["data"]["taxonomy"][1]["value"]}
    set global variable	${Asset_Owner_Ref}	${owner_ref}
    set global variable	${Asset1_Asset_Owner_Ref}	${Asset_Owner_Ref}
    log to console	"Owner_Reference": ${owner_ref}
    set test variable	${reference_num}	${result.json()["data"]["taxonomy"][2]["value"]}
    set global variable	${Asset_Ref_No}	${reference_num}
    log to console	"Reference_num": ${reference_num}
    ${Col_Id}   col_id  ${result.json()}
    set test variable	${C_Id}    ${Col_Id}
    set global variable	${Collection_Id}    ${Col_Id}
    set global variable	${Asset1_Collection_Id}  ${Collection_Id}
    log to console	"Collection_ID": ${Collection_Id}
    ${order_no}     get_col_order_no    ${result.json()}
    set test variable	${C_Order_no}    ${order_no}
    set global variable	${Collection_Order_no}	${order_no}
    set global variable	${Asset1_Collection_Order_no}	${Collection_Order_no}
    log to console	"Order_No": ${order_no}
    ${project_no}     get_col_project_no  ${result.json()}
    set test variable	${C_Project_no}    ${project_no}
    set global variable	${Collection_Project_no}	${project_no}
    set global variable	${Asset1_Collection_Project_no}	${Collection_Project_no}
    log to console	"Project_No": ${project_no}
    ${quote_no}     get_col_quote_no  ${result.json()}
    set test variable	${C_quote_no}    ${quote_no}
    set global variable	${Collection_Quote_no}	${quote_no}
    set global variable	${Asset1_Collection_Quote_no}	${Collection_Quote_no}
    log to console	"Quote_No": ${quote_no}
    log to console	"standard_hierarchy_Id": ${standard_hierarchy_Id}


Create Product1_siscase2 Asset
    [Arguments]	${assettemplate}
    Sleep	3
    ${File}=	GET FILE	input/${assettemplate}
    ${File1}	extract and replace random owner ref	${File}
    ${File2}	extract and replace random project no  	${File1}
    ${File3}	extract and replace random quote no  	${File2}
    ${File4}	extract and replace random order no  	${File3}
    ${FILE2}	extract and replace date	${File4}
    ${JSON}	replace variables	${FILE2}
    ${result}=	Post Data To Endpoint	/assets	${JSON}	200
    set global variable  ${response_api}    ${result}
    set test variable	${asset_Id}	${result.json()["data"]["assetId"]}
    set global variable	${asset_Id_Product1}	${asset_Id}
    log to console	"Asset Product1_ID": ${asset_Id_Product1}
    set test variable	${owner_ref}	${result.json()["data"]["taxonomy"][1]["value"]}
    set global variable	${Asset_Owner_Ref}	${owner_ref}
    set global variable	${Asset1_Asset_Owner_Ref}	${Asset_Owner_Ref}
    log to console	"Owner_Reference": ${owner_ref}
    set test variable	${reference_num}	${result.json()["data"]["taxonomy"][2]["value"]}
    set global variable	${Asset_Ref_No}	${reference_num}
    log to console	"Reference_num": ${reference_num}
    ${Col_Id}   col_id  ${result.json()}
    set test variable	${C_Id}    ${Col_Id}
    set global variable	${Collection_Id}    ${Col_Id}
    set global variable	${Asset1_Collection_Id}  ${Collection_Id}
    log to console	"Collection_ID": ${Collection_Id}
    ${order_no}     get_col_order_no    ${result.json()}
    set test variable	${C_Order_no}    ${order_no}
    set global variable	${Collection_Order_no}	${order_no}
    set global variable	${Asset1_Collection_Order_no}	${Collection_Order_no}
    log to console	"Order_No": ${order_no}
    ${project_no}     get_col_project_no  ${result.json()}
    set test variable	${C_Project_no}    ${project_no}
    set global variable	${Collection_Project_no}	${project_no}
    set global variable	${Asset1_Collection_Project_no}	${Collection_Project_no}
    log to console	"Project_No": ${project_no}
    ${quote_no}     get_col_quote_no  ${result.json()}
    set test variable	${C_quote_no}    ${quote_no}
    set global variable	${Collection_Quote_no}	${quote_no}
    set global variable	${Asset1_Collection_Quote_no}	${Collection_Quote_no}
    log to console	"Quote_No": ${quote_no}
    log to console	"standard_hierarchy_Id": ${standard_hierarchy_Id}


Create Product1_siscase3 Asset
    [Arguments]	${assettemplate}
    Sleep	3
    ${File}=	GET FILE	input/${assettemplate}
    ${File1}	extract and replace random owner ref	${File}
    ${File2}	extract and replace random project no  	${File1}
    ${File3}	extract and replace random quote no  	${File2}
    ${File4}	extract and replace random order no  	${File3}
    ${FILE2}	extract and replace date	${File4}
    ${JSON}	replace variables	${FILE2}
    ${result}=	Post Data To Endpoint	/assets	${JSON}	200
    set global variable  ${response_api}    ${result}
    set test variable	${asset_Id}	${result.json()["data"]["assetId"]}
    set global variable	${asset_Id_Product1}	${asset_Id}
    log to console	"Asset Product1_ID": ${asset_Id_Product1}
    set test variable	${owner_ref}	${result.json()["data"]["taxonomy"][1]["value"]}
    set global variable	${Asset_Owner_Ref}	${owner_ref}
    set global variable	${Asset1_Asset_Owner_Ref}	${Asset_Owner_Ref}
    log to console	"Owner_Reference": ${owner_ref}
    set test variable	${reference_num}	${result.json()["data"]["taxonomy"][2]["value"]}
    set global variable	${Asset_Ref_No}	${reference_num}
    log to console	"Reference_num": ${reference_num}
    ${Col_Id}   col_id  ${result.json()}
    set test variable	${C_Id}    ${Col_Id}
    set global variable	${Collection_Id}    ${Col_Id}
    set global variable	${Asset1_Collection_Id}  ${Collection_Id}
    log to console	"Collection_ID": ${Collection_Id}
    ${order_no}     get_col_order_no    ${result.json()}
    set test variable	${C_Order_no}    ${order_no}
    set global variable	${Collection_Order_no}	${order_no}
    set global variable	${Asset1_Collection_Order_no}	${Collection_Order_no}
    log to console	"Order_No": ${order_no}
    ${project_no}     get_col_project_no  ${result.json()}
    set test variable	${C_Project_no}    ${project_no}
    set global variable	${Collection_Project_no}	${project_no}
    set global variable	${Asset1_Collection_Project_no}	${Collection_Project_no}
    log to console	"Project_No": ${project_no}
    ${quote_no}     get_col_quote_no  ${result.json()}
    set test variable	${C_quote_no}    ${quote_no}
    set global variable	${Collection_Quote_no}	${quote_no}
    set global variable	${Asset1_Collection_Quote_no}	${Collection_Quote_no}
    log to console	"Quote_No": ${quote_no}
    log to console	"standard_hierarchy_Id": ${standard_hierarchy_Id}


Create Product2 Asset
    [Arguments]	${assettemplate}
    Sleep	3
    ${File}=	GET FILE	${assettemplate}
    ${File1}	extract and replace random owner ref	${File}
    ${File2}	extract and replace random project no  	${File1}
    ${File3}	extract and replace random quote no  	${File2}
    ${File4}	extract and replace random order no  	${File3}
    ${FILE5}	extract and replace date	${File4}
    ${JSON}	replace variables	${FILE5}
    ${result}=	Post Data To Endpoint	/assets	${JSON}	200
    set test variable	${asset_Id}	${result.json()["data"]["assetId"]}
    set global variable	${asset_Id_Product2}	${asset_Id}
    set global variable	${Asset2_asset_Id_Product2}	${asset_Id_Product2}
    log to console	"Asset Product2_ID": ${asset_Id_Product2}
    set test variable	${owner_ref}	${result.json()["data"]["taxonomy"][1]["value"]}
    set global variable	${Asset_Owner_Ref}	${owner_ref}
    log to console	"Owner_Reference": ${owner_ref}
    ${Col_Id}   col_id  ${result.json()}
    set test variable	${C_Id}    ${Col_Id}
    set global variable	${Collection_Id}    ${Col_Id}
    set global variable	${Asset2_Collection_Id}  ${Collection_Id}
    log to console	"Collection_ID": ${Collection_Id}
    ${order_no}     get_col_order_no    ${result.json()}
    set test variable	${C_Order_no}    ${order_no}
    set global variable	${Collection_Order_no}	${order_no}
    set global variable	${Asset2_Collection_Order_no}	${Collection_Order_no}
    log to console	"Order_No": ${order_no}
    ${project_no}     get_col_project_no  ${result.json()}
    set test variable	${C_Project_no}    ${project_no}
    set global variable	${Collection_Project_no}	${project_no}
    set global variable	${Asset2_Collection_Project_no}	${Collection_Project_no}
    log to console	"Project_No": ${project_no}
    ${quote_no}     get_col_quote_no  ${result.json()}
    set test variable	${C_quote_no}    ${quote_no}
    set global variable	${Collection_Quote_no}	${quote_no}
    set global variable	${Asset2_Collection_Quote_no}	${Collection_Quote_no}
    log to console	"Quote_No": ${quote_no}
    log to console	"standard_hierarchy_Id": ${standard_hierarchy_Id}

	
Create Product2_siscase2 Asset
    [Arguments]	${assettemplate}
    Sleep	3
    ${File}=	GET FILE	input/${assettemplate}
    ${File1}	extract and replace random owner ref	${File}
    ${File2}	extract and replace random project no  	${File1}
    ${File3}	extract and replace random quote no  	${File2}
    ${File4}	extract and replace random order no  	${File3}
    ${FILE2}	extract and replace date	${File4}
    ${JSON}	replace variables	${FILE2}
    ${result}=	Post Data To Endpoint	/assets	${JSON}	200
    set test variable	${asset_Id}	${result.json()["data"]["assetId"]}
    set global variable	${asset_Id_Product2}	${asset_Id}
    set global variable	${Asset2_asset_Id_Product2}	${asset_Id_Product2}
    log to console	"Asset Product2_ID": ${asset_Id_Product2}
    set test variable	${owner_ref}	${result.json()["data"]["taxonomy"][1]["value"]}
    set global variable	${Asset_Owner_Ref}	${owner_ref}
    log to console	"Owner_Reference": ${owner_ref}
    ${Col_Id}   col_id  ${result.json()}
    set test variable	${C_Id}    ${Col_Id}
    set global variable	${Collection_Id}    ${Col_Id}
    set global variable	${Asset2_Collection_Id}  ${Collection_Id}
    log to console	"Collection_ID": ${Collection_Id}
    ${order_no}     get_col_order_no    ${result.json()}
    set test variable	${C_Order_no}    ${order_no}
    set global variable	${Collection_Order_no}	${order_no}
    set global variable	${Asset2_Collection_Order_no}	${Collection_Order_no}
    log to console	"Order_No": ${order_no}
    ${project_no}     get_col_project_no  ${result.json()}
    set test variable	${C_Project_no}    ${project_no}
    set global variable	${Collection_Project_no}	${project_no}
    set global variable	${Asset2_Collection_Project_no}	${Collection_Project_no}
    log to console	"Project_No": ${project_no}
    ${quote_no}     get_col_quote_no  ${result.json()}
    set test variable	${C_quote_no}    ${quote_no}
    set global variable	${Collection_Quote_no}	${quote_no}
    set global variable	${Asset2_Collection_Quote_no}	${Collection_Quote_no}
    log to console	"Quote_No": ${quote_no}
    log to console	"standard_hierarchy_Id": ${standard_hierarchy_Id}


Create Product2_siscase3 Asset
    [Arguments]	${assettemplate}
    Sleep	3
    ${File}=	GET FILE	input/${assettemplate}
    ${File1}	extract and replace random owner ref	${File}
    ${File2}	extract and replace random project no  	${File1}
    ${File3}	extract and replace random quote no  	${File2}
    ${File4}	extract and replace random order no  	${File3}
    ${FILE2}	extract and replace date	${File4}
    ${JSON}	replace variables	${FILE2}
    ${result}=	Post Data To Endpoint	/assets	${JSON}	200
    set test variable	${asset_Id}	${result.json()["data"]["assetId"]}
    set global variable	${asset_Id_Product2}	${asset_Id}
    set global variable	${Asset2_asset_Id_Product2}	${asset_Id_Product2}
    log to console	"Asset Product2_ID": ${asset_Id_Product2}
    set test variable	${owner_ref}	${result.json()["data"]["taxonomy"][1]["value"]}
    set global variable	${Asset_Owner_Ref}	${owner_ref}
    log to console	"Owner_Reference": ${owner_ref}
    ${Col_Id}   col_id  ${result.json()}
    set test variable	${C_Id}    ${Col_Id}
    set global variable	${Collection_Id}    ${Col_Id}
    set global variable	${Asset2_Collection_Id}  ${Collection_Id}
    log to console	"Collection_ID": ${Collection_Id}
    ${order_no}     get_col_order_no    ${result.json()}
    set test variable	${C_Order_no}    ${order_no}
    set global variable	${Collection_Order_no}	${order_no}
    set global variable	${Asset2_Collection_Order_no}	${Collection_Order_no}
    log to console	"Order_No": ${order_no}
    ${project_no}     get_col_project_no  ${result.json()}
    set test variable	${C_Project_no}    ${project_no}
    set global variable	${Collection_Project_no}	${project_no}
    set global variable	${Asset2_Collection_Project_no}	${Collection_Project_no}
    log to console	"Project_No": ${project_no}
    ${quote_no}     get_col_quote_no  ${result.json()}
    set test variable	${C_quote_no}    ${quote_no}
    set global variable	${Collection_Quote_no}	${quote_no}
    set global variable	${Asset2_Collection_Quote_no}	${Collection_Quote_no}
    log to console	"Quote_No": ${quote_no}
    log to console	"standard_hierarchy_Id": ${standard_hierarchy_Id}


Create Product3 Asset
    [Arguments]	${assettemplate}
    Sleep	3
    ${File}=	GET FILE	input/${assettemplate}
    ${File1}	extract and replace random owner ref	${File}
    ${File2}	extract and replace random project no  	${File1}
    ${File3}	extract and replace random quote no  	${File2}
    ${File4}	extract and replace random order no  	${File3}
    ${FILE2}	extract and replace date	${File4}
    ${JSON}	replace variables	${FILE2}
    ${result}=	Post Data To Endpoint	/assets	${JSON}	200
    set test variable	${asset_Id}	${result.json()["data"]["assetId"]}
    set global variable	${asset_Id_Product3}	${asset_Id}
    log to console	"Asset Product3_ID": ${asset_Id_Product3}
    set test variable	${owner_ref}	${result.json()["data"]["taxonomy"][1]["value"]}
    set global variable	${Asset_Owner_Ref}	${owner_ref}
    log to console	"Owner_Reference": ${owner_ref}
    ${Col_Id}   col_id  ${result.json()}
    set test variable	${C_Id}    ${Col_Id}
    set global variable	${Collection_Id}    ${Col_Id}
    set global variable	${Asset3_Collection_Id}  ${Collection_Id}
    log to console	"Collection_ID": ${Collection_Id}
    ${order_no}     get_col_order_no    ${result.json()}
    set test variable	${C_Order_no}    ${order_no}
    set global variable	${Collection_Order_no}	${order_no}
    set global variable	${Asset3_Collection_Order_no}	${Collection_Order_no}
    log to console	"Order_No": ${order_no}
    ${project_no}     get_col_project_no  ${result.json()}
    set test variable	${C_Project_no}    ${project_no}
    set global variable	${Collection_Project_no}	${project_no}
    set global variable	${Asset3_Collection_Project_no}	${Collection_Project_no}
    log to console	"Project_No": ${project_no}
    ${quote_no}     get_col_quote_no  ${result.json()}
    set test variable	${C_quote_no}    ${quote_no}
    set global variable	${Collection_Quote_no}	${quote_no}
    set global variable	${Asset3_Collection_Quote_no}	${Collection_Quote_no}
    log to console	"Quote_No": ${quote_no}
    log to console	"standard_hierarchy_Id": ${standard_hierarchy_Id}


Create Product3_siscase2 Asset
    [Arguments]	${assettemplate}
    Sleep	3
    ${File}=	GET FILE	input/${assettemplate}
    ${File1}	extract and replace random owner ref	${File}
    ${File2}	extract and replace random project no  	${File1}
    ${File3}	extract and replace random quote no  	${File2}
    ${File4}	extract and replace random order no  	${File3}
    ${FILE2}	extract and replace date	${File4}
    ${JSON}	replace variables	${FILE2}
    ${result}=	Post Data To Endpoint	/assets	${JSON}	200
    set test variable	${asset_Id}	${result.json()["data"]["assetId"]}
    set global variable	${asset_Id_Product3}	${asset_Id}
    log to console	"Asset Product3_ID": ${asset_Id_Product3}
    set test variable	${owner_ref}	${result.json()["data"]["taxonomy"][1]["value"]}
    set global variable	${Asset_Owner_Ref}	${owner_ref}
    log to console	"Owner_Reference": ${owner_ref}
    ${Col_Id}   col_id  ${result.json()}
    set test variable	${C_Id}    ${Col_Id}
    set global variable	${Collection_Id}    ${Col_Id}
    set global variable	${Asset3_Collection_Id}  ${Collection_Id}
    log to console	"Collection_ID": ${Collection_Id}
    ${order_no}     get_col_order_no    ${result.json()}
    set test variable	${C_Order_no}    ${order_no}
    set global variable	${Collection_Order_no}	${order_no}
    set global variable	${Asset3_Collection_Order_no}	${Collection_Order_no}
    log to console	"Order_No": ${order_no}
    ${project_no}     get_col_project_no  ${result.json()}
    set test variable	${C_Project_no}    ${project_no}
    set global variable	${Collection_Project_no}	${project_no}
    set global variable	${Asset3_Collection_Project_no}	${Collection_Project_no}
    log to console	"Project_No": ${project_no}
    ${quote_no}     get_col_quote_no  ${result.json()}
    set test variable	${C_quote_no}    ${quote_no}
    set global variable	${Collection_Quote_no}	${quote_no}
    set global variable	${Asset3_Collection_Quote_no}	${Collection_Quote_no}
    log to console	"Quote_No": ${quote_no}
    log to console	"standard_hierarchy_Id": ${standard_hierarchy_Id}


Create Product3_siscase3 Asset
    [Arguments]	${assettemplate}
    Sleep	3
    ${File}=	GET FILE	input/${assettemplate}
    ${File1}	extract and replace random owner ref	${File}
    ${File2}	extract and replace random project no  	${File1}
    ${File3}	extract and replace random quote no  	${File2}
    ${File4}	extract and replace random order no  	${File3}
    ${FILE2}	extract and replace date	${File4}
    ${JSON}	replace variables	${FILE2}
    ${result}=	Post Data To Endpoint	/assets	${JSON}	200
    set test variable	${asset_Id}	${result.json()["data"]["assetId"]}
    set global variable	${asset_Id_Product3}	${asset_Id}
    log to console	"Asset Product3_ID": ${asset_Id_Product3}
    set test variable	${owner_ref}	${result.json()["data"]["taxonomy"][1]["value"]}
    set global variable	${Asset_Owner_Ref}	${owner_ref}
    log to console	"Owner_Reference": ${owner_ref}
    ${Col_Id}   col_id  ${result.json()}
    set test variable	${C_Id}    ${Col_Id}
    set global variable	${Collection_Id}    ${Col_Id}
    set global variable	${Asset3_Collection_Id}  ${Collection_Id}
    log to console	"Collection_ID": ${Collection_Id}
    ${order_no}     get_col_order_no    ${result.json()}
    set test variable	${C_Order_no}    ${order_no}
    set global variable	${Collection_Order_no}	${order_no}
    set global variable	${Asset3_Collection_Order_no}	${Collection_Order_no}
    log to console	"Order_No": ${order_no}
    ${project_no}     get_col_project_no  ${result.json()}
    set test variable	${C_Project_no}    ${project_no}
    set global variable	${Collection_Project_no}	${project_no}
    set global variable	${Asset3_Collection_Project_no}	${Collection_Project_no}
    log to console	"Project_No": ${project_no}
    ${quote_no}     get_col_quote_no  ${result.json()}
    set test variable	${C_quote_no}    ${quote_no}
    set global variable	${Collection_Quote_no}	${quote_no}
    set global variable	${Asset3_Collection_Quote_no}	${Collection_Quote_no}
    log to console	"Quote_No": ${quote_no}
    log to console	"standard_hierarchy_Id": ${standard_hierarchy_Id}


Create Certificate
   [Arguments]	${certtemplate}
   Sleep	3
   ${File}=     GET FILE    input/${certtemplate}
   ${FILE2}	extract and replace date for certificate scheme  ${File}
   ${JSON}	replace variables	${FILE2}
   ${result}=	Post Data To Endpoint	/assets/createCertificate	${JSON}	200
   set test variable	${cert_Id}	${result.json()["data"]["hasTransaction"][0]["certificateId"]}
   set global variable	${Certificate_Id}	${cert_Id}
   set test variable	${transact_Id}	${result.json()["data"]["hasTransaction"][0]["transactionId"]}
   set global variable	${Transaction_Id}	${transact_Id}
   log to console	"Certificate ID": ${Certificate_Id}
   log to console	"Transaction ID": ${Transaction_Id}
   set test variable	${owner_ref}	${result.json()["data"]["ownerReference"]}
   set global variable	${Cert_Owner_Ref}	${owner_ref}
   log to console	"Owner_Reference": ${owner_ref}

   
Link Product to Certificate
   [Arguments]	${certtemplate}
   Sleep	3
   ${File}=     GET FILE    input/${certtemplate}
   ${FILE2}	extract and replace date for certificate scheme  ${File}
   ${JSON}	replace variables	${FILE2}
   ${response}=  Post Data To Endpoint	/assets/createCertificate	${JSON}	200
   [Return]  ${response.text}


Associate Parties to Certificate
   [Arguments]	${certtemplate}
   ${File}=     GET FILE    input/${certtemplate}
   ${JSON}	replace variables	${FILE}
   ${result}=	Post Data To Endpoint	/assets/createCertificate	${JSON}	200

   
Certify Certificate
   [Arguments]	${certtemplate}
   ${File}=     GET FILE    input/${certtemplate}
   ${FILE2}	replace variables	${FILE}
   ${JSON}	extract and replace issue date and withdrawal date and expiry date for certificate  ${FILE2}
   ${response}=  Post Data To Endpoint	/assets/createCertificate	${JSON}	200
#   [Return]  ${response.text}


Certify Certificate with ED equal to CD
   [Arguments]	${certtemplate}
   ${File}=     GET FILE    input/${certtemplate}
   ${FILE2}	replace variables	${FILE}
   ${JSON}	extract_and_replace_issue_date_and_withdrawal_date_and_expiry_date_for_certificate  ${FILE2}
   ${response}=  Post Data To Endpoint	/assets/createCertificate	${JSON}	200
#   [Return]  ${response.text}


Certify Certificate with WD equal to CD
   [Arguments]	${certtemplate}
   ${File}=     GET FILE    input/${certtemplate}
   ${FILE2}	replace variables	${FILE}
   ${JSON}	extract_and_replace_issue_date_and_withdrawal_date_and_expiry_date_for_certificate  ${FILE2}
   ${response}=  Post Data To Endpoint	/assets/createCertificate	${JSON}	200
#   [Return]  ${response.text}


Select As Cert Scheme
   [Arguments]	${certtemplate}
   ${File}=     GET FILE    input/${certtemplate}
   ${FILE2}	replace variables	${FILE}
   ${JSON}	extract and replace date for certificate scheme  ${FILE2}
   ${response}=  Post Data To Endpoint	/assets/createCertificate	${JSON}	200

   
Certificate Mark
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificateDetails?certificateType=Regression%20Scheme&ownerReference=${Asset_Owner_Ref}&certificateName=Regression-US001-1
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	Mark	${json}
    [Return]	${result}

	
Get certificate status
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificateDetails?certificateId=${Certificate_Id}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	cert status	${json}
    [Return]	${result}
	
	
Get Asset State
    [Arguments]	${endpoint}
    connect to database	@{database}
    ${state}	query	select state from state where entity_id = '${endpoint}';
    ${result}	asset_state	${state}
    [Return]	${result}

	
Get AssesmentID
    [Arguments]	${assetId}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}/standards
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	assessment id	${json}
    set global variable	${assessmentId}	${result}
    log to console	"Assessment_Id": ${assessmentId}
    [Return]	${result}

	
Standard Assignment
    [Arguments]	${standardtemplate}	${assetId}
    ${FILE}	GET FILE	input/${standardtemplate}
    ${JSON}	replace variables	${FILE}
    ${result}=	Post Data To Endpoint	/assets/${assetId}/standards	${JSON}	200

	
Save Requirement
    [Arguments]	${requirementtemplate}	${assetId}
    ${FILE}	GET FILE	input/${requirementtemplate}
    ${JSON}	replace variables	${FILE}
    ${result}=	Post Data To Endpoint	/assets/${assetId}/standards/requirements	${JSON}	200

	
Get Assesment_ParamID
    [Arguments]	${assetId}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}/standards/requirements
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	assessment_param_id	${json}
    set global variable	${assessmentParamId}	${result}
    log to console	"Assessment_Param_Id": ${assessmentParamId}

	
Render Verdict for 202
    [Arguments]	${renderverdicttemplate}	${assetId}
    ${FILE}	GET FILE    ${renderverdicttemplate}
    ${JSON}	replace variables	${FILE}
    ${result}=	Post Data To Endpoint for 202  /assets/${assetId}/standards/${standard_hierarchy_Id}/evaluations	${JSON} 202
    [Return]	${result}

	
Render Verdict
    [Arguments]	${renderverdicttemplate}	${assetId}
    ${FILE}	GET FILE    ${renderverdicttemplate}
    ${JSON}	replace variables	${FILE}
    ${result}=	Post Data To Endpoint	/assets/${assetId}/standards/${standard_hierarchy_Id}/evaluations	${JSON} 200
    [Return]	${result}

	
Has More Clauses
    [Arguments]	${response}
    ${result}   more_clause  ${response}
    [Return]	${result}

	
#Complete Evaluation
#    [Arguments]	${evaltemplate}	${assetId}
#    ${file}	Get File	input/${evaltemplate}
#    ${JSON}=	replace variables	${file}
#    ${result}=	Post Data To Endpoint	/assets/${assetId}/standards/evaluations	${JSON}	200
#    [Return]	${result}


Complete Evaluation
    [Arguments]	${evaltemplate}	${assetId}
    Get Collection_ID   ${assetId}
    ${file}	Get File	input/${evaltemplate}
    ${JSON}=	replace variables	${file}
    ${result}=	Post Data To Endpoint	/collections/${collectionId}/standards/evaluations	${JSON}	200
    [Return]	${result}

	
Evaluation Summary
    [Arguments]	${assetId}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}/standards/evaluations?assessmentId=${assessmentId}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	verdict  ${json}
    [Return]	${result}

	
AEO details
    [Arguments]	${assetId}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}/standards/evaluations?assessmentId=${assessmentId}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	aeo_detail	${json}
    [Return]	${result}

	
Notes
    [Arguments]	${assetId}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}/standards/evaluations?assessmentId=${assessmentId}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	note	${json}
    [Return]	${result}

	
Clause Text
    [Arguments]	${assetId}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}/standards/evaluations?assessmentId=${assessmentId}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	cl_text	${json}
    [Return]	${result}

	
Clause ID
    [Arguments]	${assetId}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}/standards/evaluations?assessmentId=${assessmentId}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	cl_id	${json}
    [Return]	${result}

	
Table Number
    [Arguments]	${assetId}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}/standards/evaluations?assessmentId=${assessmentId}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	table_no	${json}
    [Return]	${result}

	
Get ULAssetID
    [Arguments]	${assetId}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	ulAsset id  ${json}
    log to console	"ulAsset_Id": ${result}
    [Return]	${result}

	
Get HasAssets
    [Arguments]	${scheme}   ${cert_name}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificateDetails?certificateType=${scheme}&ownerReference=${Asset_Owner_Ref}&certificateName=${cert_name}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	has_assets  ${json}
    ${result1}  json dumps  ${result}
    set global variable	${has_Assets}	${result1}
    [Return]	${has_Assets}

	
Get HasAssets_2
    [Arguments]	${scheme}   ${cert_name}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificateDetails?certificateType=${scheme}&ownerReference=${Asset_Owner_Ref}&certificateName=${cert_name}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	has_assets_2  ${json}
    ${result1}  json dumps  ${result}
    set global variable	${has_Assets_2}	${result1}
    [Return]	${has_Assets_2}

	
Get HasEvaluations
    [Arguments]	${scheme}   ${cert_name}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificateDetails?certificateType=${scheme}&ownerReference=${Asset_Owner_Ref}&certificateName=${cert_name}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	has_evaluations  ${json}
    ${result1}  json dumps  ${result}
    set global variable	${has_Evaluations}	${result1}
    [Return]	${has_Evaluations}


Get HasEvaluations_2
    [Arguments]	${scheme}   ${cert_name}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificateDetails?certificateType=${scheme}&ownerReference=${Asset_Owner_Ref}&certificateName=${cert_name}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	has_evaluations_2  ${json}
    ${result1}  json dumps  ${result}
    set global variable	${has_Evaluations_2}	${result1}
    [Return]	${has_Evaluations_2}


Get TransactionId_2
    [Arguments]	${scheme}   ${cert_name}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificateDetails?certificateType=${scheme}&ownerReference=${Asset_Owner_Ref}&certificateName=${cert_name}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	transaction_id_2  ${json}
    set global variable	${Transaction_Id_2}	${result}
    log to console	"Transaction ID_2": ${Transaction_Id_2}
    [Return]	${Transaction_Id_2}

	
Get CertificateId_2
    [Arguments]	${scheme}   ${cert_name}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificateDetails?certificateType=${scheme}&ownerReference=${Asset_Owner_Ref}&certificateName=${cert_name}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	certificate_id_2  ${json}
    set global variable	${Certificate_Id_2}	${result}
    log to console	"Certificate ID_2": ${Certificate_Id_2}
    [Return]	${Certificate_Id_2}

	
Expire The Asset
    [Documentation]	Expires an asset by its assetId.	'Expire The Asset	assetId'
    [Arguments]	${assetId}
    connect to database	@{database}
    ${taxonomy_id}	query	select taxonomy_id from asset where asset_id = '${assetId}';
    ${split}	taxonomy id extract	${taxonomy_id}
    set global variable	${Taxonomy_id}	${split}
    update end date
    disconnect from database


Get Collection Attributes
    [Arguments]	${productType}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/template?attribProductType=${productType}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}   col_att   ${json}
    [Return]	${result}


Get Metadata Collection Attributes
    [Arguments]	${productType}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/hierarchy/metadata?metadataType=${productType}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}   metadata_col_att   ${json}
    [Return]	${result}


Get Shared Attributes
    [Arguments]	${productType}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/template?attribProductType=${productType}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}   shared_att   ${json}
    [Return]	${result}


Get Metadata Shared Attributes
    [Arguments]	${productType}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/hierarchy/metadata?metadataType=${productType}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}   metadata_shared_att   ${json}
    [Return]	${result}


Get Collection_ID
    [Arguments]	${assetId}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	col_id	${json}
    set test variable  ${c_id}  ${result}
    set global variable     ${Collection_Id}	${c_id}
    log to console	"Asset_Collection_Id": ${Collection_Id}


create Asset2 based on product1 Asset1
    [Arguments]	${assettemplate}
    Sleep	3
    ${File}=	GET FILE	input/${assettemplate}
    ${FILE1}	extract and replace date	${File}
    ${JSON}	replace variables	${FILE1}
    ${result}=	Post Data To Endpoint	/assets	${JSON}	200
    set global variable  ${response_api}    ${result}
    set test variable	${asset_Id}	${result.json()["data"]["assetId"]}
    set global variable	${asset_Id_Product12}	${asset_Id}
    log to console	"Asset2 Product1_ID": ${asset_Id_Product12}
    set test variable	${owner_ref}	${result.json()["data"]["taxonomy"][1]["value"]}
    set global variable	${Asset_Owner_Ref}	${owner_ref}
    log to console	"Owner_Reference": ${owner_ref}
    ${Col_Id}   col_id  ${result.json()}
    set test variable	${C_Id}    ${Col_Id}
    set global variable	${Collection_Id}    ${Col_Id}
    set global variable	${Asset2_Collection_Id}  ${Collection_Id}
    log to console	"Collection_ID": ${Collection_Id}
    ${order_no}     get_col_order_no    ${result.json()}
    set test variable	${C_Order_no}    ${order_no}
    set global variable	${Collection_Order_no}	${order_no}
    set global variable	${Asset2_Collection_Order_no}	${Collection_Order_no}
    log to console	"Order_No": ${order_no}
    ${project_no}     get_col_project_no  ${result.json()}
    set test variable	${C_Project_no}    ${project_no}
    set global variable	${Collection_Project_no}	${project_no}
    set global variable	${Asset2_Collection_Project_no}	${Collection_Project_no}
    log to console	"Project_No": ${project_no}
    ${quote_no}     get_col_quote_no  ${result.json()}
    set test variable	${C_quote_no}    ${quote_no}
    set global variable	${Collection_Quote_no}	${quote_no}
    set global variable	${Asset2_Collection_Quote_no}	${Collection_Quote_no}
    log to console	"Quote_No": ${quote_no}
    log to console	"standard_hierarchy_Id": ${standard_hierarchy_Id}
    set test variable	${msg}	${result.json()["message"]}
    set global variable	${API_Message}	${msg}
    log to console	"API_Message": ${API_Message}


create Product 2 Asset1 based on product1 Asset1
    [Arguments]	${assettemplate}
    Sleep	3
    ${File}=	GET FILE	input/${assettemplate}
    ${File1}	extract and replace random project no  	${File}
    ${FILE2}	extract and replace date	${File1}
    ${JSON}	replace variables	${FILE2}
    ${result}=	Post Data To Endpoint	/assets	${JSON}	400
    set test variable	${msg}	${result.json()["message"]}
    set global variable	${API_Message}	${msg}
    [Return]	${msg}


Edit Asset Collection Attribute
    [Arguments]	${assettemplate}    ${assetId}
    Sleep	3
    ${File}=	GET FILE	input/${assettemplate}
    ${File2}	extract and replace random project no  	${File}
    ${FILE}	extract and replace date	${File2}
    ${JSON}	replace variables	${FILE}
    ${result}=	Post Data To Endpoint	/assets/${assetId}	${JSON}	200
    set test variable	${asset_Id}	${result.json()["data"]["assetId"]}
    set global variable	${asset_Id_Product1}	${asset_Id}
    log to console	"Asset Product1_ID": ${asset_Id_Product1}
    set test variable	${owner_ref}	${result.json()["data"]["taxonomy"][1]["value"]}
    set global variable	${Asset_Owner_Ref_edit}	${owner_ref}
    log to console	"Owner_Reference": ${owner_ref}
     ${Col_Id}   col_id  ${result.json()}
    set test variable	${C_Id}    ${Col_Id}
    set global variable	${Collection_Id}    ${Col_Id}
    log to console	"Collection_ID": ${Collection_Id}
    ${order_no}     get_col_order_no    ${result.json()}
    set test variable	${C_Order_no}    ${order_no}
    set global variable	${Collection_Order_no_edit}	${order_no}
    log to console	"Order_No": ${order_no}
    ${project_no}     get_col_project_no  ${result.json()}
    set test variable	${C_Project_no}    ${project_no}
    set global variable	${Collection_Project_no_edit}	${project_no}
    log to console	"Project_No": ${project_no}
    ${quote_no}     get_col_quote_no  ${result.json()}
    set test variable	${C_Quote_no}    ${quote_no}
    set global variable	${Collection_Quote_no_edit}	${quote_no}
    log to console	"Quote_No": ${quote_no}
    log to console	"standard_hierarchy_Id": ${standard_hierarchy_Id}


Get Collection Asset Link
    [Arguments]	${collection_Id}
    connect to database	@{database}
    ${result}	query	select asset_id from asset_pseudo_taxonomy_link where collection_id = '${collection_Id}';
    [Return]	${result}

	
Get TP1Attribute6
    [Arguments]	${response}
    ${result}   tp1_att6  ${response}
    [Return]	${result}

	
Get SharedAttribute2
    [Arguments]	${response}
    ${result}   shared_att2  ${response}
    [Return]	${result}

	
Get Asset Effective_END_DATE
    [Arguments]	${collection_Id}
    connect to database	@{database}
    ${result}	query	select effective_end_date from asset_pseudo_taxonomy_link where collection_id = '${collection_Id}';
    [Return]	${result}

	
Search Collection
    [Arguments]	${Search_Parameter}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/collections/collectionSummary?${Search_Parameter}&exactSearch=true
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	summary_col_id	${json}
    [Return]	${result}

	
Get Component of Asset In Collection
    [Arguments]	${col_id}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/collections/${col_id}/components
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	comp_id	${json}
    [Return]	${result}

	
Get Error Message for Get Compoenent of Asset In Collection
    [Arguments]	${col_id}
    ${response}=  HttpLibrary.HTTP.get  ${API_ENDPOINT}/collections/${col_id}/components/
    [Return]	   ${response}

	
Get Error Message for Get Compoenent of Asset In Collection with asset_id
    [Arguments]	${col_id}   ${asst_id}
    ${response}=  urllib2.urlopen  ${API_ENDPOINT}/collections/${col_id}/components?assetId=${asst_id}
    [Return]	   ${response}

	
Get Error Message
    [Arguments]	${response}
    ${result}	err_msg	${response}
    [Return]	${result}

	
Get Alternate Compoenent of Asset In Collection
    [Arguments]	${col_id}
    ${response}=     urllib2.urlopen	${API_ENDPOINT}/collections/${col_id}/components
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	alternate_component_id	${json}
    [Return]	${result}

	
Get Component of Asset In Collection with asset_id
    [Arguments]	${col_id}   ${asset_id}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/collections/${col_id}/components?assetId=${asset_id}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	comp_id	${json}
    [Return]	${result}

	
Get Alternate Compoenent of Asset In Collection with asset_id
    [Arguments]	${col_id}   ${asset_id}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/collections/${col_id}/components?assetId=${asset_id}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	alternate_component_id	${json}
    [Return]	${result}

	
Get Collection Details
    [Arguments]	${col_id}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/collections/collectionDetails/${col_id}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	col_id	${json}
    [Return]	${result}

	
Get Collection Details_one_asset_Id
    [Arguments]	${col_id}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/collections/collectionDetails/${col_id}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	col_asset_id_1	${json}
    [Return]	${result}

	
Get Collection Details_two_asset_Id
    [Arguments]	${col_id}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/collections/collectionDetails/${col_id}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result1}	col_asset_id_1	${json}
    ${result2}	col_asset_id_2	${json}
    [Return]	${result1}  ${result2}

	
Get Col_ID
    [Arguments]	${paramater}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/collections/getCollectionId?${paramater}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${json1}    json dumps  ${json}
    set global variable  ${response_api}    ${json1}
    ${result}	col_id	${json}
    set test variable  ${c_id}  ${result}
    set global variable     ${Collection_Id}	${c_id}
    log to console	"Asset_Collection_Id": ${Collection_Id}

	
Validate On End
    [Arguments]	${assetId}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}/validate
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${message}   validate_on_end_message  ${json}
    [Return]	${message}

	
Lock Collection
    [Arguments]	${assettemplate}  ${col_Id}
    ${JSON}=	GET FILE	input/${assettemplate}
    ${result}=	Post Data To Endpoint	/collections/${col_Id}/lock  ${JSON}	200
    [Return]	${result}

	
Unlock Collection
    [Arguments]	${assettemplate}  ${col_Id}
    ${JSON}=	GET FILE	input/${assettemplate}
    ${result}=	Post Data To Endpoint	/collections/${col_Id}/unlock  ${JSON}	200
    [Return]	${result}

	
Lock Asset
    [Arguments]	${assettemplate}  ${asset_Id}
    ${JSON}=	GET FILE	input/${assettemplate}
    ${result}=	Post Data To Endpoint	/assets/${asset_Id}/lock  ${JSON}	200
    [Return]	${result}

	
Unlock Asset
    [Arguments]	${assettemplate}  ${asset_Id}
    ${JSON}=	GET FILE	input/${assettemplate}
    ${result}=	Post Data To Endpoint	/assets/${asset_Id}/unlock  ${JSON}	200
    [Return]	${result}

	
Unlock Certificate
    [Arguments]	${certtemplate}  ${cert_Id}
    ${JSON}=	GET FILE	input/${certtemplate}
    ${result}=	Post Data To Endpoint	/assets/certificate/unlock?certificateId=${cert_Id}  ${JSON}	200
    [Return]	${result}

	
Modify Product1 Asset
    [Arguments]	${assettemplate}    ${assetId}
#    Sleep	3
    ${File}=	GET FILE	${assettemplate}
    ${File1}	extract and replace date	${File}
    ${File2}	extract and replace random project no  	${File1}
    ${File3}	extract and replace random quote no  	${File2}
    ${File4}	extract and replace random order no  	${File3}
    ${JSON}	replace variables	${File4}
    ${result}=	Post Data To Endpoint	/assets/${assetId}	${JSON}	200
    set global variable  ${response_api}    ${result}
    set test variable	${asset_Id}	${result.json()["data"]["assetId"]}
    set global variable	${asset_Id_Product12}	${asset_Id}
    log to console	"Asset2 Product1_ID": ${asset_Id_Product12}
    set test variable	${owner_ref}	${result.json()["data"]["taxonomy"][1]["value"]}
    set global variable	${Asset_Owner_Ref_modify}	${owner_ref}
    log to console	"Owner_Reference": ${owner_ref}
    ${Col_Id}   col_id  ${result.json()}
    set test variable	${C_Id}    ${Col_Id}
    set global variable	${Collection_Id}    ${Col_Id}
    log to console	"Collection_ID": ${Collection_Id}
    ${order_no}     get_col_order_no    ${result.json()}
    set test variable	${C_Order_no}    ${order_no}
    set global variable	${Asset1_Collection_Order_no_modify}	${order_no}
    log to console	"Order_No": ${order_no}
    ${project_no}     get_col_project_no  ${result.json()}
    set test variable	${C_Project_no}    ${project_no}
    set global variable	${Asset1_Collection_Project_no_modify}	${project_no}
    log to console	"Project_No": ${project_no}
    ${quote_no}     get_col_quote_no  ${result.json()}
    set test variable	${C_Quote_no}    ${quote_no}
    set global variable	${Asset1_Collection_Quote_no_modify}	${quote_no}
    log to console	"Quote_No": ${quote_no}
    log to console	"standard_hierarchy_Id": ${standard_hierarchy_Id}

	
get file and change variable
    [Arguments]	${assettemplate}
    ${File}=	GET FILE	input/${assettemplate}
    get present_date
    ${JSON}	replace variables	${File}
    [Return]	${JSON}

	
get present_date
    [Arguments]
    ${result}   present date
    set global variable	${Today_Date}   ${result}
    [Return]	${result}

	
Modify Taxonomy Single_Model Without Asset_Id
    [Arguments]	${assettemplate}
    ${File}=	GET FILE	input/Modify_Taxonomy/${assettemplate}
    get present_date
    ${JSON}	replace variables	${File}
    ${result}=	Post Data To Endpoint	/assets/taxonomy	${JSON}	200

	
Modify Taxonomy Single_Model With Asset_Id
    [Arguments]	${assettemplate}
    ${File}=	GET FILE	input/Modify_Taxonomy/${assettemplate}
    get present_date
    ${JSON}	replace variables	${File}
    ${result}=	Post Data To Endpoint	/assets/${asset_Id_Product1}/taxonomy	${JSON}	200

	
Modify Taxonomy Bulk_Model Without Collection_Id
   [Arguments]	${assettemplate}
    ${File}=	GET FILE	input/Modify_Taxonomy/${assettemplate}
    get present_date
    ${JSON}	replace variables	${File}
    ${result}=	Post Data To Endpoint	/collections/taxonomy	${JSON}	200

	
Modify Taxonomy Bulk_Model With Collection_Id
   [Arguments]	${assettemplate}
    ${File}=	GET FILE	input/Modify_Taxonomy/${assettemplate}
    get present_date
    ${JSON}	replace variables	${File}
    ${result}=	Post Data To Endpoint	/collections/${Collection_Id}/taxonomy	${JSON}	200

	
Create private label
   [Arguments]	${certtemplate}
   ${File}=     GET FILE    input/${certtemplate}
   ${JSON}	replace variables	${File}
   ${result}=	Post Data To Endpoint	/privateLabels/  ${JSON}	200
   set test variable	${PL_Id}	${result.json()["data"]["privateLabelId"]}
   set global variable  ${PrivateLabel_Id}	${PL_Id}
   log to console    Private Lable Certificate ID: ${PrivateLabel_Id}
   set test variable	${PL_Msg}	${result.json()["message"]}
   set global variable  ${PrivateLabel_Message}	${PL_Msg}

   
Edit Private Label
   [Arguments]	${certtemplate}
   ${File}=     GET FILE    input/${certtemplate}
   ${FILE1}	extract_and_replace_issue_date_for_edit_private_label	${File}
   ${JSON}	replace variables	${FILE1}
   ${result}=	Post Data To Endpoint	/privateLabels/${PrivateLabel_Id}  ${JSON}	200
   set test variable	${PL_Id}	${result.json()["data"]["privateLabelId"]}
   set global variable  ${PrivateLabel_Id}	${PL_Id}

   
Add Asset To PL
   [Arguments]	${assettemplate}
   ${File}=     GET FILE    input/${assettemplate}
   ${File1}  extract_and_replace_date_for_Pl_Add_asset   ${File}
   ${JSON}	replace variables	${File1}
   ${response}=	Post Data To Endpoint	/privateLabels/${PrivateLabel_Id}/assets	${JSON}	200
   ${result}	pl asset id    ${response.json()}
   set global variable  ${PrivateLabel_Asset_Id}    ${result}
   log to console    Private Lable Asset ID: ${result}
   [Return]   ${result}

   
Add Party To PL
   [Arguments]	${assettemplate}
   ${File}=     GET FILE    input/${assettemplate}
   ${JSON}	replace variables	${File}
   ${result}=	Post Data To Endpoint	/privateLabels/${PrivateLabel_Id}/parties	${JSON}	200
   [Return]   ${result._content}

   
Get Private Label status
    [Arguments]	${pl_id}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/privateLabels/${pl_id}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	pl status  ${json}
    [Return]	${result}


Get Private Label Error Message
    [Arguments]	${response}
    ${result}	pl error msg    ${response}
    [Return]	${result}

	
Get Private Lable Asset ID
    [Arguments]	${response}
    ${data}  json loads data  ${response}
    ${result}	pl asset id    ${data}
    [Return]	${result}

	
Search Private label
    [Arguments]	${Search_Parameter}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/privateLabels?${Search_Parameter}&sort=-createdOn
    set global variable  ${response_search_api}  ${response.read()}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    ${result}	private_label_id  ${json}
    [Return]	${result}

	
Search Private label Asset
    [Arguments]	${Search_Parameter}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/privateLabels/assets?${Search_Parameter}
    set global variable  ${response_search_api}  ${response.read()}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    ${result}	pl asset id  ${json}
    [Return]	${result}

	
View Private Label Assets
    [Arguments]	${pl_asset_id}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/privateLabels/${PrivateLabel_Id}/assets/${pl_asset_id}
    set global variable  ${response_search_api}  ${response.read()}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    ${result}	private_label_asset_id  ${json}
    [Return]	${result}

	
Lock Private Label
    [Arguments]	${plcerttemplate}  ${pl_Id}
    ${JSON}=	GET FILE	input/${plcerttemplate}
    ${result}=	Post Data To Endpoint	/privateLabels/${pl_Id}/lock  ${JSON}	200
    [Return]	${result._content}

	
Unlock Private Label
    [Arguments]	${plcerttemplate}  ${pl_Id}
    ${JSON}=	GET FILE	input/${plcerttemplate}
    ${result}=	Post Data To Endpoint	/privateLabels/${pl_Id}/unlock  ${JSON}	200
    [Return]	${result._content}

	
Certify Private Label
    [Arguments]	${plcerttemplate}
    ${File}=	GET FILE	input/${plcerttemplate}
    ${File2}=    replace variables  ${File}
    ${JSON}=    extract_and_replace_issue_date_and_withdrawal_date_and_expiry_date_for_private_label_scheme  ${File2}
    ${result}=	Post Data To Endpoint	/privateLabels/decisions  ${JSON}	200
    [Return]	${result._content}

	
Delete Data To Endpoint
    [Arguments]	${endpoint}	${data}	${expectedStatusCode}=200
    ${headers}=	Create Dictionary	Content-Type=application/json
    Create Session	theDelete	${API_ENDPOINT}	headers=${headers}
    ${response}=	delete_request	theDelete	${endpoint}	${data}
    set global variable  ${response_api}    ${response._content}
    run keyword if  ${response.status_code}!=200    Should Be Equal As Strings	${expectedStatusCode}	${response.status_code}
    [Return]	${response}

	
Unlink Asset from Private Label
    [Arguments]	${unlink_aset_template}  ${pl_asset_Id}
    ${JSON}=	GET FILE	input/${unlink_aset_template}
    ${result}=	Delete DATA TO ENDPOINT	/privateLabels/${PrivateLabel_Id}/assets/${pl_asset_Id}  ${JSON}	200
    [Return]	${result._content}


Unlink Party from Private Label
    [Arguments]	${unlink_aset_template}  ${pl_party_Id}
    ${JSON}=	GET FILE	input/${unlink_aset_template}
    ${result}=	Delete DATA TO ENDPOINT	/privateLabels/${PrivateLabel_Id}/parties/${pl_party_Id}  ${JSON}	200
    [Return]	${result._content}

	
Local Reresentative Party Id
   [Arguments]	${response}
    ${result}	lo rep party id  ${response}
    [Return]	${result}

	
View Private Label Details
    [Arguments]	${pl_Id}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/privateLabels/${pl_Id}
    set global variable  ${response_search_api}  ${response.read()}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    ${result}	pl_id  ${json}
    [Return]	${result}

	
View Private Label Assets Details
    [Arguments]	${pl_Id}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/privateLabels/${pl_Id}/assets
    set global variable  ${response_search_api}  ${response.read()}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    ${result}	get_pl_asset_id  ${json}
    [Return]	${result}

	
View Private Label Questions Details
    [Arguments]	${pl_Id}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/privateLabels/${pl_Id}/questions
    set global variable  ${response_search_api}  ${response.read()}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    ${result}	pl_id  ${json}
    [Return]	${result}

	
View Private Label Recommendations Details
    [Arguments]	${pl_Id}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/privateLabels/${pl_Id}/recommendations
    set global variable  ${response_search_api}  ${response.read()}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    ${result}	pl_id  ${json}
    [Return]	${result}

	
View Private Label Certify Details
    [Arguments]	${pl_Id}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/privateLabels/${pl_Id}/certify
    set global variable  ${response_search_api}  ${response.read()}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    ${result}	pl_id  ${json}
    [Return]	${result}

	
View Private Label Parties Details
    [Arguments]	${pl_Id}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/privateLabels/${pl_Id}/parties
    set global variable  ${response_search_api}  ${response.read()}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    ${result}	pl_id  ${json}
    [Return]	${result}
	

Search Certificate
    [Arguments]	${Search_Parameter}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificateSummary?${Search_Parameter}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	summary_owner_reference  ${json}
    [Return]	${result}


Get Certificate Decisioning status
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificateDetails?certificateId=${Certificate_Id}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	cert_decisioning_status	${json}
    [Return]	${result}


Get Certificate Recommendation status
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificateDetails?certificateId=${Certificate_Id}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	cert_recommendation_status	${json}
    [Return]	${result}


View Private Label Assets of a base Asset_one_asset_Id
    [Arguments]	${asset_Id_Product1}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/assets/${asset_Id_Product1}/privateLabelAssets
    set global variable  ${response_search_api}  ${response.read()}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    ${result}	get_pl_assets_pl_asset_id_1  ${json}
    [Return]	${result}


View Private Label Assets of a base Asset_two_asset_Id
    [Arguments]	${asset_Id_Product1}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/assets/${asset_Id_Product1}/privateLabelAssets
    set global variable  ${response_search_api}  ${response.read()}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    ${result1}	get_pl_assets_pl_asset_id_1  ${json}
    ${result2}	get_pl_assets_pl_asset_id_2  ${json}
    [Return]	${result1}   ${result2}


View Base Asset of a private label asset
    [Arguments]	${pl_asset_id}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/assets/${pl_asset_id}/assets
    set global variable  ${response_search_api}  ${response.read()}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    ${result}	get_asset_id_1  ${json}
    [Return]	${result}


Get Base Certificate Details for a Private Label
    [Arguments]	${pl_Id}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/privateLabels/${pl_Id}/certificate
    set global variable  ${response_search_api}  ${response.read()}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    ${result}	cert_owner_reference  ${json}
    [Return]	${result}


Get Private Label Details of a base Certificate
    [Arguments]	${cert_name}    ${cert_type}     ${cert_owner_ref}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/assets/certificate/privateLabels?certificateName=${cert_name}&&certificateType=${cert_type}&&ownerReference=${cert_owner_ref}
    set global variable  ${response_search_api}  ${response.read()}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    ${result}	private_label_id  ${json}
    [Return]	${result}


Link Components to Asset
    [Arguments]	${assettemplate}    ${assetId}
	${file}=	Get File	${assettemplate}
	${JSON}=	replace variables	${file}
	${result}=	Post Data To Endpoint	/assets/${assetId}/components	${JSON}	200
	[Return]	${result}


Edit Product1 Asset for 400
    [Arguments]	${assettemplate}    ${assetId}
    Sleep	3
    ${File}=	GET FILE	input/${assettemplate}
    ${File1}	extract and replace date	${File}
    ${File2}	extract and replace random project no  	${File1}
    ${File3}	extract and replace random quote no  	${File2}
    ${File4}	extract and replace random order no  	${File3}
    ${JSON}	replace variables	${File4}
    ${result}=	Post Data To Endpoint	/assets/${assetId}	${JSON}	400
    set test variable	${msg}	${result.json()["message"]}
    set global variable	${API_Message}	${msg}
    [Return]	${msg}

Edit Product1 Asset
    [Arguments]	${assettemplate}    ${assetId}
    Sleep	3
    ${File}=	GET FILE	input/${assettemplate}
    ${File1}	extract and replace date	${File}
    ${File2}	extract and replace random project no  	${File1}
    ${File3}	extract and replace random quote no  	${File2}
    ${File4}	extract and replace random order no  	${File3}
    ${JSON}	replace variables	${File4}
    ${result}=	Post Data To Endpoint	/assets/${assetId}	${JSON}	200
    set global variable  ${response_api}    ${result}
    set test variable	${asset_Id}	${result.json()["data"]["assetId"]}
    set global variable	${asset_Id_Product1}	${asset_Id}
    log to console	"Asset2 Product1_ID": ${asset_Id_Product1}
    set test variable	${owner_ref}	${result.json()["data"]["taxonomy"][1]["value"]}
    set global variable	${Asset_Owner_Ref_modify}	${owner_ref}
    log to console	"Owner_Reference": ${owner_ref}
    ${Col_Id}   col_id  ${result.json()}
    set test variable	${C_Id}    ${Col_Id}
    set global variable	${Collection_Id}    ${Col_Id}
    log to console	"Collection_ID": ${Collection_Id}
    ${order_no}     get_col_order_no    ${result.json()}
    set test variable	${C_Order_no}    ${order_no}
    set global variable	${Asset1_Collection_Order_no_edit}	${order_no}
    log to console	"Order_No": ${order_no}
    ${project_no}     get_col_project_no  ${result.json()}
    set test variable	${C_Project_no}    ${project_no}
    set global variable	${Asset1_Collection_Project_no_edit}	${project_no}
    log to console	"Project_No": ${project_no}
    ${quote_no}     get_col_quote_no  ${result.json()}
    set test variable	${C_Quote_no}    ${quote_no}
    set global variable	${Asset1_Collection_Quote_no_edit}	${quote_no}
    log to console	"Quote_No": ${quote_no}
    log to console	"standard_hierarchy_Id": ${standard_hierarchy_Id}

Get Context
    [Arguments]	${assetId}  ${assessmentId}     ${requirement_name}     ${requirement_subgroup_name}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}/standards/${assessmentId}/requirements/${requirement_name}/subrequirements/${requirement_subgroup_name}/context
    ${json_convert}	json load data	${response}
    ${result}	convert	${json_convert}
    [Return]	${result}

Get Sub-Requirement
    [Arguments]	${assetId}  ${assessmentId}     ${requirement_name}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}/standards/${assessmentId}/requirements/${requirement_name}/subrequirements/
    ${json_convert}	json load data	${response}
    ${result}	convert	${json_convert}
    [Return]	${result}

Get TP1Attribute8
    [Arguments]	${response}
    ${result}   tp1_att8  ${response}
    [Return]	${result}

Get Context Description
    [Arguments]	${response}     ${assetId}  ${assessmentParamId}
    ${result}   context_description  ${response}    ${assetId}  ${assessmentParamId}
    [Return]	${result}

Get Asset Linkages
    [Arguments]	${response}     ${assetId}  ${assessmentParamId}
    ${result}   has_asset_linkages  ${response}     ${assetId}  ${assessmentParamId}
    [Return]	${result}

Get Evaluated Clauses
    [Arguments]	${response}     ${assessmentParamId}
    ${result}   has_evaluated_clauses  ${response}  ${assessmentParamId}
    [Return]	${result}

Get Verdict Rendered
    [Arguments]	${response}     ${assessmentParamId}
    ${result}   verdict_rendered  ${response}   ${assessmentParamId}
    [Return]	${result}

Get Impact Evaluation
    [Arguments]	${response}     ${sub_requirement_name}
    ${result}   asset_changes_impacting_eval  ${response}   ${sub_requirement_name}
    [Return]	${result}

Get Evaluation Complete
    [Arguments]	${response}  ${sub_requirement_name}
    ${result}   is_eval_complete  ${response}   ${sub_requirement_name}
    [Return]	${result}

Get Asset Link Seq_Id
    [Arguments]	${response}     ${assetId}
    ${result}   asset_asset_link_seq_id  ${response}  ${assetId}
    [Return]	${result}

Get Assesment_ParamID1
    [Arguments]	${assetId}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}/standards/requirements
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	assessment_param_id1	${json}
    [Return]	${result}

Get Assesment_ParamID2
    [Arguments]	${assetId}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}/standards/requirements
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	assessment_param_id2	${json}
    [Return]	${result}

Expire PET
    [Arguments]	${hierarchy_Id}
    connect to database	@{database}
    ${old_end_date_hipar}	query	select effective_end_date from hierarchy_params where hierarchy_id = '${hierarchy_Id}';
    expire_hierarchy_params
    ${new_end_date_hipar}	query	select effective_end_date from hierarchy_params where hierarchy_id = '${hierarchy_Id}';
    ${old_end_date_hi}	query	select effective_end_date from hierarchy where hierarchy_id = '${hierarchy_Id}';
    expire hierarchy
    ${new_end_date_hi}	query	select effective_end_date from hierarchy where hierarchy_id = '${hierarchy_Id}';

Activate PET
    [Arguments]	${hierarchy_Id}
    connect to database	@{database}
    ${old_end_date_hipar}	query	select effective_end_date from hierarchy_params where hierarchy_id = '${hierarchy_Id}';
    Activate_hierarchy_params
    ${new_end_date_hipar}	query	select effective_end_date from hierarchy_params where hierarchy_id = '${hierarchy_Id}';
    ${old_end_date_hi}	query	select effective_end_date from hierarchy where hierarchy_id = '${hierarchy_Id}';
    Activate hierarchy
    ${new_end_date_hi}	query	select effective_end_date from hierarchy where hierarchy_id = '${hierarchy_Id}';

Get Asset Details
    [Arguments]	${assetId}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	asset_id	${json}
    [Return]	${result}

Mark Evaluation Complete
    [Arguments]     ${evaltemplate}     ${assetId}
    ${file}	Get File	input/${evaltemplate}
    ${JSON}=	replace variables	${file}
    ${result}=	Post Data To Endpoint	/assets/${assetId}/standards/evaluations	${JSON}	200
    [Return]	${result}

Get Asset Component Details
    [Arguments]	${assetId}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}/component
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	has_components	${json}
    [Return]	${result}

Details of an Asset for Content Type
    [Arguments]	${assetId}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/assetDetails/${assetId}?ContentType=true&user=000000
    ${json_convert}	json load data	${response}
    ${result}	convert	${json_convert}
    [Return]	${result}

Get Asset Attribute Value
    [Arguments]	${response}  ${attDataParamName}
    ${result}   get_asset_att_value  ${response}     ${attDataParamName}
    [Return]	${result}

Get Asset Attribute Value with seq
    [Arguments]	${response}  ${attDataParamName}     ${seqNo}
    ${result}   asset_att_value_seq  ${response}     ${attDataParamName}     ${seqNo}
    [Return]	${result}

Get Asset Linkage Value
    [Arguments]	${response}  ${attDataParamName}
    ${result}   asset_linkage_value  ${response}     ${attDataParamName}
    [Return]	${result}

Get Asset Linkage Value with seq
    [Arguments]	${response}  ${attDataParamName}     ${seqNo}
    ${result}   asset_linkage_value_seq  ${response}     ${attDataParamName}     ${seqNo}
    [Return]	${result}
