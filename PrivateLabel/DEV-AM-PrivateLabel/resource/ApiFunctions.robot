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
Library  urllib2.CacheFTPHandler
Library  requests.api
Resource  Variables.robot
Resource  JsonExtractor.robot
Resource  DEV_ENV_Variables.robot

*** Keywords ***
### Automation Methods are divided into following section###

################################
################################
####### General Section ########
################################
################################
Get Authentication Token by OAuth2
    [Arguments]
    Create Session    OA2    ${AUTH_ENDPOINT}    verify=${True}
    ${data}=     Create Dictionary   grant_type=${Grant_Type}   client_Id=${Client_ID}     Client_Secret=${Client_Secret}    scope=${Scope}
    ${headers}=   Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${resp}=    Post Request    OA2    ${EMPTY}    ${data}    ${headers}
    Should Be Equal As Strings    ${resp.status_code}    200
    ${accessToken}=    evaluate    $resp.json().get("access_token")
    ${token}=    catenate    Bearer    ${accessToken}
    Log to Console    ${token}
    set global variable  ${token}   ${token}
    ${headers}=  Create Dictionary    Authorization=${token}
    set global variable  ${auth_headers}   ${headers}
#    Create Session    GT    <Your Server URL>    verify=${True}
#    ${resp}=  Get Request  GT    <Your API URL>    headers=${headers1}
#    Should Be Equal As Strings    ${resp.status_code}    200

GET Data From Endpoint
    [Arguments]	${endpoint}	${expectedStatusCode}=200
    ${headers}=	Create Dictionary	Content-Type=application/json
    Create Session	GET  ${API_ENDPOINT}  ${headers}  verify=${True}
    ${response}=	Get Request  GET  ${endpoint}
    set global variable  ${response_api}    ${response._content}
    ${status_404}  set variable if  ${response.status_code}==404  HTTP Error 404: Not Found
    set global variable  ${status_404}  ${status_404}
    ${status_405}  set variable if  ${response.status_code}==405  HTTP Error 405: Method Not Allowed
    set global variable  ${status_405}  ${status_405}
    run keyword if  ${response.status_code}!=200    Should Be Equal As Strings	${expectedStatusCode}	${response.status_code}
    delete all sessions
    [Return]	${response}

Post Data To Endpoint
    [Arguments]	${endpoint}	${data}	${expectedStatusCode}=200
    ${headers}=	Create Dictionary	Content-Type=application/json
    Create Session	thePost	${API_ENDPOINT}	${headers}  verify=${True}
    ${response}=	Post Request	thePost	${endpoint}	${data}
    set global variable  ${response_api}    ${response._content}
    ${status_404}  set variable if  ${response.status_code}==404  HTTP Error 404: Not Found
    set global variable  ${status_404}  ${status_404}
    run keyword if  ${response.status_code}!=200    Should Be Equal As Strings	${expectedStatusCode}	${response.status_code}
    delete all sessions
    [Return]	${response}

Post Data To Endpoint for 202
    [Arguments]	${endpoint}	${data}	${expectedStatusCode}=202
    ${headers}=	Create Dictionary	Content-Type=application/json
    Create Session	thePost	${API_ENDPOINT}	headers=${headers}
    ${response}=	Post Request	thePost	${endpoint}	${data}
    Should Be Equal As Strings	${expectedStatusCode}	${response.status_code}
    delete all sessions
    [Return]	${response}

################################
################################
######## Asset Section #########
################################
################################
Get Asset From Endpoint
    [Arguments]	${assetId}	${expectedStatusCode}=200
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/assetDetails/${assetId}?user=81349
    ${json_convert}	json load data	${response}
    ${result}	convert	${json_convert}
    clear cache
    [Return]	${result}

Create Product1 Asset
    [Arguments]	${assettemplate}
    ${today_date}     today_date
    set global variable  ${today_date}  ${today_date}
    ${random_number}     random_number
    set global variable  ${random_ref_number_1}  ${random_number}
    ${time}   current_time
    set global variable  ${current_time}  ${time}
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
    set global variable	${Asset1_Owner_Ref}	${Asset_Owner_Ref}
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
    ${random_number}     random_number
    set global variable  ${random_ref_number_1}  ${random_number}
    ${time}   current_time
    set global variable  ${current_time}  ${time}
    ${File}=	GET FILE	input/${assettemplate}
    ${File1}	extract and replace random owner ref	${File}
    ${File2}	extract and replace random project no  	${File1}
    ${File3}	extract and replace random quote no  	${File2}
    ${File4}	extract and replace random order no  	${File3}
    ${FILE2}	extract and replace date	${File4}
    ${JSON}	replace variables	${FILE2}
    ${result}=	Post Data To Endpoint    /assets     ${JSON}	200
    set global variable  ${response_api}    ${result}
    set test variable	${asset_Id}	${result.json()["data"]["assetId"]}
    set global variable	${asset_Id_Product1}	${asset_Id}
    log to console	"Asset Product1_ID": ${asset_Id_Product1}
    set test variable	${owner_ref}	${result.json()["data"]["taxonomy"][1]["value"]}
    set global variable	${Asset_Owner_Ref}	${owner_ref}
    set global variable	${Asset1_Owner_Ref}	${Asset_Owner_Ref}
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
    ${random_number}     random_number
    set global variable  ${random_ref_number_1}  ${random_number}
    ${time}   current_time
    set global variable  ${current_time}  ${time}
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
    set global variable	${Asset1_Owner_Ref}	${Asset_Owner_Ref}
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
    ${random_number}     random_number
    set global variable  ${random_ref_number_1}  ${random_number}
#    ${time}   current_time
#    set global variable  ${current_time}  ${time}
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
    set global variable	${Prod2_Owner_Ref}	${owner_ref}
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
    ${random_number}     random_number
    set global variable  ${random_ref_number_1}  ${random_number}
    ${time}   current_time
    set global variable  ${current_time}  ${time}
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
    ${random_number}     random_number
    set global variable  ${random_ref_number_1}  ${random_number}
    ${time}   current_time
    set global variable  ${current_time}  ${time}
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
    ${random_number}     random_number
    set global variable  ${random_ref_number_1}  ${random_number}
    ${time}   current_time
    set global variable  ${current_time}  ${time}
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
    ${random_number}     random_number
    set global variable  ${random_ref_number_1}  ${random_number}
    ${time}   current_time
    set global variable  ${current_time}  ${time}
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
    ${random_number}     random_number
    set global variable  ${random_ref_number_1}  ${random_number}
    ${time}   current_time
    set global variable  ${current_time}  ${time}
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

create Asset2 based on product1 Asset1
    [Arguments]	${assettemplate}
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
    ${File}=	GET FILE	input/${assettemplate}
    ${File1}	extract and replace random project no  	${File}
    ${FILE2}	extract and replace date	${File1}
    ${JSON}	replace variables	${FILE2}
    ${result}=	Post Data To Endpoint	/assets	${JSON}	400
    set test variable	${msg}	${result.json()["message"]}
    set global variable	${API_Message}	${msg}
    [Return]	${msg}

Get Asset State
    [Arguments]	${endpoint}
    connect to database	@{database}
    ${state}	query	select state from state where entity_id = '${endpoint}';
    ${result}	asset_state	${state}
    disconnect from database
    clear cache
    [Return]	${result}

Get AssesmentID
    [Arguments]	${assetId}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}/standards
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	assessment id	${json}
    set global variable	${assessmentId}	${result}
    log to console	"Assessment_Id": ${assessmentId}
    clear cache
    [Return]	${result}

Standard Assignment
    [Arguments]	${standardtemplate}	${assetId}
    ${FILE}	GET FILE	input/${standardtemplate}
    ${JSON}	replace variables	${FILE}
    ${result}=	Post Data To Endpoint	/assets/${assetId}/standards	${JSON}	200
    ${tx_id}    standard_transaction_id    ${response_api}
    set global variable  ${std_transaction_Id}   ${tx_id}

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
    clear cache

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
    Sleep	3
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}/standards/evaluations?assessmentId=${assessmentId}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	verdict  ${json}
    clear cache
    [Return]	${result}

AEO details
    [Arguments]	${assetId}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}/standards/evaluations?assessmentId=${assessmentId}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	aeo_detail	${json}
    clear cache
    [Return]	${result}

Notes
    [Arguments]	${assetId}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}/standards/evaluations?assessmentId=${assessmentId}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	note	${json}
    clear cache
    [Return]	${result}

Clause Text
    [Arguments]	${assetId}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}/standards/evaluations?assessmentId=${assessmentId}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	cl_text	${json}
    clear cache
    [Return]	${result}

Clause ID
    [Arguments]	${assetId}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}/standards/evaluations?assessmentId=${assessmentId}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	cl_id	${json}
    clear cache
    [Return]	${result}

Table Number
    [Arguments]	${assetId}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}/standards/evaluations?assessmentId=${assessmentId}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	table_no	${json}
    clear cache
    [Return]	${result}

Get ULAssetID
    [Arguments]	${assetId}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	ulAsset id  ${json}
    log to console	"ulAsset_Id": ${result}
    clear cache
    [Return]	${result}

Expire The Asset
    [Documentation]	Expires an asset by its assetId.	'Expire The Asset	assetId'
    [Arguments]	${assetId}
    connect to database	@{database}
    ${taxonomy_id}	query	select taxonomy_id from asset where asset_id = '${assetId}';
    ${split}	extract_value	${taxonomy_id}
    set global variable	${Taxonomy_id}	${split}
    update end date
    disconnect from database

Get Shared Attributes
    [Arguments]	${productType}
    ${response}=	open url    ${API_ENDPOINT}/assets/template?attribProductType=${productType}
    set global variable  ${response_api}  ${response}
    ${json}	json loads data	${response_api}
    ${result}   shared_att   ${json}
    clear cache
    [Return]	${result}

Get Metadata Shared Attributes
    [Arguments]	${productType}
    ${response}=	open url  	${API_ENDPOINT}/assets/hierarchy/metadata?metadataType=${productType}&user=${user_id}
    set global variable  ${response_api}  ${response}
    ${json}	json loads data	${response_api}
    ${result}   metadata_shared_att   ${json}
    clear cache
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
    disconnect from database
    [Return]	${result}

Validate On End
    [Arguments]	${assetId}
    ${response}=	open url	${API_ENDPOINT}/assets/${assetId}/validate
    set global variable  ${response_api}  ${response}
    ${json}	json loads data	${response_api}
    ${message}   validate_on_end_message  ${json}
    clear cache
    [Return]	${message}

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

Modify Product1 Asset
    [Arguments]	${assettemplate}    ${assetId}
    Sleep	1
    ${File}=	GET FILE	input/${assettemplate}
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

Link Components to Asset
    [Arguments]	${assettemplate}    ${assetId}
	${file}=	Get File	input/${assettemplate}
	${JSON}=	replace variables	${file}
	${result}=	Post Data To Endpoint	/assets/${assetId}/components	${JSON}	200
	[Return]	${result}

Edit Product1 Asset for 400
    [Arguments]	${assettemplate}    ${assetId}
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
    clear cache
    [Return]	${result}

Get Sub-Requirement
    [Arguments]	${assetId}  ${assessmentId}     ${requirement_name}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}/standards/${assessmentId}/requirements/${requirement_name}/subrequirements/
    ${json_convert}	json load data	${response}
    ${result}	convert	${json_convert}
    clear cache
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
    clear cache
    [Return]	${result}

Get Assesment_ParamID2
    [Arguments]	${assetId}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}/standards/requirements
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	assessment_param_id2	${json}
    clear cache
    [Return]	${result}

Get TP1Attribute11
    [Arguments]	${response}
    ${result}   tp1_att11  ${response}
    [Return]	${result}

Post Data To Endpoint for 400
    [Arguments]	${endpoint}	${data}	${expectedStatusCode}=400
    ${headers}=	Create Dictionary	Content-Type=application/json
    Create Session	thePost	${API_ENDPOINT}	headers=${headers}
    ${response}=	Post Request	thePost	${endpoint}     ${data}
    set global variable  ${response_api}    ${response._content}
    Should Be Equal As Strings	${expectedStatusCode}	${response.status_code}
    delete all sessions
    [Return]	${response._content}

Link Product2 to Certificate
#Created New Keyword (Add Assets To Certificate) adding CertificateID as Argument
   [Arguments]	${certtemplate}
   Sleep	1
   ${File}=     GET FILE    input/${certtemplate}
   ${JSON}	replace variables	${File}
   ${response}=  Post Data To Endpoint	/assets/certificate/${Certificate_Id_Modify}/assets	${JSON}     200
   ${cert_Id}   certificate_id  ${response.json()}     ${asset_Id_Product12}
   set global variable	${Certificate_Id12}	${cert_Id}
   ${trans_Id}   transaction_id  ${response.json()}     ${asset_Id_Product12}
   set global variable	${Transaction_Id12}  ${trans_Id}
   log to console	"Certificate ID": ${Certificate_Id12}
   log to console	"Transaction ID": ${Transaction_Id12}
   [Return]  ${response}

Get Evaluation Scope Comments
    [Arguments]	${tx_Id}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/assets/evaluationComments?transactionId=${tx_Id}&contentType=true
    set global variable  ${response_search_api}  ${response.read()}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    ${result}	eval_comments  ${json}
    clear cache
    [Return]	${result}

Get Guidance Notes AP1
    [Arguments]	${response}
    ${gd_notes_ap1}    get_gd_notes_ap1    ${response}
    [Return]	${gd_notes_ap1}

Get Guidance Notes AP1_2
    [Arguments]	${response}
    ${gd_notes_ap1_2}    get_gd_notes_ap1_2    ${response}
    [Return]	${gd_notes_ap1_2}

Get Guidance Notes AP2
    [Arguments]	${response}
    ${gd_notes_ap2}    get_gd_notes_ap2    ${response}
    [Return]	${gd_notes_ap2}

Get Guidance Notes RP1
    [Arguments]	${response}
    ${gd_notes_rp1}    get_gd_notes_rp1    ${response}
    [Return]	${gd_notes_rp1}

Get Guidance Notes RP1_2
    [Arguments]	${response}
    ${gd_notes_rp1_2}    get_gd_notes_rp1_2    ${response}
    [Return]	${gd_notes_rp1_2}

Get Reviewer Summary Details
    [Arguments]	${assetId}  ${assessmentId}
    ${response}=    open url	${API_ENDPOINT}/assets/${assetId}/standards/evaluations/${assessmentId}
    set global variable  ${response_search_api}  ${response}
    ${result}  reviewer_summary_details  ${response_search_api}
    clear cache
    [Return]	${result}

Get Reviewer Summary Details For Multiple Subgroups
    [Arguments]	${assetId}  ${assessmentId}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}/standards/evaluations/${assessmentId}
    set global variable  ${response_search_api}  ${response.read()}
    ${result}  reviewer_summary_details_for_multiple_sub_grp  ${response_search_api}
    clear cache
    [Return]	${result}

Set Evaluation Remarks
   [Arguments]	${evalremarktemplate}
   ${File}=     GET FILE    input/${evalremarktemplate}
   ${JSON}	replace variables	${FILE}
   ${result}=	Post Data To Endpoint	/assets/evaluationRemarks	${JSON}	200
   set test variable	${eval_remark}   ${result.json()["data"]["comments"]}
   set global variable	${Evaluation_Remark}	${eval_remark}
   log to console	"Evaluation Remark": ${Evaluation_Remark}

#This can be further improved by extracting multiple clause id . Currentely it extracts very first ID
Get AssessmentCluaseId
    [Arguments]	${asset_assmnt_param_id}
    connect to database	@{database}
    ${asset_assmnt_cl_id}	query	select asset_assmnt_clause_id from asset_assessment_clause where asset_assmnt_param_id = '${asset_assmnt_param_id}';
    ${result}   ass_mnt_cls_id_regex   ${asset_assmnt_cl_id}
    set global variable  ${asset_assmnt_clause_id}  ${result}
    log to console	"AssessmentCluaseId": ${result}
    disconnect from database
    [Return]	${result}

Get Reviewer Summary Questions Details
   [Arguments]	${assetId}  ${assessmentCluaseId}   ${key}
   ${response}=    open url	${API_ENDPOINT}/assets/${assetId}/standards/evaluations/clause/${assessmentCluaseId}
   set global variable  ${reviewer_summary_api}  ${response}
   ${reviewer_summary}	reviewer_summary_questions   ${reviewer_summary_api}    ${key}
   set global variable  ${reviewer_summary_questions}  ${reviewer_summary}
#   set global variable  ${result}  ${response.getcode()}
   clear cache
   [Return]	${reviewer_summary_api}

Get Assesment_ParamID_2onward
    [Arguments]	${assetId}   ${group}   ${subgrp}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}/standards/requirements
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	assessment_param_id_2onwards	${json}  ${group}   ${subgrp}
    set global variable	${assessmentParamId}	${result}
    log to console	"Assessment_Param_Id_for_${group}<<${subgrp}>>": ${assessmentParamId}
    log to console  ${result}
    clear cache

create Asset3 based on product1 Asset1
    [Arguments]	${assettemplate}
    Sleep	1
    ${File}=	GET FILE	input/${assettemplate}
    ${FILE1}	extract and replace date	${File}
    ${JSON}	replace variables	${FILE1}
    ${result}=	Post Data To Endpoint	/assets	${JSON}	200
    set global variable  ${response_api}    ${result}
    set test variable	${asset_Id}	${result.json()["data"]["assetId"]}
    set global variable	${asset_Id_Product13}	${asset_Id}
    log to console	"Asset3 Product1_ID": ${asset_Id_Product13}
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
    set test variable	${msg}	${result.json()["message"]}
    set global variable	${API_Message}	${msg}
    log to console	"API_Message": ${API_Message}

create Asset4 based on product1 Asset1
    [Arguments]	${assettemplate}
    Sleep	1
    ${File}=	GET FILE	input/${assettemplate}
    ${FILE1}	extract and replace date	${File}
    ${JSON}	replace variables	${FILE1}
    ${result}=	Post Data To Endpoint	/assets	${JSON}	200
    set global variable  ${response_api}    ${result}
    set test variable	${asset_Id}	${result.json()["data"]["assetId"]}
    set global variable	${asset_Id_Product14}	${asset_Id}
    log to console	"Asset4 Product1_ID": ${asset_Id_Product14}
    set test variable	${owner_ref}	${result.json()["data"]["taxonomy"][1]["value"]}
    set global variable	${Asset_Owner_Ref}	${owner_ref}
    log to console	"Owner_Reference": ${owner_ref}
    ${Col_Id}   col_id  ${result.json()}
    set test variable	${C_Id}    ${Col_Id}
    set global variable	${Collection_Id}    ${Col_Id}
    set global variable	${Asset4_Collection_Id}  ${Collection_Id}
    log to console	"Collection_ID": ${Collection_Id}
    ${order_no}     get_col_order_no    ${result.json()}
    set test variable	${C_Order_no}    ${order_no}
    set global variable	${Collection_Order_no}	${order_no}
    set global variable	${Asset4_Collection_Order_no}	${Collection_Order_no}
    log to console	"Order_No": ${order_no}
    ${project_no}     get_col_project_no  ${result.json()}
    set test variable	${C_Project_no}    ${project_no}
    set global variable	${Collection_Project_no}	${project_no}
    set global variable	${Asset4_Collection_Project_no}	${Collection_Project_no}
    log to console	"Project_No": ${project_no}
    ${quote_no}     get_col_quote_no  ${result.json()}
    set test variable	${C_quote_no}    ${quote_no}
    set global variable	${Collection_Quote_no}	${quote_no}
    set global variable	${Asset4_Collection_Quote_no}	${Collection_Quote_no}
    log to console	"Quote_No": ${quote_no}
    log to console	"standard_hierarchy_Id": ${standard_hierarchy_Id}
    set test variable	${msg}	${result.json()["message"]}
    set global variable	${API_Message}	${msg}
    log to console	"API_Message": ${API_Message}

create Asset5 based on product1 Asset1
    [Arguments]	${assettemplate}
    Sleep	1
    ${File}=	GET FILE	input/${assettemplate}
    ${FILE1}	extract and replace date	${File}
    ${JSON}	replace variables	${FILE1}
    ${result}=	Post Data To Endpoint	/assets	${JSON}	200
    set global variable  ${response_api}    ${result}
    set test variable	${asset_Id}	${result.json()["data"]["assetId"]}
    set global variable	${asset_Id_Product15}	${asset_Id}
    log to console	"Asset5 Product1_ID": ${asset_Id_Product15}
    set test variable	${owner_ref}	${result.json()["data"]["taxonomy"][1]["value"]}
    set global variable	${Asset_Owner_Ref}	${owner_ref}
    log to console	"Owner_Reference": ${owner_ref}
    ${Col_Id}   col_id  ${result.json()}
    set test variable	${C_Id}    ${Col_Id}
    set global variable	${Collection_Id}    ${Col_Id}
    set global variable	${Asset5_Collection_Id}  ${Collection_Id}
    log to console	"Collection_ID": ${Collection_Id}
    ${order_no}     get_col_order_no    ${result.json()}
    set test variable	${C_Order_no}    ${order_no}
    set global variable	${Collection_Order_no}	${order_no}
    set global variable	${Asset5_Collection_Order_no}	${Collection_Order_no}
    log to console	"Order_No": ${order_no}
    ${project_no}     get_col_project_no  ${result.json()}
    set test variable	${C_Project_no}    ${project_no}
    set global variable	${Collection_Project_no}	${project_no}
    set global variable	${Asset5_Collection_Project_no}	${Collection_Project_no}
    log to console	"Project_No": ${project_no}
    ${quote_no}     get_col_quote_no  ${result.json()}
    set test variable	${C_quote_no}    ${quote_no}
    set global variable	${Collection_Quote_no}	${quote_no}
    set global variable	${Asset5_Collection_Quote_no}	${Collection_Quote_no}
    log to console	"Quote_No": ${quote_no}
    log to console	"standard_hierarchy_Id": ${standard_hierarchy_Id}
    set test variable	${msg}	${result.json()["message"]}
    set global variable	${API_Message}	${msg}
    log to console	"API_Message": ${API_Message}

Create Product1 Asset2
    [Arguments]	${assettemplate}
    ${random_number}     random_number
    set global variable  ${random_ref_number_1}  ${random_number}
#    ${time}   current_time
#    set global variable  ${current_time}  ${time}
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
    set global variable	${asset2_Id_Product1}	${asset_Id}
    log to console	"Asset Product1_ID": ${asset_Id_Product1}
    set test variable	${owner_ref}	${result.json()["data"]["taxonomy"][1]["value"]}
    set global variable	${Asset2_Owner_Ref}	${owner_ref}
    log to console	"Owner_Reference": ${owner_ref}
    set test variable	${reference_num}	${result.json()["data"]["taxonomy"][2]["value"]}
    set global variable	${Asset2_Ref_No}	${reference_num}
    log to console	"Reference_num": ${reference_num}
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

Get Asset Details using Role
    [Arguments]	${assetId}   ${role_name}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}?role=${role_name}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${attr}     role_attributes     ${json}
    set global variable  ${Asset_attr}    ${attr}
    ${coll_id}	col_id	${json}
    set global variable     ${Asset_Collection_Id}	${coll_id}
    log to console	"Asset_Collection_Id": ${Collection_Id}
    clear cache
    [Return]	${attr}

Get Asset Details using UserId
    [Arguments]	${assetId}   ${user_id}
    ${response}=	GET Data From Endpoint  	/assets/${assetId}?user=${user_id}
    ${json}	json loads data	${response_api}
    ${attr}     role_attributes     ${json}
    set global variable  ${Asset_attr}    ${attr}
    ${coll_id}	col_id	${json}
    set global variable     ${Asset_Collection_Id}	${coll_id}
    log to console	"Asset_Collection_Id": ${Collection_Id}
    clear cache
    [Return]	${attr}

Get Asset Details using UserId & Role
    [Arguments]	${assetId}   ${user_id}  ${role_name}
    ${response}=	open url  	${API_ENDPOINT}/assets/${assetId}?user=${user_id}&role=${role_name}
    ${json}	json loads data	${response}
    ${attr}     role_attributes     ${json}
    set global variable  ${Asset_attr}    ${attr}
    ${coll_id}	col_id	${json}
    set global variable     ${Asset_Collection_Id}	${coll_id}
    log to console	"Asset_Collection_Id": ${Collection_Id}
    clear cache
    [Return]	${attr}

Get Asset Details
    [Arguments]	${assetId}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${attr}     role_attributes     ${json}
    set global variable  ${Asset_attr}    ${attr}
    ${coll_id}	col_id	${json}
    set global variable     ${Asset_Collection_Id}	${coll_id}
    log to console	"Asset_Collection_Id": ${Collection_Id}
    clear cache
    [Return]	${attr}

Get Component Details
    [Arguments]	${assetId}   ${asset_parameters}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}/component?${asset_parameters}
    set global variable  ${response_api}  ${response.read()}
    ${json_convert}	json loads data	${response_api}
    ${json}	convert	${json_convert}
    ${comp}     get_components     ${json}
    set global variable  ${components}    ${comp}
    ${asset_id}	component_asset_id	${json}
    set global variable     ${comp_asset_id}	${asset_id}
    clear cache
    [Return]	${comp}

Summary of Asset
    [Arguments]	${Search_Parameter}
#    sleep  30
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/assetSummary?${Search_Parameter}
    set test variable  ${response_api}  ${response.read()}
    ${json_convert}	json loads data	${response_api}
    ${json}	convert  ${json_convert}
    ${result}	summary_asset_id	${json}
    clear cache
    [Return]	${result}

Summary of Asset with Error
    [Arguments]	${Search_Parameter}
    ${response}   requests.api.get   ${API_ENDPOINT}/assets/assetSummary?${Search_Parameter}
    set test variable  ${response_body}  ${response.json()}
#    ${response}  extract_error    ${request}
#    ${json_convert}	json load data	${response_body}
    ${json}	convert  ${response_body}
    ${msg}	error_msg  	${json}
    set global variable  ${err_msg}  ${msg}
    ${code}	error_code  	${json}
    set global variable  ${err_code}  ${code}
    clear cache
    [Return]	${err_msg}

Details of an Asset
    [Arguments]	${assetId}   ${asset_parameters}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/assetDetails/${assetId}?${asset_parameters}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${attr}     role_attributes     ${json}
    set global variable  ${Asset_attr}    ${attr}
    ${coll_id}	col_id	${json}
    set global variable     ${Asset_Collection_Id}	${coll_id}
    log to console	"Asset_Collection_Id": ${Collection_Id}
    ${data}  get_data    ${json}
    ${assetId}   get_object_values    ${data}    ${assetId_key}
    set global variable  ${Asset_Id}    ${assetId}
    ${ul_assetId}   get_object_values    ${data}    ${ulAssetId_key}
    set global variable  ${UL_Asset_Id}    ${ul_assetId}
    ${status}   get_object_values    ${data}    ${status_key}
    set global variable  ${Asset_status}    ${status}
    ${taxonomy}   get_object_values    ${data}    ${taxonomy_key}
    set global variable  ${Asset_taxonomy}    ${taxonomy}
    should not be empty  ${Asset_taxonomy}
    ${hierarchy}   get_object_values    ${data}    ${hierarchy_key}
    set global variable  ${Asset_hierarchy}    ${hierarchy}
    should not be empty  ${Asset_hierarchy}
    ${attributes}   get_object_values    ${data}    ${attributes_key}
    set global variable  ${Asset_attributes}    ${attributes}
    clear cache
    [Return]	${attr}

Search Asset
    [Arguments]	${assettemplate}
#    ${time}    current_time
#    set global variable  ${current_time}  ${time}
    Sleep	30
    ${File}=	GET FILE	input/Asset/Search/${assettemplate}
    ${JSON}	replace variables	${File}
    ${result}=	Post Data To Endpoint	/assets/summary	${JSON}	200
    set global variable  ${Asset_summary_response_api}  ${response_api}
    ${json_convert}	json loads data  ${Asset_summary_response_api}
    ${json}	convert	${json_convert}
    set global variable  ${Asset_summary_json}  ${json}
    [Return]	${Asset_summary_response_api}



################################
################################
### Multi-Model / Collection ###
################################
################################

Get Collection Attributes
    [Arguments]	${productType}
    ${response}=	open url	${API_ENDPOINT}/assets/template?attribProductType=${productType}
    set global variable  ${response_api}  ${response}
    ${json}	json loads data	${response_api}
    ${result}   col_att   ${json}
    clear cache
    [Return]	${result}

Get Metadata Collection Attributes
    [Arguments]	${productType}
    ${response}=	open url  	${API_ENDPOINT}/assets/hierarchy/metadata?metadataType=${productType}&user=${user_id}
    set global variable  ${response_api}  ${response}
    ${json}	json loads data	${response_api}
    ${result}   metadata_col_att   ${json}
    clear cache
    [Return]	${result}

Get Collection_ID
    [Arguments]	${assetId}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/${assetId}?user=${user_id}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	col_id	${json}
    set test variable  ${c_id}  ${result}
    set global variable     ${Collection_Id}	${c_id}
    log to console	"Asset_Collection_Id": ${Collection_Id}
    clear cache

Edit Asset Collection Attribute
    [Arguments]	${assettemplate}    ${assetId}
    Sleep	1
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
    disconnect from database
    [Return]	${result}

Search Collection
    [Arguments]	${Search_Parameter}
    ${response}=	open url	${API_ENDPOINT}/collections/collectionSummary?${Search_Parameter}&exactSearch=true
    set global variable  ${response_api}  ${response}
    ${json}	json loads data	${response_api}
    ${result}	summary_col_id	${json}
    clear cache
    [Return]	${result}

Get Component of Asset In Collection
    [Arguments]	${col_id}
    ${response}=	open url	${API_ENDPOINT}/collections/${col_id}/components
    set global variable  ${response_api}  ${response}
    ${json}	json loads data	${response_api}
    ${result}	comp_id	${json}
    clear cache
    [Return]	${result}

Get Error Message for Get Compoenent of Asset In Collection
    [Arguments]	${col_id}
    ${response}=  HttpLibrary.HTTP.get  ${API_ENDPOINT}/collections/${col_id}/components/
    [Return]	   ${response}

Get Error Message for Get Compoenent of Asset In Collection with asset_id
    [Arguments]	${col_id}   ${asst_id}
    ${response}=  open url  ${API_ENDPOINT}/collections/${col_id}/components?assetId=${asst_id}
    set global variable  ${response_api}  ${response}
    ${json}	json loads data	${response_api}
    clear cache
    [Return]	   ${response}

Get Error Message
    [Arguments]	${response}
    ${result}	err_msg	${response}
    [Return]	${result}

Get Alternate Component of Asset In Colletion
    [Arguments]	${col_id}
    ${response}=     urllib2.urlopen	${API_ENDPOINT}/collections/${col_id}/components
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	alternate_component_id	${json}
    clear cache
    [Return]	${result}

Get Component of Asset In Collection with asset_id
    [Arguments]	${col_id}   ${asset_id}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/collections/${col_id}/components?assetId=${asset_id}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	comp_id	${json}
    clear cache
    [Return]	${result}

Get Alternate Compoenent of Asset In Collection with asset_id
    [Arguments]	${col_id}   ${asset_id}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/collections/${col_id}/components?assetId=${asset_id}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	alternate_component_id	${json}
    clear cache
    [Return]	${result}

Get Collection Details
    [Arguments]	${col_id}
    ${response}=	open url	${API_ENDPOINT}/collections/collectionDetails/${col_id}
    set global variable  ${response_api}  ${response}
    ${json}	json loads data	${response_api}
    ${result}	col_id	${json}
    clear cache
    [Return]	${result}

Get Collection Details_one_asset_Id
    [Arguments]	${col_id}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/collections/collectionDetails/${col_id}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	col_asset_id_1	${json}
    clear cache
    [Return]	${result}

Get Collection Details_two_asset_Id
    [Arguments]	${col_id}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/collections/collectionDetails/${col_id}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result1}	col_asset_id_1	${json}
    ${result2}	col_asset_id_2	${json}
    clear cache
    [Return]	${result1}  ${result2}

Get Col_ID
    [Arguments]	${paramater}
    ${response}=	open url	${API_ENDPOINT}/collections/getCollectionId?${paramater}
    set global variable  ${response_api}  ${response}
    ${json}	json loads data	${response_api}
    ${json1}    json dumps  ${json}
    set global variable  ${response_api}    ${json1}
    ${result}	col_id	${json}
    set test variable  ${c_id}  ${result}
    set global variable     ${Collection_Id}	${c_id}
    log to console	"Asset_Collection_Id": ${Collection_Id}
    clear cache

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

Search Collection With Exact Search as False
    [Arguments]	${Search_Parameter}
    ${response}=	open url	${API_ENDPOINT}/collections/collectionSummary?${Search_Parameter}&exactSearch=false
    set global variable  ${response_api}  ${response}
    ${json}	json loads data	${response_api}
    ${json1}    json dumps  ${json}
    set global variable  ${response_api}    ${json1}
    ${result}	summary_col_id	${json}
    clear cache
    [Return]	${result}


Complete Evaluation with CollectionID
    [Arguments]	${evaltemplate}	${assetId}  ${collectionId}
    ${file}	Get File	input/${evaltemplate}
    ${JSON}=	replace variables	${file}
    ${result}=	Post Data To Endpoint	/collections/${collectionId}/standards/evaluations	${JSON}  200
    set test variable	${msg}	${result.json()["message"]}
    set global variable	${API_Message}	${msg}
    [Return]	${msg}

Validate and Update Compliance Collection Level
    [Arguments]	${compliance_template}   ${collection_Id}
    ${JSON}	Get File	input/${compliance_template}
    ${response}=	Post Data To Endpoint	assets/${collection_Id}/validate    ${JSON}  200
    set test variable	${status}	${response.json()["data"]["status"]}
    set global variable	${Validation_Status}	${status}
    set test variable	${errors}	${response.json()["data"]["hasError"]}
    set global variable	${Validation_Errors}	${errors}
    [Return]	${Validation_Status}

Get Validation Error for Update Compliance Collection Level
    [Arguments]	${response}  ${assetId}
    ${result}	validation_error_msgs	${response}  ${assetId}
    [Return]	${result}

################################
################################
##### Certificate Section  #####
################################
################################
Create Certificate
   [Arguments]	${certtemplate}
   Sleep	1
   ${File}=     GET FILE    input/${certtemplate}
   ${FILE2}	extract and replace date for certificate scheme  ${File}
   ${JSON}	replace variables	${FILE2}
   ${result}=	Post Data To Endpoint	/assets/certificate	${JSON}	200
   set test variable	${cert_Id}	${result.json()["data"]["certificateId"]}
   set global variable	${Certificate_Id}	${cert_Id}
   log to console	"Certificate ID": ${Certificate_Id}
   set test variable	${certificate_type}   ${result.json()["data"]["certificateType"]}
   set global variable	${scheme}	${certificate_type.replace(" ", "%20")}
   log to console	"Certificate Type": ${scheme}
   set test variable	${certificate_name}  ${result.json()["data"]["certificateName"]}
   set global variable	${Certificate_Name}  ${certificate_name}
   log to console	"Certificate Name": ${certificate_name}
   set test variable	${owner_ref}	${result.json()["data"]["ownerReference"]}
   set global variable	${Cert_Owner_Ref}	${owner_ref}
   log to console	"Owner_Reference": ${owner_ref}

Edit Certificate
   [Arguments]	${certtemplate}  ${Cert_Id}
   Sleep	1
   ${File}=     GET FILE    input/${certtemplate}
   ${FILE2}	extract and replace date for certificate scheme  ${File}
   ${JSON}	replace variables	${FILE2}
   ${result}=	Post Data To Endpoint	/assets/certificate/${Cert_Id}	${JSON}	200
   set test variable	${cert_Id}	${result.json()["data"]["certificateId"]}
   set global variable	${Certificate_Id_Edit}	${cert_Id}
   log to console	"Certificate ID after Edit": ${Certificate_Id_Edit}
   set test variable	${certificate_type}   ${result.json()["data"]["certificateType"]}
   set global variable	${Certificate_type_Edit}  ${certificate_type}
   log to console	"Certificate Type after Edit": ${Certificate_type_Edit}
   set test variable	${certificate_name}  ${result.json()["data"]["certificateName"]}
   set global variable	${Certificate_Name_Edit}  ${certificate_name}
   log to console	"Certificate Name after Edit": ${certificate_Name_Edit}
   set test variable	${owner_ref}	${result.json()["data"]["ownerReference"]}
   set global variable	${Cert_Owner_Ref_Edit}	${owner_ref}
   log to console	"Owner_Reference after Edit": ${Cert_Owner_Ref_Edit}
   set test variable	${cert_hierarchy_Id}	${result.json()["data"]["hierarchyId"]}
   set global variable	${certificate_hierarchy_Id_Edit}	${cert_hierarchy_Id}
   log to console	"Certificate Hierarchy Id after Edit": ${certificate_hierarchy_Id_Edit}

Get Certificate Transaction Id
#Created New Keyword (Get Certificate TransactionId using Certificate Details) adding Cert Name, Cert Owner & Scheme as Arguments
    [Arguments]	${cert_name}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificateDetails?certificateType=${scheme}&ownerReference=${Asset_Owner_Ref}&certificateName=${cert_name}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	cert_transaction_id  ${json}
    set global variable	${Cert_Transaction_Id}	${result}
    log to console	"Transaction ID": ${Cert_Transaction_Id}
    clear cache
    [Return]	${Cert_Transaction_Id}

Link Product to Certificate
#Created New Keyword (Add Assets To Certificate) adding CertificateID as Argument
   [Arguments]	${certtemplate}
   Sleep	1
   ${File}=     GET FILE    input/${certtemplate}
   ${JSON}	replace variables	${File}
   ${response}=  Post Data To Endpoint	/assets/certificate/${Certificate_Id}/assets	${JSON}	200
   [Return]  ${response.text}

Associate Parties to Certificate
#Created New Keyword (Add Parties To Certificate) adding CertificateID as Argument
   [Arguments]	${certtemplate}
   ${File}=     GET FILE    input/${certtemplate}
   ${JSON}	replace variables	${FILE}
   ${result}=	Post Data To Endpoint	/assets/certificate/${Certificate_Id}/parties	${JSON}	200

#Certify Certificate
##with Older certficate API (Non-Modularized one) --> will be deprecated
#   [Arguments]	${certtemplate}
#   ${File}=     GET FILE    input/${certtemplate}
#   ${FILE2}	replace variables	${FILE}
#   ${JSON}	extract and replace issue date and withdrawal date and expiry date for certificate  ${FILE2}
#   ${response}=  Post Data To Endpoint	/assets/createCertificate	${JSON}	200
##   [Return]  ${response.text}

Certify Certificate
#with New certficate API (Modularized one)
#Created New Keyword (Add Decisions to Certificate) adding CertificateID as Argument
   [Arguments]	${certtemplate}
   ${File}=     GET FILE    input/${certtemplate}
   ${FILE2}	replace variables	${FILE}
   ${JSON}	extract and replace issue date and withdrawal date and expiry date for certificate  ${FILE2}
   ${response}=  Post Data To Endpoint	/assets/certificate/${Certificate_Id}/decisions	${JSON}	200
#   [Return]  ${response.text}

Certify Certificate with ED equal to CD
#with Older certficate API (Non-Modularized one) --> will be deprecated
   [Arguments]	${certtemplate}
   ${File}=     GET FILE    input/${certtemplate}
   ${FILE2}	replace variables	${FILE}
   ${JSON}	extract_and_replace_issue_date_and_withdrawal_date_and_expiry_date_for_certificate  ${FILE2}
   ${response}=  Post Data To Endpoint	/assets/createCertificate	${JSON}	200
#   [Return]  ${response.text}

Certify Certificate with WD equal to CD
#with Older certficate API (Non-Modularized one) --> will be deprecated
   [Arguments]	${certtemplate}
   ${File}=     GET FILE    input/${certtemplate}
   ${FILE2}	replace variables	${FILE}
   ${JSON}	extract_and_replace_issue_date_and_withdrawal_date_and_expiry_date_for_certificate  ${FILE2}
   ${response}=  Post Data To Endpoint	/assets/createCertificate	${JSON}	200
#   [Return]  ${response.text}

Select As Cert Scheme
#with Older certficate API (Non-Modularized one)
   [Arguments]	${certtemplate}
   ${File}=     GET FILE    input/${certtemplate}
   ${FILE2}	replace variables	${FILE}
   ${JSON}	extract and replace date for certificate scheme  ${FILE2}
   ${response}=  Post Data To Endpoint	/assets/createCertificate	${JSON}	200

Certificate Mark
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificateDetails?certificateType=Regression%20Scheme&ownerReference=${Asset_Owner_Ref}&certificateName=${Certificate_Name}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	Mark	${json}
    clear cache
    [Return]	${result}

Get certificate status
#Created New Keyword (Get certificate status with certificateId) adding CertificateID as Argument
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificateDetails?certificateId=${Certificate_Id}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	cert status	${json}
    clear cache
    [Return]	${result}

Get HasAssets
#Created New Keyword (Get HasAssets using Certificate Details) adding Cert Owner & CertID as Argument
    [Arguments]	${scheme}   ${cert_name}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificateDetails?certificateType=${scheme}&ownerReference=${Asset_Owner_Ref}&certificateName=${cert_name}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	has_assets  ${json}
    ${result1}  json dumps  ${result}
    set global variable	${has_Assets}	${result1}
    clear cache
    [Return]	${has_Assets}

Get HasAssets_2
    [Arguments]	${scheme}   ${cert_name}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificateDetails?certificateType=${scheme}&ownerReference=${Asset_Owner_Ref}&certificateName=${cert_name}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	has_assets_2  ${json}
    ${result1}  json dumps  ${result}
    set global variable	${has_Assets_2}	${result1}
    clear cache
    [Return]	${has_Assets_2}

Get HasEvaluations
#Created New Keyword (Get HasEvaluations using Certificate Details) adding Cert Owner & CertID as Argument
    [Arguments]	${scheme}   ${cert_name}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificateDetails?certificateType=${scheme}&ownerReference=${Asset_Owner_Ref}&certificateName=${cert_name}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	has_evaluations  ${json}
    ${result1}  json dumps  ${result}
    set global variable	${has_Evaluations}	${result1}
    clear cache
    [Return]	${has_Evaluations}

Get HasEvaluations_2
    [Arguments]	${scheme}   ${cert_name}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificateDetails?certificateType=${scheme}&ownerReference=${Asset_Owner_Ref}&certificateName=${cert_name}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	has_evaluations_2  ${json}
    ${result1}  json dumps  ${result}
    set global variable	${has_Evaluations_2}	${result1}
    clear cache
    [Return]	${has_Evaluations_2}

Get TransactionId_2
    [Arguments]	${scheme}   ${cert_name}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificateDetails?certificateType=${scheme}&ownerReference=${Asset_Owner_Ref}&certificateName=${cert_name}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	transaction_id_2  ${json}
    set global variable	${Transaction_Id_2}	${result}
    log to console	"Transaction ID_2": ${Transaction_Id_2}
    clear cache
    [Return]	${Transaction_Id_2}

Get CertificateId_2
    [Arguments]	${scheme}   ${cert_name}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificateDetails?certificateType=${scheme}&ownerReference=${Asset_Owner_Ref}&certificateName=${cert_name}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	certificate_id_2  ${json}
    set global variable	${Certificate_Id_2}	${result}
    log to console	"Certificate ID_2": ${Certificate_Id_2}
    clear cache
    [Return]	${Certificate_Id_2}

Unlock Certificate
    [Arguments]	${certtemplate}  ${cert_Id}
    ${JSON}=	GET FILE	input/${certtemplate}
    ${result}=	Post Data To Endpoint	/assets/certificate/unlock?certificateId=${cert_Id}  ${JSON}	200
    [Return]	${result}

Search Certificate
    [Arguments]	${Search_Parameter}
    ${response}=	open url	${API_ENDPOINT}/assets/certificateSummary?${Search_Parameter}
    set test variable  ${cert_search_response_api}     ${response}
    ${json}	json loads data	${cert_search_response_api}
#    ${json_convert}	json load data	${response}
#    ${json}	convert	${json_convert}
    ${result}	summary_owner_reference  ${json}
    clear cache
    [Return]	${result}

Get Certificate Decisioning status
#with Older certficate API (Non-Modularized one)
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificateDetails?certificateId=${Certificate_Id}&user=${user_id}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	cert_decisioning_status	${json}
    clear cache
    [Return]	${result}

Get Certificate Recommendation status
#with Older certficate API (Non-Modularized one)
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificateDetails?certificateId=${Certificate_Id}&user=${user_id}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	cert_recommendation_status	${json}
    clear cache
    [Return]	${result}

Get Certificate Lock/Unlock Message
    [Arguments]	${response}
    ${result}	lock_unlock_message	${response}
    [Return]	${result}

Lock Certificate
    [Arguments]	${certtemplate}  ${cert_parameters}
    ${JSON}=	GET FILE	input/${certtemplate}
    ${result}=	Post Data To Endpoint	/assets/certificate/lock?${cert_parameters}  ${JSON}	200
    [Return]	${result}

Unlock Certificate with Certificate Parameters
    [Arguments]	${certtemplate}  ${cert_parameters}
    ${JSON}=	GET FILE	input/${certtemplate}
    ${result}=	Post Data To Endpoint	/assets/certificate/unlock?${cert_parameters}  ${JSON}	200
    [Return]	${result}

View Certificate
#with Older certficate API (Non-Modularized one)
    [Arguments]	${cert_parameters}
    ${response}=    open url	${API_ENDPOINT}/assets/certificateDetails?${cert_parameters}
    set global variable  ${response_search_api}  ${response}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    ${result}	get_certificate_id  ${json_convert}
    ${attr}     cert_attributes     ${response_search_api}
    set global variable  ${cert_attr}    ${attr}
    ${status}	certificate_status  ${response_search_api}
    set global variable  ${Cert_status}    ${status}
    ${ref_attr}     cert_ref_attributes     ${response_search_api}
    set global variable  ${cert_ref_attr}    ${ref_attr}
    clear cache
    [Return]	${result}

Certificate Audit
    [Arguments]	${cert_parameters}
    ${response}=    open url  	${API_ENDPOINT}/assets/certificateProjectHistory?${cert_parameters}
    set global variable  ${response_search_api}  ${response}
    ${json_convert}	json loads data	${response_search_api}
    ${result}	convert	${json_convert}
    clear cache
    [Return]	${result}

Get Product History
    [Arguments]	${response}
    ${result}	has_project_history	${response}
    [Return]	${result}

Get Revision Number
    [Arguments]	${response}
    ${result}	revision_number	${response}
    [Return]	${result}

Modify Certificate
   [Arguments]	${certtemplate}  ${Cert_Id}
   Sleep	1
   ${File}=     GET FILE    input/${certtemplate}
   ${FILE2}	extract and replace date for certificate scheme  ${File}
   ${JSON}	replace variables	${FILE2}
   ${result}=	Post Data To Endpoint	/assets/certificate/${Cert_Id}	${JSON}	200
   set test variable	${cert_Id}	${result.json()["data"]["certificateId"]}
   set global variable	${Certificate_Id_Modify}	${cert_Id}
   log to console	"Certificate ID after Modify": ${Certificate_Id_Modify}
   set test variable	${certificate_type}   ${result.json()["data"]["certificateType"]}
   set global variable	${Certificate_Type_Modify}  ${certificate_type}
   log to console	"Certificate Type after Modify": ${Certificate_Type_Modify}
   set test variable	${certificate_name}  ${result.json()["data"]["certificateName"]}
   set global variable	${Certificate_Name_Modify}  ${certificate_name}
   log to console	"Certificate Name after Modify": ${certificate_name}
   set test variable	${owner_ref}	${result.json()["data"]["ownerReference"]}
   set global variable	${Cert_Owner_Ref_Modify}	${owner_ref}
   log to console	"Owner_Reference after Modify": ${Cert_Owner_Ref_Modify}
   set test variable	${cert_hierarchy_Id}	${result.json()["data"]["hierarchyId"]}
   set global variable	${certificate_hierarchy_Id_Modify}	${cert_hierarchy_Id}
   log to console	"Certificate Hierarchy Id after Modify": ${certificate_hierarchy_Id_Modify}


Certificate Date Validation
    [Arguments]	${cert_date_template}     ${cert_parameters}
    ${JSON}=	GET FILE	input/${cert_date_template}
    ${result}=	Post Data To Endpoint    /privateLabels/assets/impact?${cert_parameters}    ${JSON}     200
    ${expiry_date}     impacted_expiry_date     ${result.json()}
    set global variable	${impacted_expiry_date}  ${expiry_date}
    log to console	"Impacted Expiry Date": ${impacted_expiry_date}
    ${withdrawal_date}     impacted_withdrawal_date     ${result.json()}
    set global variable	${impacted_withdrawal_date}  ${withdrawal_date}
    log to console	"Impacted Withdrawal Date": ${impacted_withdrawal_date}
    [Return]	${result}


Get CertificateId from Certificate Table
    [Arguments]	${owner_ref}
    connect to database	@{database}
    ${Cert_Id}	query	select certificate_id from certificate where owner_reference = '${owner_ref}' order by effective_start_date;
    ${split}	extract_value	${Cert_Id}
    set global variable  ${Cert_Id}	${split}
    log to console	"Certificate_Id": ${Cert_Id}
    disconnect from database
    [Return]     ${Cert_Id}


Get Unique CertificateId from Certificate Table
    [Arguments]	${cert_Id}
    connect to database	@{database}
    ${Unique_Cert_Id}	query	select unique_certificate_id from certificate where certificate_id = '${cert_Id}';
    ${split}	extract_value	${Unique_Cert_Id}
    set global variable  ${Unique_Certificate_Id}	${split}
    log to console	"Unique_Certificate_Id": ${Unique_Certificate_Id}
    disconnect from database
    [Return]     ${Unique_Certificate_Id}


Get Certificate Version from Certificate Table
    [Arguments]	${cert_Id}
    connect to database	@{database}
    ${Cert_Ver}	query	select version from certificate where certificate_id = '${cert_Id}';
    ${split}	extract_decimal	${Cert_Ver}
    set global variable  ${Certificate_Ver}	${split}
    log to console	"Certificate_Version": ${Certificate_Ver}
    disconnect from database
    [Return]	${Certificate_Ver}

Get Certificate Transaction Id after Modifying Certificate
    [Arguments]	${cert_Id}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificate/${cert_Id}/assets
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	cert_transaction_id  ${json}
    set global variable	${Cert_Transaction_Id_Modify}	${result}
    log to console	"Transaction ID": ${Cert_Transaction_Id_Modify}
    clear cache
    [Return]	${Cert_Transaction_Id_Modify}

Get Linked Assets from Certificate
    [Arguments]	${cert_Id}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificate/${cert_Id}/assets
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${has_assets}	cert_assets  ${json}     ${cert_Id}
    clear cache
    [Return]	${has_assets}

Get Decisions from Certificate
    [Arguments]	${cert_Id}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificate/${cert_Id}/decisions
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${has_certify}	cert_decisions  ${json}
    clear cache
    [Return]	${has_certify}

Get Parties from Certificate
    [Arguments]	${cert_Id}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificate/${cert_Id}/parties
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${parties}	cert_parties  ${json}
    set global variable  ${cert_parties}    ${parties}
    clear cache
    [Return]	${parties}

Add Decisions to Certificate
#Updated Old Keyword (Certify Certificate) with CertificateID as Argument
   [Arguments]	${certtemplate}     ${cert_Id}
   ${File}=     GET FILE    input/${certtemplate}
   ${FILE2}	replace variables	${FILE}
   ${JSON}	extract and replace issue date and withdrawal date and expiry date for certificate  ${FILE2}
   ${response}=  Post Data To Endpoint	/assets/certificate/${cert_Id}/decisions	${JSON}	200

Modify Certificate with New Owner Reference
   [Arguments]	${certtemplate}  ${Cert_Id}
   Sleep	1
   ${File}=     GET FILE    input/${certtemplate}
   ${File1}	extract_and_replace_random_owner_ref_for_certificate	${File}
   ${FILE2}	extract and replace date for certificate scheme  ${File1}
   ${JSON}	replace variables	${FILE2}
   ${result}=	Post Data To Endpoint	/assets/certificate/${Cert_Id}	${JSON}	200

Expire CET
    [Arguments]	${hierarchy_Id}
    connect to database	@{database}
    ${old_end_date_hipar}	query	select effective_end_date from hierarchy_params where hierarchy_id = '${hierarchy_Id}';
    expire_hierarchy_params
    ${new_end_date_hipar}	query	select effective_end_date from hierarchy_params where hierarchy_id = '${hierarchy_Id}';
    ${old_end_date_hi}	query	select effective_end_date from hierarchy where hierarchy_id = '${hierarchy_Id}';
    expire hierarchy
    ${new_end_date_hi}	query	select effective_end_date from hierarchy where hierarchy_id = '${hierarchy_Id}';
    disconnect from database

Activate CET
    [Arguments]	${hierarchy_Id}
    connect to database	@{database}
    ${old_end_date_hipar}	query	select effective_end_date from hierarchy_params where hierarchy_id = '${hierarchy_Id}';
    Activate_hierarchy_params
    ${new_end_date_hipar}	query	select effective_end_date from hierarchy_params where hierarchy_id = '${hierarchy_Id}';
    ${old_end_date_hi}	query	select effective_end_date from hierarchy where hierarchy_id = '${hierarchy_Id}';
    Activate hierarchy
    ${new_end_date_hi}	query	select effective_end_date from hierarchy where hierarchy_id = '${hierarchy_Id}';
    disconnect from database

Get Test Integer Attribute Value
    [Arguments]	${cert_Id}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificate/${cert_Id}?user=${user_id}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	test_integer	${json}
    clear cache
    [Return]	${result}

Add Parties to Certificate
#Updated Old Keyword (Associate Parties To Certificate) adding CertificateID as Argument
   [Arguments]	${certtemplate}     ${cert_Id}
   ${File}=     GET FILE    input/${certtemplate}
   ${JSON}	replace variables	${FILE}
   ${result}=	Post Data To Endpoint	/assets/certificate/${cert_Id}/parties	${JSON}	200

Modify Certificate for Version3
   [Arguments]	${certtemplate}  ${Cert_Id}
   Sleep	1
   ${File}=     GET FILE    input/${certtemplate}
   ${FILE2}	extract and replace date for certificate scheme  ${File}
   ${JSON}	replace variables	${FILE2}
   ${result}=	Post Data To Endpoint	/assets/certificate/${Cert_Id}	${JSON}	200
   set test variable	${cert_Id}	${result.json()["data"]["certificateId"]}
   set global variable	${Certificate_Id_Modify2}	${cert_Id}
   log to console	"Certificate ID after Modify": ${Certificate_Id_Modify2}
   set test variable	${certificate_type}   ${result.json()["data"]["certificateType"]}
   set global variable	${Certificate_Type_Modify2}  ${certificate_type}
   log to console	"Certificate Type after Modify": ${Certificate_Type_Modify2}
   set test variable	${certificate_name}  ${result.json()["data"]["certificateName"]}
   set global variable	${Certificate_Name_Modify2}  ${certificate_name}
   log to console	"Certificate Name after Modify": ${certificate_name_Modify2}
   set test variable	${owner_ref}	${result.json()["data"]["ownerReference"]}
   set global variable	${Cert_Owner_Ref_Modify2}	${owner_ref}
   log to console	"Owner_Reference after Modify": ${Cert_Owner_Ref_Modify2}
   set test variable	${cert_hierarchy_Id}	${result.json()["data"]["hierarchyId"]}
   set global variable	${certificate_hierarchy_Id_Modify2}	${cert_hierarchy_Id}
   log to console	"Certificate Hierarchy Id after Modify": ${certificate_hierarchy_Id_Modify2}

Create Certificate2
   [Arguments]	${certtemplate}
   Sleep	1
   ${File}=     GET FILE    input/${certtemplate}
   ${FILE2}	extract and replace date for certificate scheme  ${File}
   ${JSON}	replace variables	${FILE2}
   ${result}=	Post Data To Endpoint	/assets/certificate	${JSON}	200
   set test variable	${cert_Id}	${result.json()["data"]["certificateId"]}
   set global variable	${Certificate_Id2}	${cert_Id}
   log to console	"Certificate ID": ${Certificate_Id2}
   set test variable	${certificate_type}   ${result.json()["data"]["certificateType"]}
   set global variable	${scheme}	${certificate_type.replace(" ", "%20")}
   log to console	"Certificate Type": ${scheme}
   set test variable	${certificate_name}  ${result.json()["data"]["certificateName"]}
   set global variable  ${cert_name2}  ${certificate_name}
   log to console	"Certificate Name": ${certificate_name}
   set test variable	${owner_ref}	${result.json()["data"]["ownerReference"]}
   set global variable	${Cert_Owner_Ref2}	${owner_ref}
   log to console	"Owner_Reference": ${owner_ref}

Modify Certificate2
   [Arguments]	${certtemplate}  ${Cert_Id}
   Sleep	1
   ${File}=     GET FILE    input/${certtemplate}
   ${FILE2}	extract and replace date for certificate scheme  ${File}
   ${JSON}	replace variables	${FILE2}
   ${result}=	Post Data To Endpoint	/assets/certificate/${Cert_Id}	${JSON}	200
   set test variable	${cert_Id}	${result.json()["data"]["certificateId"]}
   set global variable	${Certificate2_Id_Modify}	${cert_Id}
   log to console	"Certificate ID after Modify": ${Certificate2_Id_Modify}
   set test variable	${certificate_type}   ${result.json()["data"]["certificateType"]}
   set global variable	${Certificate2_Type_Modify}  ${certificate_type}
   log to console	"Certificate Type after Modify": ${Certificate2_Type_Modify}
   set test variable	${certificate_name}  ${result.json()["data"]["certificateName"]}
   set global variable	${Certificate2_Name_Modify}  ${certificate_name}
   log to console	"Certificate Name after Modify": ${certificate2_name_Modify}
   set test variable	${owner_ref}	${result.json()["data"]["ownerReference"]}
   set global variable	${Cert2_Owner_Ref_Modify}	${owner_ref}
   log to console	"Owner_Reference after Modify": ${Cert2_Owner_Ref_Modify}
   set test variable	${cert_hierarchy_Id}	${result.json()["data"]["hierarchyId"]}
   set global variable	${certificate2_hierarchy_Id_Modify}	${cert_hierarchy_Id}
   log to console	"Certificate Hierarchy Id after Modify": ${certificate2_hierarchy_Id_Modify}

Add Assets to Certificate
#Updated Old Keyword (Link Product to Certificate) by adding CertificateID as Argument
   [Arguments]	${certtemplate}  ${Cert_Id}
   Sleep	1
   ${File}=     GET FILE    input/${certtemplate}
   ${JSON}	replace variables	${File}
   ${response}=  Post Data To Endpoint	/assets/certificate/${Cert_Id}/assets	${JSON}	200
   [Return]  ${response.text}

Get Certificate TransactionId using Certificate Details
#Updated Old Keyword (Get Certificate Transaction Id) adding Cert Name, Cert Owner & Scheme as Arguments
    [Arguments]	${cert_name}     ${owner_ref}    ${scheme}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificateDetails?certificateType=${scheme}&ownerReference=${owner_ref}&certificateName=${cert_name}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	cert_transaction_id  ${json}
    clear cache
    [Return]	${result}

Get HasAssets using Certificate Details
#Updated Old Keyword (Get HasAssets) adding Cert Owner & CertID as Arguments
    [Arguments]	${scheme}   ${cert_name}     ${owner_ref}   ${cert_Id}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificateDetails?certificateType=${scheme}&ownerReference=${owner_ref}&certificateName=${cert_name}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	cert_assets  ${json}  ${cert_Id}
    ${result1}  json dumps  ${result}
    set global variable	${has_Assets}	${result1}
    clear cache
    [Return]	${has_Assets}

Get certificate status with certificateId
#Updated Old Keyword (Get certificate status) adding certificateId as Argument
    [Arguments]	${cert_Id}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificateDetails?certificateId=${cert_Id}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	cert status	${json}
    clear cache
    [Return]	${result}

Get HasEvaluations using Certificate Details
#Updated Old Keyword (Get HasEvaluations) adding Cert Owner & CertID as Argument
    [Arguments]	${scheme}   ${cert_name}     ${owner_ref}   ${cert_Id}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificateDetails?certificateType=${scheme}&ownerReference=${owner_ref}&certificateName=${cert_name}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	cert_evaluations  ${json}     certId
    ${result1}  json dumps  ${result}
    set global variable	${has_Evaluations}	${result1}
    clear cache
    [Return]	${has_Evaluations}

Modify Certificate2 for Version3
   [Arguments]	${certtemplate}  ${Cert_Id}
   Sleep	1
   ${File}=     GET FILE    input/${certtemplate}
   ${FILE2}	extract and replace date for certificate scheme  ${File}
   ${JSON}	replace variables	${FILE2}
   ${result}=	Post Data To Endpoint	/assets/certificate/${Cert_Id}	${JSON}	200
   set test variable	${cert_Id}	${result.json()["data"]["certificateId"]}
   set global variable	${Certificate2_Id_Modify2}	${cert_Id}
   log to console	"Certificate ID after Modify": ${Certificate2_Id_Modify2}
   set test variable	${certificate_type}   ${result.json()["data"]["certificateType"]}
   set global variable	${Certificate2_Type_Modify2}  ${certificate_type}
   log to console	"Certificate Type after Modify": ${Certificate2_Type_Modify2}
   set test variable	${certificate_name}  ${result.json()["data"]["certificateName"]}
   set global variable	${Certificate2_Name_Modify2}  ${certificate_name}
   log to console	"Certificate Name after Modify": ${certificate2_name_Modify2}
   set test variable	${owner_ref}	${result.json()["data"]["ownerReference"]}
   set global variable	${Cert2_Owner_Ref_Modify2}	${owner_ref}
   log to console	"Owner_Reference after Modify": ${Cert2_Owner_Ref_Modify2}
   set test variable	${cert_hierarchy_Id}	${result.json()["data"]["hierarchyId"]}
   set global variable	${certificate2_hierarchy_Id_Modify2}	${cert_hierarchy_Id}
   log to console	"Certificate Hierarchy Id after Modify": ${certificate2_hierarchy_Id_Modify2}

Get certificate Details using UserId
    [Arguments]	${cert_Id}   ${user_id}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificate/${cert_Id}?user=${user_id}
    set global variable  ${response_api}     ${response.read()}
    ${attr}     cert_attributes     ${response_api}
    set global variable  ${cert_attr}    ${attr}
    ${status}	certificate_status  ${response_api}
    set global variable  ${Cert_status}    ${status}
    clear cache
    [Return]	${attr}

Get certificate Details using Role
    [Arguments]	${cert_Id}   ${role_name}
    ${response}=	open url  	${API_ENDPOINT}/assets/certificate/${cert_Id}?role=${role_name}
    set global variable  ${response_api}     ${response}
    ${attr}     cert_attributes     ${response_api}
    set global variable  ${cert_attr}    ${attr}
    ${status}	certificate_status	${response_api}
    set global variable  ${Cert_status}    ${status}
    clear cache
    [Return]	${attr}

Get certificate Details using UserId & Role
    [Arguments]	${cert_Id}   ${user_id}  ${role_name}
    ${response}=	open url  	${API_ENDPOINT}/assets/certificate/${cert_Id}?user=${user_id}&role=${role_name}
    set global variable  ${response_api}     ${response}
    ${attr}     cert_attributes     ${response_api}
    set global variable  ${cert_attr}    ${attr}
    ${status}	certificate_status  ${response_api}
    set global variable  ${Cert_status}    ${status}
    clear cache
    [Return]	${attr}

Get certificate Details
    [Arguments]	${cert_Id}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificate/${cert_Id}
    set global variable  ${response_api}     ${response.read()}
    ${attr}     cert_attributes     ${response_api}
    set global variable  ${cert_attr}    ${attr}
    ${status}	certificate_status  ${response_api}
    set global variable  ${Cert_status}    ${status}
    ${ref_attr}     cert_ref_attributes     ${response_api}
    set global variable  ${cert_ref_attr}    ${ref_attr}
    clear cache
    [Return]	${response}

Get certificate Details using Mode
    [Arguments]	${cert_Id}  ${mode}
    ${response}=	open url  	${API_ENDPOINT}/assets/certificate/${cert_Id}?mode=${mode}
    set global variable  ${response_api}     ${response}
    ${attr}     cert_attributes     ${response_api}
    set global variable  ${cert_attr}    ${attr}
    ${status}	certificate_status  ${response_api}
    set global variable  ${Cert_status}    ${status}
    ${ref_attr}     cert_ref_attributes     ${response_api}
    set global variable  ${cert_ref_attr}    ${ref_attr}
    clear cache
    [Return]	${response}

Add Decisions to Certificate using skipValidation
   [Arguments]	${certtemplate}     ${cert_Id}   ${skip_val}
   ${File}=     GET FILE    input/${certtemplate}
   ${FILE2}	replace variables	${FILE}
   ${JSON}	extract and replace issue date and withdrawal date and expiry date for certificate  ${FILE2}
   ${response}=  Post Data To Endpoint	/assets/certificate/${cert_Id}/decisions?skipValidation=${skip_val}	${JSON}	200

Get Parties from Certificate using UserId & Role
    [Arguments]	${cert_Id}  ${user_id}     ${role_name}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificate/${cert_Id}/parties?user=${user_id}&role=${role_name}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${parties}	cert_parties  ${json}
    set global variable  ${cert_parties}    ${parties}
    clear cache
    [Return]	${parties}

Get Parties from Certificate using UserId
    [Arguments]	${cert_Id}  ${user_id}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificate/${cert_Id}/parties?user=${user_id}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${parties}	cert_parties  ${json}
    set global variable  ${cert_parties}    ${parties}
    clear cache
    [Return]	${parties}

Get Parties from Certificate using Role
    [Arguments]	${cert_Id}  ${role_name}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificate/${cert_Id}/parties?role=${role_name}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${parties}	cert_parties  ${json}
    set global variable  ${cert_parties}    ${parties}
    clear cache
    [Return]	${parties}

Get Questions from Certificate
    [Arguments]	${cert_Id}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificate/${cert_Id}/decisions
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${questions}	has_questions  ${json}
    set global variable  ${cert_questions}    ${questions}
    clear cache
    [Return]	${questions}

Get Questions from Certificate using UserId & Role
    [Arguments]	${cert_Id}  ${user_id}     ${role_name}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificate/${cert_Id}/decisions?user=${user_id}&role=${role_name}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${questions}	has_questions  ${json}
    set global variable  ${cert_questions}    ${questions}
    clear cache
    [Return]	${questions}

Get Questions from Certificate using UserId
    [Arguments]	${cert_Id}  ${user_id}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificate/${cert_Id}/decisions?user=${user_id}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${questions}	has_questions  ${json}
    set global variable  ${cert_questions}    ${questions}
    clear cache
    [Return]	${questions}

Get Questions from Certificate using Role
    [Arguments]	${cert_Id}  ${role_name}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificate/${cert_Id}/decisions?role=${role_name}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${questions}	has_questions  ${json}
    set global variable  ${cert_questions}    ${questions}
    clear cache
    [Return]	${questions}

Get Recommendation from Certificate
    [Arguments]	${cert_Id}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificate/${cert_Id}/decisions
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${recommendation}	has_recommendation  ${json}
    set global variable  ${cert_recommendation}    ${recommendation}
    clear cache
    [Return]	${recommendation}

Get Recommendation from Certificate using UserId & Role
    [Arguments]	${cert_Id}  ${user_id}     ${role_name}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificate/${cert_Id}/decisions?user=${user_id}&role=${role_name}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${recommendation}	has_recommendation  ${json}
    set global variable  ${cert_recommendation}    ${recommendation}
    clear cache
    [Return]	${recommendation}

Get Recommendation from Certificate using UserId
    [Arguments]	${cert_Id}  ${user_id}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificate/${cert_Id}/decisions?user=${user_id}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${recommendation}	has_recommendation  ${json}
    set global variable  ${cert_recommendation}    ${recommendation}
    clear cache
    [Return]	${recommendation}

Get Recommendation from Certificate using Role
    [Arguments]	${cert_Id}  ${role_name}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificate/${cert_Id}/decisions?role=${role_name}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${recommendation}	has_recommendation  ${json}
    set global variable  ${cert_recommendation}    ${recommendation}
    clear cache
    [Return]	${recommendation}

Get Certify from Certificate
    [Arguments]	${cert_Id}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificate/${cert_Id}/decisions
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${certify}	has_certify  ${json}
    set global variable  ${cert_certify}    ${certify}
    clear cache
    [Return]	${certify}

Get Certify from Certificate using UserId & Role
    [Arguments]	${cert_Id}  ${user_id}  ${role_name}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificate/${cert_Id}/decisions?user=${user_id}&role=${role_name}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${certify}	has_certify  ${json}
    set global variable  ${cert_certify}    ${certify}
    clear cache
    [Return]	${certify}

Get Certify from Certificate using UserId
    [Arguments]	${cert_Id}  ${user_id}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificate/${cert_Id}/decisions?user=${user_id}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${certify}	has_certify  ${json}
    set global variable  ${cert_certify}    ${certify}
    clear cache
    [Return]	${certify}

Get Certify from Certificate using Role
    [Arguments]	${cert_Id}  ${role_name}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/assets/certificate/${cert_Id}/decisions?role=${role_name}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${certify}	has_certify  ${json}
    set global variable  ${cert_certify}    ${certify}
    clear cache
    [Return]	${certify}

View Private Label Assets using Certificate
    [Arguments]	${cert_Id}   ${asset_id}   ${cert_parameters}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/certificate/${cert_Id}/assets/${asset_id}?${cert_parameters}
    set global variable  ${response_api}  ${response.read()}
    ${json_convert}	json loads data	${response_api}
    ${json}	convert	${json_convert}
    ${result}	asset_id  ${json}
    clear cache
    [Return]	${result}

Add Assets to Certificate(New)
#New service to Add Assets to Certificate
   [Arguments]	${certtemplate}  ${Cert_Id}
   Sleep	1
   ${File}=     GET FILE    input/${certtemplate}
   ${JSON}	replace variables	${File}
   ${response}=  Post Data To Endpoint	/assets/certificate/${Cert_Id}/addAssets	${JSON}	200
   [Return]  ${response.text}

Paginated Search for Certificate
    [Arguments]	${assettemplate}
#    ${time}   current_time
#    set global variable  ${current_time}  ${time}
#    ${time}  get time
#    set global variable  ${current_time}  ${time}
    Sleep	5
    ${File}=	GET FILE	input/Certificate/Search/${assettemplate}
    ${JSON}	replace variables	${File}
    ${result}=	Post Data To Endpoint	/certificates/summary	${JSON}	200
    set global variable  ${Cert_search_response_api}  ${response_api}
    ${json_to_py}	json loads data  ${Cert_search_response_api}
    set global variable  ${certificate_search}  ${json_to_py}
    [Return]	${Cert_search_response_api}

################################
################################
####  Private Label Section ####
################################
################################
Create private label
   [Arguments]	${certtemplate}
   ${File}=     GET FILE    input/${certtemplate}
   ${JSON}	replace variables	${File}
   ${result}=	Post Data To Endpoint	/privateLabels    ${JSON}	200
   set test variable	${PL_Id}	${result.json()["data"]["privateLabelId"]}
   set global variable  ${PrivateLabel_Id}	${PL_Id}
   log to console    Private Lable Certificate ID: ${PrivateLabel_Id}
   set test variable	${PL_Msg}	${result.json()["message"]}
   set global variable  ${PrivateLabel_Message}	${PL_Msg}
   set test variable	${certificate_type}   ${result.json()["data"]["certificateType"]}
   set global variable	${Certificate_Type}  ${certificate_type}
   log to console	"Certificate Type": ${Certificate_type}
   set test variable	${certificate_name}  ${result.json()["data"]["certificateName"]}
   set global variable	${PL_Certificate_Name}  ${certificate_name}
   log to console	"Certificate Name": ${certificate_Name}
   set test variable	${owner_ref}	${result.json()["data"]["ownerReference"]}
   set global variable	${Cert_Owner_Ref}	${owner_ref}
   log to console	"Owner_Reference": ${Cert_Owner_Ref}
   set test variable	${cert_hierarchy_Id}	${result.json()["data"]["hierarchyId"]}
#   set global variable	${certificate_hierarchy_Id}	${cert_hierarchy_Id}
#   log to console	"Certificate Hierarchy Id": ${certificate_hierarchy_Id}

   
Edit Private Label
   [Arguments]	${certtemplate}  ${pl_Id}
   ${File}=     GET FILE    input/${certtemplate}
   ${FILE1}	extract_and_replace_issue_date_for_edit_private_label	${File}
   ${JSON}	replace variables	${FILE1}
   ${result}=	Post Data To Endpoint	/privateLabels/${pl_Id}  ${JSON}	200
   set test variable	${PL_Id}	${result.json()["data"]["privateLabelId"]}
   set global variable  ${PrivateLabel_Id_Edit}	${PL_Id}
   log to console	"Private Label ID after Edit": ${PrivateLabel_Id_Edit}
   set test variable	${certificate_type}   ${result.json()["data"]["certificateType"]}
   set global variable	${Certificate_type_Edit}  ${certificate_type}
   log to console	"Certificate Type after Edit": ${Certificate_type_Edit}
   set test variable	${certificate_name}  ${result.json()["data"]["certificateName"]}
   set global variable	${Certificate_Name_Edit}  ${certificate_name}
   log to console	"Certificate Name after Edit": ${certificate_Name_Edit}
   set test variable	${owner_ref}	${result.json()["data"]["ownerReference"]}
   set global variable	${Cert_Owner_Ref_Edit}	${owner_ref}
   log to console	"Owner_Reference after Edit": ${Cert_Owner_Ref_Edit}
   set test variable	${cert_hierarchy_Id}	${result.json()["data"]["hierarchyId"]}
   set global variable	${certificate_hierarchy_Id_Edit}	${cert_hierarchy_Id}
   log to console	"Certificate Hierarchy Id after Edit": ${certificate_hierarchy_Id_Edit}

   
Add Asset To PL
#Created New Keyword (Add Asset To Private Label) adding PrivateLabelID as Argument
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
#Created New Keyword (Add Parties To Private Label) adding PrivateLabelID as Argument
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
    clear cache
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
    clear cache
    [Return]	${result}

Search Private label Asset
    [Arguments]	${Search_Parameter}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/privateLabels/assets?${Search_Parameter}
    set global variable  ${response_search_api}  ${response.read()}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    ${result}	pl asset id  ${json}
    clear cache
    [Return]	${result}

View Private Label Assets
    [Arguments]	${pl_asset_id}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/privateLabels/${PrivateLabel_Id}/assets/${pl_asset_id}?user=${user_id}
    set global variable  ${response_search_api}  ${response.read()}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    ${result}	private_label_asset_id  ${json}
    ${data}  get_data    ${json}
    ${pl_Id}   get_object_values    ${data}    ${plId_key}
    set global variable  ${PL_Id}    ${pl_Id}
    ${pl_assetId}   get_object_values    ${data}    ${plAssetId_key}
    set global variable  ${PL_Asset_Id}    ${pl_assetId}
    ${taxonomy}   get_object_values    ${data}    ${taxonomy_key}
    set global variable  ${pl_Asset_taxonomy}    ${taxonomy}
    should not be empty  ${pl_Asset_taxonomy}
    ${model_name}   get_values_from_list_of_dictionaries    ${pl_Asset_taxonomy}    ${modelName_key}
    set global variable  ${pl_asset_model_name}    ${model_name}
    ${ref_no}   get_values_from_list_of_dictionaries    ${pl_Asset_taxonomy}    ${referenceNumber_key}
    set global variable  ${pl_asset_ref_no}    ${ref_no}
    ${owner_reference}   get_values_from_list_of_dictionaries    ${pl_Asset_taxonomy}    ${ownerReference_key}
    set global variable  ${pl_asset_owner_reference}    ${owner_reference}
    ${family_series}   get_values_from_list_of_dictionaries    ${pl_Asset_taxonomy}    ${family_Series_key}
    set global variable  ${pl_asset_family_series}    ${family_series}
    ${attributes}   get_object_values    ${data}    ${attributes_key}
    set global variable  ${pl_Asset_attributes}    ${attributes}
    clear cache
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
    ${attr}     cert_attributes     ${response_search_api}
    set global variable  ${cert_attr}    ${attr}
    ${status}	privateLabel_status  ${response_search_api}
    set global variable  ${pl_status}    ${status}
    clear cache
    [Return]	${result}

View Private Label Assets Details
    [Arguments]	${pl_Id}
    ${response}=    open url	${API_ENDPOINT}/privateLabels/${pl_Id}/assets
    set global variable  ${url_response}  ${response}
    set global variable  ${response_search_api}  ${response}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    ${result}	get_pl_asset_id  ${json}
    ${has_assets}    pl_assets  ${json}
    set global variable  ${pl_assets}    ${has_assets}
    ${pl_Id}   get_key_values_from_list    ${pl_assets}    ${plId_key}
    set global variable  ${PL_Id}    ${pl_Id}
    ${pl_assetId}   get_key_values_from_list    ${pl_assets}    ${plAssetId_key}
    set global variable  ${PL_Asset_Id}    ${pl_assetId}
    ${assetId}   get_key_values_from_list    ${pl_assets}    ${AssetId_key}
    set global variable  ${Asset_Id}    ${assetId}
    ${ul_assetId}   get_key_values_from_list    ${pl_assets}    ${ulAssetId_key}
    set global variable  ${UL_Asset_Id}    ${ul_assetId}
    ${pl_impacted}   get_key_values_from_list    ${pl_assets}    ${pl_impacted_key}
    set global variable  ${pl_impacted_values}    ${pl_impacted}
    ${taxonomy}   get_key_values_from_list    ${pl_assets}    ${taxonomy_key}
    set global variable  ${pl_Asset_taxonomy}    ${taxonomy}
    should not be empty  ${pl_Asset_taxonomy}
    ${model_name}   get_values_from_list_of_lists_of_dictionaries    ${pl_Asset_taxonomy}    ${modelName_key}
    set global variable  ${pl_asset_model_name}    ${model_name}
    ${ref_no}   get_values_from_list_of_lists_of_dictionaries    ${pl_Asset_taxonomy}    ${referenceNumber_key}
    set global variable  ${pl_asset_ref_no}    ${ref_no}
    ${owner_reference}   get_values_from_list_of_lists_of_dictionaries    ${pl_Asset_taxonomy}    ${ownerReference_key}
    set global variable  ${pl_asset_owner_reference}    ${owner_reference}
    ${family_series}   get_values_from_list_of_lists_of_dictionaries    ${pl_Asset_taxonomy}    ${family_Series_key}
    set global variable  ${pl_asset_family_series}    ${family_series}
    ${creation_date}   get_values_from_list_of_lists_of_dictionaries    ${pl_Asset_taxonomy}    ${creation_Date_key}
    set global variable  ${pl_asset_creation_date}    ${creation_date}
    clear cache
    [Return]	${result}

View Private Label Questions Details
    [Arguments]	${pl_Id}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/privateLabels/${pl_Id}/questions
    set global variable  ${response_search_api}  ${response.read()}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    set global variable  ${pl_questions}  ${json}
    ${result}	pl_id  ${json}
    clear cache
    [Return]	${result}

	
View Private Label Recommendations Details
    [Arguments]	${pl_Id}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/privateLabels/${pl_Id}/recommendations
    set global variable  ${response_search_api}  ${response.read()}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    set global variable  ${pl_recommendations}  ${json}
    ${result}	pl_id  ${json}
    clear cache
    [Return]	${result}

	
View Private Label Certify Details
    [Arguments]	${pl_Id}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/privateLabels/${pl_Id}/certify
    set global variable  ${response_search_api}  ${response.read()}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    set global variable  ${pl_certify}  ${json}
    ${result}	pl_id  ${json}
    clear cache
    [Return]	${result}

	
View Private Label Parties Details
    [Arguments]	${pl_Id}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/privateLabels/${pl_Id}/parties
    set global variable  ${response_search_api}  ${response.read()}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    ${result}	pl_id  ${json}
    clear cache
    [Return]	${result}
	

View Private Label Assets of a base Asset_one_asset_Id
    [Arguments]	${asset_Id_Product1}
    ${response}=    open url	${API_ENDPOINT}/assets/${asset_Id_Product1}/privateLabelAssets
    set global variable  ${url_response}  ${response}
    set global variable  ${response_search_api}  ${response}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    ${result}	get_pl_assets_pl_asset_id_1  ${json}
    clear cache
    [Return]	${result}


View Private Label Assets of a base Asset_two_asset_Id
    [Arguments]	${asset_Id_Product1}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/assets/${asset_Id_Product1}/privateLabelAssets
    set global variable  ${response_search_api}  ${response.read()}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    ${result1}	get_pl_assets_pl_asset_id_1  ${json}
    ${result2}	get_pl_assets_pl_asset_id_2  ${json}
    clear cache
    [Return]	${result1}   ${result2}


View Base Asset of a private label asset
    [Arguments]	${pl_asset_id}
    ${response}=    open url	${API_ENDPOINT}/assets/${pl_asset_id}/assets
    set global variable  ${url_response}  ${response}
    set global variable  ${response_search_api}  ${response}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    ${result}	get_asset_id_1  ${json}
    clear cache
    [Return]	${result}


Get Base Certificate Details for a Private Label
    [Arguments]	${pl_Id}
    ${response}=    open url	${API_ENDPOINT}/privateLabels/${pl_Id}/certificate
    set global variable  ${url_response}  ${response}
    set global variable  ${response_search_api}  ${response}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    ${result}	cert_owner_reference  ${json}
    clear cache
    [Return]	${result}


Get Private Label Details of a base Certificate
    [Arguments]	${cert_name}    ${cert_type}     ${cert_owner_ref}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/assets/certificate/privateLabels?certificateName=${cert_name}&&certificateType=${cert_type}&&ownerReference=${cert_owner_ref}
    set global variable  ${response_search_api}  ${response.read()}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    ${result}	private_label_id  ${json}
    clear cache
    [Return]	${result}


Get Private Label Impact Details of a base Certificate
    [Arguments]	${cert_parameters}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/assets/certificate/privateLabels?${cert_parameters}
    set global variable  ${response_search_api}  ${response.read()}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    ${result}	private_label_impact  ${json}
    clear cache
    [Return]	${result}


Update Impacted model for Private Label
    [Arguments]	${unlink_aset_template}     ${pl_asset_id}
    ${JSON}=	GET FILE	input/${unlink_aset_template}
    ${result}=	Post Data To Endpoint	/privateLabels/assets/${pl_asset_id}/update  ${JSON}	200
    [Return]	${result.json()}


Modify Private Lable
   [Arguments]	${certtemplate}  ${pl_Id}
   ${File}=     GET FILE    input/${certtemplate}
   ${JSON}	replace variables	${File}
   ${result}=	Post Data To Endpoint	/privateLabels/${pl_Id}    ${JSON}	200
   set test variable	${PL_Id}	${result.json()["data"]["privateLabelId"]}
   set global variable  ${PrivateLabel_Id_Modify}	${PL_Id}
   log to console    Private Lable Certificate ID after Modify: ${PrivateLabel_Id_Modify}
   set test variable	${certificate_type}   ${result.json()["data"]["certificateType"]}
   set global variable	${Certificate_Type_Modify}  ${certificate_type}
   log to console	"Certificate Type after Modify": ${Certificate_Type_Modify}
   set test variable	${certificate_name}  ${result.json()["data"]["certificateName"]}
   set global variable	${Certificate_Name_Modify}  ${certificate_name}
   log to console	"Certificate Name after Modify": ${certificate_name}
   set test variable	${owner_ref}	${result.json()["data"]["ownerReference"]}
   set global variable	${Cert_Owner_Ref_Modify}	${owner_ref}
   log to console	"Owner_Reference after Modify": ${Cert_Owner_Ref_Modify}
   set test variable	${cert_hierarchy_Id}	${result.json()["data"]["hierarchyId"]}
   set global variable	${certificate_hierarchy_Id_Modify}	${cert_hierarchy_Id}
   log to console	"Certificate Hierarchy Id after Modify": ${certificate_hierarchy_Id_Modify}

Get PrivateLabelId from Private Label Table
    [Arguments]	${Cert_Id}
    connect to database	@{database}
    ${pl_Id}	query	select private_label_id from private_label where certificate_id = '${Cert_Id}' order by effective_start_date;
    ${split}	extract_value	${pl_Id}
    set global variable  ${pl_Id}	${split}
    log to console	"PrivateLabel_Id": ${pl_Id}
    disconnect from database
    [Return]     ${pl_Id}

Get Unique PrivateLabelId from Private Label Table
    [Arguments]	${pl_Id}
    connect to database	@{database}
    ${Unique_pl_Id}	query	select unique_private_label_id from private_label where private_label_id = '${pl_Id}';
    ${split}	extract_value	${Unique_pl_Id}
    set global variable  ${Unique_PrivateLabel_Id}	${split}
    log to console	"Unique_PrivateLabel_Id": ${Unique_PrivateLabel_Id}
    disconnect from database
    [Return]     ${Unique_PrivateLabel_Id}

Get Private Label Version from Private Label Table
    [Arguments]	${pl_Id}
    connect to database	@{database}
    ${pl_Ver}	query	select version from private_label where private_label_id = '${pl_Id}';
    ${split}	extract_decimal	${pl_Ver}
    set global variable  ${PrivateLabel_Ver}	${split}
    log to console	"PrivateLabel_Version": ${PrivateLabel_Ver}
    disconnect from database
    [Return]	${PrivateLabel_Ver}

Get Private Label Version from PL Attributes Table
    [Arguments]	${pl_Id}
    connect to database	@{database}
    ${pl_Ver}	query	select version from pl_attributes where entity_id = '${pl_Id}' order by effective_start_date;
    ${split}	extract_decimal	${pl_Ver}
    set global variable  ${PrivateLabel_Ver_attributes}	${split}
    log to console	"PrivateLabel_Version": ${PrivateLabel_Ver_attributes}
    disconnect from database
    [Return]	${PrivateLabel_Ver_attributes}

Get Unique PrivateLabelId from PL Asset Table
    [Arguments]	${PL_Asset_Id}
    connect to database	@{database}
    ${pl_Id}	query	Select private_label_id from pl_asset where pl_asset_id = '${PL_Asset_Id}';
    ${split}	extract_value	${pl_Id}
    set global variable  ${pl_Id_PLasset}	${split}
    log to console	"PrivateLabel_Id": ${pl_Id_PLasset}
    disconnect from database
    [Return]     ${pl_Id}

Get Private Label Version from Party Site Container Table
    [Arguments]	${pl_Id}
    connect to database	@{database}
    ${pl_Ver}	query	select version from party_site_container where entity_id = '${pl_Id}';
    ${split}	extract_decimal	${pl_Ver}
    set global variable  ${PrivateLabel_Ver_party}	${split}
    log to console	"PrivateLabel_Version": ${PrivateLabel_Ver_party}
    disconnect from database
    [Return]	${PrivateLabel_Ver_party}

Get Private Label Version from Questions Table
    [Arguments]	${pl_Id}
    connect to database	@{database}
    ${pl_Ver}	query	select version from questions where entity_id = '${pl_Id}';
    ${split}	extract_decimal	${pl_Ver}
    set global variable  ${PrivateLabel_Ver_questions}	${split}
    log to console	"PrivateLabel_Version": ${PrivateLabel_Ver_questions}
    disconnect from database
    [Return]	${PrivateLabel_Ver_questions}

Get Private Label Version from Recommendations Table
    [Arguments]	${pl_Id}
    connect to database	@{database}
    ${pl_Ver}	query	select version from recommendations where entity_id = '${pl_Id}';
    ${split}	extract_decimal	${pl_Ver}
    set global variable  ${PrivateLabel_Ver_recommendations}	${split}
    log to console	"PrivateLabel_Version": ${PrivateLabel_Ver_recommendations}
    disconnect from database
    [Return]	${PrivateLabel_Ver_recommendations}

Get Private Label Version from Certify Table
    [Arguments]	${pl_Id}
    connect to database	@{database}
    ${pl_Ver}	query	select version from certify where entity_id = '${pl_Id}';
    ${split}	extract_decimal	${pl_Ver}
    set global variable  ${PrivateLabel_Ver_certify}	${split}
    log to console	"PrivateLabel_Version": ${PrivateLabel_Ver_certify}
    disconnect from database
    [Return]	${PrivateLabel_Ver_certify}

Get Private Label Version from PL Revisions Table
    [Arguments]	${pl_Id}
    connect to database	@{database}
    ${pl_Ver}	query	select version from pl_revisions where private_label_id = '${pl_Id}' order by effective_start_date;
    ${split}	extract_decimal	${pl_Ver}
    set global variable  ${PrivateLabel_Ver_Revisions}	${split}
    log to console	"PrivateLabel_Version": ${PrivateLabel_Ver_Revisions}
    disconnect from database
    [Return]	${PrivateLabel_Ver_Revisions}

Modify Private Label with New Owner Reference
   [Arguments]	${certtemplate}  ${pl_Id}
   Sleep	1
   ${File}=     GET FILE    input/${certtemplate}
   ${File1}	extract_and_replace_random_owner_ref_for_private_label	${File}
   ${JSON}	replace variables	${FILE1}
   ${result}=	Post Data To Endpoint	/privateLabels/${pl_Id}	${JSON}	200

Certificate Mark for Private Label
   [Arguments]	${pl_Id}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/privateLabels/${pl_Id}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	Mark	${json}
    clear cache
    [Return]	${result}

Get Test Integer Attribute Value from Private Label
    [Arguments]	${pl_Id}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/privateLabels/${pl_Id}?user=${user_id}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${result}	test_integer	${json}
    clear cache
    [Return]	${result}

Add Parties To Private Label
#Updated Old Keyword (Add Party To PL) adding PrivateLabelID as Argument
   [Arguments]	${assettemplate}    ${pl_Id}
   ${File}=     GET FILE    input/${assettemplate}
   ${JSON}	replace variables	${File}
   ${result}=	Post Data To Endpoint	/privateLabels/${pl_Id}/parties	${JSON}	200
   [Return]   ${result._content}


Modify Private Lable for Version3
   [Arguments]	${certtemplate}  ${pl_Id}
   ${File}=     GET FILE    input/${certtemplate}
   ${JSON}	replace variables	${File}
   ${result}=	Post Data To Endpoint	/privateLabels/${pl_Id}    ${JSON}	200
   set test variable	${PL_Id}	${result.json()["data"]["privateLabelId"]}
   set global variable  ${PrivateLabel_Id_Modify2}	${PL_Id}
   log to console    Private Lable Certificate ID after Modify: ${PrivateLabel_Id_Modify2}
   set test variable	${certificate_type}   ${result.json()["data"]["certificateType"]}
   set global variable	${Certificate_Type_Modify2}  ${certificate_type}
   log to console	"Certificate Type after Modify": ${Certificate_Type_Modify2}
   set test variable	${certificate_name}  ${result.json()["data"]["certificateName"]}
   set global variable	${Certificate_Name_Modify2}  ${certificate_name}
   log to console	"Certificate Name after Modify": ${Certificate_Name_Modify2}
   set test variable	${owner_ref}	${result.json()["data"]["ownerReference"]}
   set global variable	${Cert_Owner_Ref_Modify2}	${owner_ref}
   log to console	"Owner_Reference after Modify": ${Cert_Owner_Ref_Modify2}
   set test variable	${cert_hierarchy_Id}	${result.json()["data"]["hierarchyId"]}
   set global variable	${certificate_hierarchy_Id_Modify2}	${cert_hierarchy_Id}
   log to console	"Certificate Hierarchy Id after Modify": ${certificate_hierarchy_Id_Modify2}

Create private label2
   [Arguments]	${certtemplate}
   ${File}=     GET FILE    input/${certtemplate}
   ${JSON}	replace variables	${File}
   ${result}=	Post Data To Endpoint	/privateLabels    ${JSON}	200
   set test variable	${PL_Id}	${result.json()["data"]["privateLabelId"]}
   set global variable  ${PrivateLabel_Id2}	${PL_Id}
   log to console    Private Lable Certificate ID: ${PrivateLabel_Id2}
   set test variable	${PL_Msg}	${result.json()["message"]}
   set global variable  ${PrivateLabel_Message2}	${PL_Msg}
   set test variable	${certificate_type}   ${result.json()["data"]["certificateType"]}
   set global variable	${Certificate_Type2}  ${certificate_type}
   log to console	"Certificate Type": ${Certificate_type}
   set test variable	${certificate_name}  ${result.json()["data"]["certificateName"]}
   set global variable	${PL_Certificate_Name2}  ${certificate_name}
   log to console	"Certificate Name": ${certificate_Name}
   set test variable	${owner_ref}	${result.json()["data"]["ownerReference"]}
   set global variable	${Cert_Owner_Ref2}	${owner_ref}
   log to console	"Owner_Reference": ${Cert_Owner_Ref2}
   set test variable	${cert_hierarchy_Id}	${result.json()["data"]["hierarchyId"]}
   set global variable	${certificate_hierarchy_Id2}	${cert_hierarchy_Id}
   log to console	"Certificate Hierarchy Id": ${certificate_hierarchy_Id2}

Modify Private Lable2
   [Arguments]	${certtemplate}  ${pl_Id}
   ${File}=     GET FILE    input/${certtemplate}
   ${JSON}	replace variables	${File}
   ${result}=	Post Data To Endpoint	/privateLabels/${pl_Id}    ${JSON}	200
   set test variable	${PL_Id}	${result.json()["data"]["privateLabelId"]}
   set global variable  ${PrivateLabel2_Id_Modify}	${PL_Id}
   log to console    Private Lable Certificate ID after Modify: ${PrivateLabel2_Id_Modify}
   set test variable	${certificate_type}   ${result.json()["data"]["certificateType"]}
   set global variable	${Certificate2_Type_Modify}  ${certificate_type}
   log to console	"Certificate Type after Modify": ${Certificate2_Type_Modify}
   set test variable	${certificate_name}  ${result.json()["data"]["certificateName"]}
   set global variable	${Certificate2_Name_Modify}  ${certificate_name}
   log to console	"Certificate Name after Modify": ${Certificate2_Name_Modify}
   set test variable	${owner_ref}	${result.json()["data"]["ownerReference"]}
   set global variable	${Cert2_Owner_Ref_Modify}	${owner_ref}
   log to console	"Owner_Reference after Modify": ${Cert2_Owner_Ref_Modify}
   set test variable	${cert_hierarchy_Id}	${result.json()["data"]["hierarchyId"]}
   set global variable	${certificate2_hierarchy_Id_Modify}	${cert_hierarchy_Id}
   log to console	"Certificate Hierarchy Id after Modify": ${certificate2_hierarchy_Id_Modify}

Add Asset To Private Label
#Updated Old Keyword (Add Asset To PL) with Private Label ID as Argument
   [Arguments]	${assettemplate}     ${PL_Id}
   ${File}=     GET FILE    input/${assettemplate}
   ${File1}  extract_and_replace_date_for_Pl_Add_asset   ${File}
   ${JSON}	replace variables	${File1}
   ${response}=	Post Data To Endpoint	/privateLabels/${PL_Id}/assets	${JSON}	200
   ${result}	pl asset id    ${response.json()}
   set global variable  ${PrivateLabel_Asset_Id}    ${result}
   log to console    Private Lable Asset ID: ${result}
   [Return]   ${result}

Modify Private Lable2 for Version3
   [Arguments]	${certtemplate}  ${pl_Id}
   ${File}=     GET FILE    input/${certtemplate}
   ${JSON}	replace variables	${File}
   ${result}=	Post Data To Endpoint	/privateLabels/${pl_Id}    ${JSON}	200
   set test variable	${PL_Id}	${result.json()["data"]["privateLabelId"]}
   set global variable  ${PrivateLabel2_Id_Modify2}	${PL_Id}
   log to console    Private Lable Certificate ID after Modify: ${PrivateLabel2_Id_Modify2}
   set test variable	${certificate_type}   ${result.json()["data"]["certificateType"]}
   set global variable	${Certificate2_Type_Modify2}  ${certificate_type}
   log to console	"Certificate Type after Modify": ${Certificate2_Type_Modify2}
   set test variable	${certificate_name}  ${result.json()["data"]["certificateName"]}
   set global variable	${Certificate2_Name_Modify2}  ${certificate_name}
   log to console	"Certificate Name after Modify": ${Certificate2_Name_Modify2}
   set test variable	${owner_ref}	${result.json()["data"]["ownerReference"]}
   set global variable	${Cert2_Owner_Ref_Modify2}	${owner_ref}
   log to console	"Owner_Reference after Modify": ${Cert2_Owner_Ref_Modify2}
   set test variable	${cert_hierarchy_Id}	${result.json()["data"]["hierarchyId"]}
   set global variable	${certificate2_hierarchy_Id_Modify2}	${cert_hierarchy_Id}
   log to console	"Certificate Hierarchy Id after Modify": ${certificate2_hierarchy_Id_Modify2}

View Private Label details using UserId
    [Arguments]	${pl_Id}     ${user_id}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/privateLabels/${pl_Id}?user=${user_id}
    set global variable  ${response_api}  ${response.read()}
    ${attr}     cert_attributes     ${response_api}
    set global variable  ${cert_attr}    ${attr}
    ${status}	privateLabel_status  ${response_api}
    set global variable  ${pl_status}    ${status}
    clear cache
    [Return]	${attr}

View Private Label details using Role
    [Arguments]	${pl_Id}     ${role_name}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/privateLabels/${pl_Id}?role=${role_name}
    set global variable  ${response_api}  ${response.read()}
    ${attr}     cert_attributes     ${response_api}
    set global variable  ${cert_attr}    ${attr}
    ${status}	privateLabel_status  ${response_api}
    set global variable  ${pl_status}    ${status}
    clear cache
    [Return]	${attr}

View Private Label details using UserId & Role
    [Arguments]	${pl_Id}    ${user_id}     ${role_name}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/privateLabels/${pl_Id}?user=${user_id}&role=${role_name}
    set global variable  ${response_api}  ${response.read()}
    ${attr}     cert_attributes     ${response_api}
    set global variable  ${cert_attr}    ${attr}
    ${status}	privateLabel_status  ${response_api}
    set global variable  ${pl_status}    ${status}
    clear cache
    [Return]	${attr}

View Private Label details without using UserId or Role
    [Arguments]	${pl_Id}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/privateLabels/${pl_Id}
    set global variable  ${response_api}  ${response.read()}
    ${attr}     cert_attributes     ${response_api}
    set global variable  ${cert_attr}    ${attr}
    ${status}	privateLabel_status  ${response_api}
    set global variable  ${pl_status}    ${status}
    clear cache
    [Return]	${attr}

View Private Label Assets using UserId
    [Arguments]	${pl_asset_id}   ${user_id}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/privateLabels/${PrivateLabel_Id}/assets/${pl_asset_id}?user=${user_id}
    set global variable  ${response_search_api}  ${response.read()}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    ${result}	private_label_asset_id  ${json}
    clear cache
    [Return]	${result}

View Private Label Assets using Role
    [Arguments]	${pl_asset_id}   ${role_name}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/privateLabels/${PrivateLabel_Id}/assets/${pl_asset_id}?role=${role_name}
    set global variable  ${response_search_api}  ${response.read()}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    ${result}	private_label_asset_id  ${json}
    clear cache
    [Return]	${result}

View Private Label Assets using UserId & Role
    [Arguments]	${pl_asset_id}   ${user_id}  ${role_name}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/privateLabels/${PrivateLabel_Id}/assets/${pl_asset_id}?user=${user_id}&role=${role_name}
    set global variable  ${response_search_api}  ${response.read()}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    ${result}	private_label_asset_id  ${json}
    clear cache
    [Return]	${result}

Add/unlink Project and Decisions to Private Label
    [Arguments]	${plcerttemplate}    ${skip_val}
    ${File}=	GET FILE	input/${plcerttemplate}
    ${File2}=    replace variables  ${File}
    ${JSON}=    extract_and_replace_issue_date_and_withdrawal_date_and_expiry_date_for_private_label_scheme  ${File2}
    ${result}=	Post Data To Endpoint	/privateLabels/decisions?skipValidation=${skip_val}  ${JSON}	200
    [Return]	${result._content}

View Private Label Details using Mode
    [Arguments]	${pl_Id}    ${mode}
    ${response}=    open url  	${API_ENDPOINT}/privateLabels/${pl_Id}?mode=${mode}
    set global variable  ${response_api}  ${response}
    ${attr}     cert_attributes     ${response_api}
    set global variable  ${pl_attr}    ${attr}
    ${status}	privateLabel_status  ${response_api}
    set global variable  ${pl_status}    ${status}
    ${ref_attr}     cert_ref_attributes     ${response_api}
    set global variable  ${pl_ref_attr}    ${ref_attr}
    clear cache
    [Return]	${response}

View Private Label Details without using Mode
    [Arguments]	${pl_Id}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/privateLabels/${pl_Id}
    set global variable  ${response_api}  ${response.read()}
    ${attr}     cert_attributes     ${response_api}
    set global variable  ${pl_attr}    ${attr}
    ${status}	privateLabel_status  ${response_api}
    set global variable  ${pl_status}    ${status}
    ${ref_attr}     cert_ref_attributes     ${response_api}
    set global variable  ${pl_ref_attr}    ${ref_attr}
    clear cache
    [Return]	${response}

Get Projects and Decisions from Private Label
    [Arguments]	${pl_Id}   ${pl_parameters}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/privateLabels/${pl_Id}/decisions?${pl_parameters}
    set global variable  ${response_api}  ${response.read()}
    ${json_convert}	json loads data	${response_api}
    ${json}	convert	${json_convert}
    ${decisions}	privatelabel_decisions  ${json}  ${pl_Id}
    set global variable  ${pl_decisions}    ${decisions}
    clear cache
    [Return]	${json}

View Private Label Questions using Parameters
    [Arguments]	${pl_Id}    ${pl_parameters}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/privateLabels/${pl_Id}/questions?${pl_parameters}
    set global variable  ${response_search_api}  ${response.read()}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    set global variable  ${pl_questions}  ${json}
    ${result}	pl_id  ${json}
    clear cache
    [Return]	${result}

View Private Label Recommendations using Parameters
    [Arguments]	${pl_Id}    ${pl_parameters}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/privateLabels/${pl_Id}/recommendations?${pl_parameters}
    set global variable  ${response_search_api}  ${response.read()}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    set global variable  ${pl_recommendations}  ${json}
    ${result}	pl_id  ${json}
    clear cache
    [Return]	${result}

View Private Label Certify using Parameters
    [Arguments]	${pl_Id}    ${pl_parameters}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/privateLabels/${pl_Id}/certify?${pl_parameters}
    set global variable  ${response_search_api}  ${response.read()}
    ${json_convert}	json loads data	${response_search_api}
    ${json}	convert	${json_convert}
    set global variable  ${pl_certify}  ${json}
    ${result}	pl_id  ${json}
    clear cache
    [Return]	${result}

Edit Private Label Asset taxonomy and model nomenclature
   [Arguments]	${pl_asset_template}     ${PL_Id}
   ${File}=     GET FILE    input/Private_Label/PL_Asset/${pl_asset_template}
   ${JSON}	replace variables	${File}
   ${response}=	Post Data To Endpoint	/privateLabels/${PL_Id}/editAssets	${JSON}	200
   ${edit_success}	pl_asset_edit_success    ${response.json()}
   set global variable  ${pl_asset_edit_success}     ${edit_success}
   ${edit_error}    pl_asset_edit_error  ${response.json()}
   set global variable  ${pl_asset_edit_error}   ${edit_error}
   [Return]   ${response.json()}

View Private Label Assets Content Attributes
    [Arguments]	${pl_asset_id}
    ${response}=    GET Data From Endpoint   /privateLabels/${PrivateLabel_Id}/assets/${pl_asset_id}?contentType=${value_as_true}
    ${json}	json loads data	${response_api}
    ${data}  get_data    ${json}
    ${pl_Id}   get_object_values    ${data}    ${plId_key}
    set global variable  ${PL_Id}    ${pl_Id}
    ${pl_assetId}   get_object_values    ${data}    ${plAssetId_key}
    set global variable  ${PL_Asset_Id}    ${pl_assetId}
    ${model_nomenclature}   get_object_values    ${data}    ${modelNomenclature_key}
    set global variable  ${PL_Asset_model_nomenclature}    ${model_nomenclature}
    clear cache
    [Return]	${json}

################################
################################
######  Security Section  ######
################################
################################

Configure Role Access
   [Arguments]	${conftemplate}  ${hierarchy_type}
   ${File}=     GET FILE    input/Security/${conftemplate}
   ${File2}=    replace variables  ${File}
   ${result}=	Post Data To Endpoint	/hierarchy/${hierarchy_type}/accessRoles    ${File2}	200
   ${role_attr}     role_attributes     ${result.json()}
   should not be empty   ${role_attr}
   ${role}     access_role     ${result.json()}
   set global variable   ${access_role}    ${role}
   [Return]     ${result.json()}

Disfigure Role Access
   [Arguments]	${conftemplate}  ${hierarchy_type}
   ${File}=     GET FILE    input/Security/${conftemplate}
   ${File2}=    replace variables  ${File}
   ${result}=	Post Data To Endpoint	/hierarchy/${hierarchy_type}/accessRoles    ${File2}	200
   ${role_attr}     role_attributes     ${result.json()}
   should be empty   ${role_attr}
   ${role}     access_role     ${result.json()}
   set global variable   ${access_role}    ${role}
   [Return]     ${result.json()}

Get Role Access at Attribute Level
    [Arguments]	${hierarchy_type}    ${entity_name}  ${tab_name}     ${user}
    ${response}=    open url	${API_ENDPOINT}/hierarchy/${hierarchy_type}/attributes/accessRoles?entityName=${entity_name}&tabName=${tab_name}&user=${user}
    set global variable  ${response_api}  ${response}
    ${json}	json loads data	${response_api}
    ${result}	attribute_role_access  ${json}
    clear cache
    [Return]	${result}

Get hasError Message
    [Arguments]	${response}
    ${result}	hasError_msg	${response}
    [Return]	${result}

Get list of certificates for PSN
    [Arguments]	${PSN}
    ${response}=    urllib2.urlopen	${API_ENDPOINT}/certificates?partySiteNumber=${PSN}
    set global variable  ${response_api}  ${response.read()}
    ${json_convert}	json loads data	${response_api}
    ${json}	convert	${json_convert}
    ${psn}	get_psn  ${json}
    set global variable   ${psn_cert}    ${psn}
    ${cert_id}	psn_certificate_id  ${json}
    set global variable   ${psn_cert_id}    ${cert_id}
    clear cache
    [Return]	${json}

################################
################################
#  Reference Data Consumption  #
################################
################################

Validate Certificate Reference Attributes
    [Arguments]	${cert_Id}
    ${response}=	open url  	${API_ENDPOINT}/certificate/${cert_Id}/referencedata/validate
    set global variable  ${VCRA_response_api}     ${response}
    ${json}	json loads data	${VCRA_response_api}
#    ${json}	convert	${json_convert}
    ${status}	cert_ref_attributes_status  ${json}
    set global variable  ${ref_attr_status}    ${status}
    should be equal  '${ref_attr_status}'   'Successfully Validated'
    ${errors}     cert_ref_attributes_errors     ${json}
    set global variable  ${ref_attr_errors}    ${errors}
    clear cache
    [Return]	${errors}

Get Reference Attributes from ref_attributes Table
    [Arguments]	${entity_id}
    connect to database	@{database}
    ${attr_names}	query	select attribute_name from ref_attributes where entity_id = '${entity_id}' order by effective_start_date;
    ${split}	extract_value	${attr_names}
    set global variable  ${Ref_attr_names}	${split}
    log to console	"Reference Attribute Names": ${Ref_attr_names}
    disconnect from database
    [Return]     ${Ref_attr_names}

Get Primary Keys from ref_attributes Table
    [Arguments]	${entity_id}    ${pk_id}
    connect to database	@{database}
    ${ids}	query	select id${pk_id}_pk from ref_attributes where entity_id = '${entity_id}' order by effective_start_date;
    ${split}	extract_value	${ids}
    set global variable  ${pk_ids}	${split}
    log to console	"Primary Keys": ${pk_ids}
    disconnect from database
    [Return]     ${pk_ids}

Get version from ref_attributes Table
    [Arguments]	${entity_id}
    connect to database	@{database}
    ${ver}	query	select version from ref_attributes where entity_id = '${entity_id}' order by effective_start_date;
    ${split}	extract_decimal  ${ver}
    set global variable  ${Ref_attr_ver}	${split}
    log to console	"Reference Attribute versions": ${Ref_attr_ver}
    disconnect from database
    [Return]     ${Ref_attr_ver}

Get Associated Attributes of a Product
    [Arguments]	${cert_Id}   ${assetId}
    ${response}=	open url  	${API_ENDPOINT}/certificate/${cert_Id}/referencedata/associatedAttributes?assetId=${assetId}
    set test variable  ${GAAP_response_api}     ${response}
    ${json}	json loads data	${GAAP_response_api}
    ${ass_attr}   associated_attributes   ${json}
    set global variable  ${associated_attributes}	${ass_attr}
    ${ass_attr_names}   get_associated_attributes   ${json}
    set global variable  ${associated_attributes_names}	${ass_attr_names}

################################
################################
#### Reference Data Section ####
################################
################################

Create Scope
    [Arguments]	${scopetemplate}
    ${File}=	GET FILE	input/Reference_Data/${scopetemplate}
    ${result}=	Post Data To Endpoint	/referencedata/scope	${File}	200
    set global variable  ${response_api}    ${result}
    ${S_Id}   scope_id  ${result.json()}
#    set test variable	${scope_Id}	${S_Id}
    set global variable	${scope_Id}	${S_Id}
    log to console	"Scope_ID": ${scope_Id}
    ${S_Code}   scope_code  ${result.json()}
#    set test variable	${scope_Code}	${S_Code}
    set global variable	${scope_Code}	${S_Code}
    log to console	"Scope_Code": ${scope_Code}
    ${S_Title}   scope_title  ${result.json()}
#    set test variable	${scope_Title}	${S_Title}
    set global variable	${scope_Title}	${S_Title}
    log to console	"Scope_Title": ${scope_Title}

Get Standard
    [Arguments]	${stdCode}  ${stdTitle}    ${stdEdition}  ${stdEdition}  ${stdId}
    ${response}=	urllib2.urlopen	${API_ENDPOINT}/referencedata/standard?standardCode=${stdCode}&standardTitle=${stdTitle}&standardEdition=${stdEdition}&standardId=${stdId}
    ${json_convert}	json load data	${response}
    ${json}	convert	${json_convert}
    ${number}   standard_number   ${json}  ${Validation_standard_Id}
    set global variable  ${std_number}	${number}
    ${code}   standard_code   ${json}  ${Validation_standard_Id}
    set global variable  ${std_code}	${code}
    ${name}   standard_name   ${json}  ${Validation_standard_Id}
    set global variable  ${std_name}	${name}
    ${title}   standard_title   ${json}  ${Validation_standard_Id}
    set global variable  ${std_title}	${title}
    ${edition}   standard_edition   ${json}  ${Validation_standard_Id}
    set global variable  ${std_edition}	${edition}
    ${id}   standard_id   ${json}  ${std_name}
    set global variable  ${std_id}	${id}
    clear cache
#    [Return]	${json}

Link Scheme Scope
    [Arguments]	${scopetemplate}    ${hierarchy_Id}
	${file}=	Get File	input/Reference_Data/${scopetemplate}
	${JSON}=	replace variables	${file}
	${result}=	Post Data To Endpoint	/referencedata/scheme/scope/link	${JSON}	200
	set global variable  ${response_api}    ${result}
    ${ss_Id}   scheme_scope_id  ${result.json()}     ${hierarchy_Id}
#    set test variable	${Regression_schemeScopeId}	${ss_Id}
    set global variable	${Regression_schemeScopeId}	${ss_Id}
    log to console	"Scope_Scope_ID": ${Regression_schemeScopeId}

Unlink Scheme Scope
    [Arguments]	${scopetemplate}
	${file}=	Get File	input/Reference_Data/${scopetemplate}
	${JSON}=	replace variables	${file}
	${result}=	Post Data To Endpoint	/referencedata/scheme/scope/link	${JSON}	200
	set global variable  ${response_api}    ${result}
    ${ss}   scheme_scope  ${result.json()}
    should be empty  ${ss}

Link Scheme Scope ProductType
    [Arguments]	${scopetemplate}    ${hierarchy_Id}
	${file}=	Get File	input/Reference_Data/${scopetemplate}
	${JSON}=	replace variables	${file}
	${result}=	Post Data To Endpoint	referencedata/schemeSopeProductType/link	${JSON}	200
	set global variable  ${response_api}    ${result}
    ${ssp_Id}   scheme_scope_productType_id  ${result.json()}     ${hierarchy_Id}
#    set test variable	${scheme_scope_productType_id}	${ss_Id}
    set global variable	${RegProd1_schemeScopeProductTypeId}	${ssp_Id}
    log to console	"scheme_scope_productType_ID": ${RegProd1_schemeScopeProductTypeId}

Unlink Scheme Scope ProductType
    [Arguments]	${scopetemplate}
	${file}=	Get File	input/Reference_Data/${scopetemplate}
	${JSON}=	replace variables	${file}
	${result}=	Post Data To Endpoint	referencedata/schemeSopeProductType/link	${JSON}	200
	set global variable  ${response_api}    ${result}
    ${ssp}   scheme_scope_productType  ${result.json()}
    should be empty  ${ssp}

#Create Standard Label
#    [Arguments]	${scopetemplate}    ${stand_id}
#    ${File}=	GET FILE	input/Reference_Data/${scopetemplate}
#    ${result}=	Post Data To Endpoint	/referencedata/standardLabels/${stand_id}	${File}	200
#    set global variable  ${response_api}    ${result}
#    ${SL_Id}   standard_label_id  ${result.json()}  ${stand_id}
#    set global variable	${standardLabel_Id}	${SL_Id}
#    log to console	"StandardLabel_ID": ${standardLabel_Id}

Link Scheme Scope Standard
    [Arguments]	${scopetemplate}    ${stand_id}
	${file}=	Get File	input/Reference_Data/${scopetemplate}
	${JSON}=	replace variables	${file}
	${result}=	Post Data To Endpoint	referencedata/schemeScopeStandard/link	${JSON}	200
	set global variable  ${response_api}    ${result}
    ${sss_Id}   scheme_scope_standard_id  ${result.json()}     ${stand_id}
    set global variable	${RegVal_schemeScopeStandardId}	${sss_Id}
    log to console	"scheme_scope_Standard_ID": ${RegVal_schemeScopeStandardId}

Unlink Scheme Scope Standard
    [Arguments]	${scopetemplate}
	${file}=	Get File	input/Reference_Data/${scopetemplate}
	${JSON}=	replace variables	${file}
	${result}=	Post Data To Endpoint	referencedata/schemeScopeStandard/link	${JSON}	200
	set global variable  ${response_api}    ${result}
    ${sss}   scheme_scope_standard  ${result.json()}
    should be empty  ${sss}

Add associated attributes to scheme-scope-productType
    [Arguments]	${scopetemplate}    ${schemeScopeProductTypeId}
	${file}=	Get File	input/Reference_Data/${scopetemplate}
	${JSON}=	replace variables	${file}
	${result}=	Post Data To Endpoint	referencedata/schemeScopeProductType/${schemeScopeProductTypeId}/attributes	${JSON}	200
	set global variable  ${response_api}    ${result}
#    ${ssp_Id}   scheme_scope_productType_id  ${result.json()}     ${hierarchy_Id}
#    set global variable	${RegProd1_schemeScopeProductTypeId}	${ssp_Id}
#    log to console	"scheme_scope_productType_ID": ${RegProd1_schemeScopeProductTypeId}

Create Scope2
    [Arguments]	${scopetemplate}
    ${File}=	GET FILE	input/Reference_Data/${scopetemplate}
    ${result}=	Post Data To Endpoint	/referencedata/scope	${File}	200
    set global variable  ${response_api}    ${result}
    ${S_Id}   scope_id  ${result.json()}
#    set test variable	${scope_Id}	${S_Id}
    set global variable	${scope2_Id}	${S_Id}
    log to console	"Scope_ID": ${scope2_Id}
    ${S_Code}   scope_code  ${result.json()}
#    set test variable	${scope_Code}	${S_Code}
    set global variable	${scope2_Code}	${S_Code}
    log to console	"Scope_Code": ${scope2_Code}
    ${S_Title}   scope_title  ${result.json()}
#    set test variable	${scope_Title}	${S_Title}
    set global variable	${scope2_Title}	${S_Title}
    log to console	"Scope_Title": ${scope2_Title}

Link Scheme2 Scope2
    [Arguments]	${scopetemplate}    ${hierarchy_Id}
	${file}=	Get File	input/Reference_Data/${scopetemplate}
	${JSON}=	replace variables	${file}
	${result}=	Post Data To Endpoint	/referencedata/scheme/scope/link	${JSON}	200
	set global variable  ${response_api}    ${result}
    ${ss_Id}   scheme_scope_id  ${result.json()}     ${hierarchy_Id}
#    set test variable	${Regression_schemeScopeId}	${ss_Id}
    set global variable	${Regression2_schemeScopeId}	${ss_Id}
    log to console	"Scope_Scope_ID": ${Regression2_schemeScopeId}

Link Scheme2 Scope2 ProductType2
    [Arguments]	${scopetemplate}    ${hierarchy_Id}
	${file}=	Get File	input/Reference_Data/${scopetemplate}
	${JSON}=	replace variables	${file}
	${result}=	Post Data To Endpoint	referencedata/schemeSopeProductType/link	${JSON}	200
	set global variable  ${response_api}    ${result}
    ${ssp_Id}   scheme_scope_productType_id  ${result.json()}     ${hierarchy_Id}
#    set test variable	${scheme_scope_productType_id}	${ss_Id}
    set global variable	${Reg2Prod2_schemeScopeProductTypeId}	${ssp_Id}
    log to console	"scheme_scope_productType_ID": ${Reg2Prod2_schemeScopeProductTypeId}

Link Scheme2 Scope2 Standard
    [Arguments]	${scopetemplate}    ${stand_id}
	${file}=	Get File	input/Reference_Data/${scopetemplate}
	${JSON}=	replace variables	${file}
	${result}=	Post Data To Endpoint	referencedata/schemeScopeStandard/link	${JSON}	200
	set global variable  ${response_api}    ${result}
    ${sss_Id}   scheme_scope_standard_id  ${result.json()}     ${stand_id}
    set global variable	${Reg2Val_schemeScopeStandardId}	${sss_Id}
    log to console	"scheme_scope_Standard_ID": ${Reg2Val_schemeScopeStandardId}

Link Scheme Scope2
    [Arguments]	${scopetemplate}    ${hierarchy_Id}
	${file}=	Get File	input/Reference_Data/${scopetemplate}
	${JSON}=	replace variables	${file}
	${result}=	Post Data To Endpoint	/referencedata/scheme/scope/link	${JSON}	200
	set global variable  ${response_api}    ${result}
    ${ss_Id}   scheme_scope_id  ${result.json()}     ${hierarchy_Id}
#    set test variable	${Regression_schemeScopeId}	${ss_Id}
    set global variable	${Regression_schemeScope2Id}	${ss_Id}
    log to console	"Scope_Scope_ID": ${Regression_schemeScope2Id}

Link Scheme Scope2 ProductType1
    [Arguments]	${scopetemplate}    ${hierarchy_Id}
	${file}=	Get File	input/Reference_Data/${scopetemplate}
	${JSON}=	replace variables	${file}
	${result}=	Post Data To Endpoint	referencedata/schemeSopeProductType/link	${JSON}	200
	set global variable  ${response_api}    ${result}
    ${ssp_Id}   scheme_scope_productType_id  ${result.json()}     ${hierarchy_Id}
#    set test variable	${scheme_scope_productType_id}	${ss_Id}
    set global variable	${RegProd1_schemeScope2ProductTypeId}	${ssp_Id}
    log to console	"scheme_scope_productType_ID": ${RegProd1_schemeScope2ProductTypeId}

Link Scheme Scope2 Standard
    [Arguments]	${scopetemplate}    ${stand_id}
	${file}=	Get File	input/Reference_Data/${scopetemplate}
	${JSON}=	replace variables	${file}
	${result}=	Post Data To Endpoint	referencedata/schemeScopeStandard/link	${JSON}	200
	set global variable  ${response_api}    ${result}
    ${sss_Id}   scheme_scope_standard_id  ${result.json()}     ${stand_id}
    set global variable	${RegVal_schemeScope2StandardId}	${sss_Id}
    log to console	"scheme_scope_Standard_ID": ${RegVal_schemeScope2StandardId}

Link Scheme2 Scope2 ProductType1
    [Arguments]	${scopetemplate}    ${hierarchy_Id}
	${file}=	Get File	input/Reference_Data/${scopetemplate}
	${JSON}=	replace variables	${file}
	${result}=	Post Data To Endpoint	referencedata/schemeSopeProductType/link	${JSON}	200
	set global variable  ${response_api}    ${result}
    ${ssp_Id}   scheme_scope_productType_id  ${result.json()}     ${hierarchy_Id}
#    set test variable	${scheme_scope_productType_id}	${ss_Id}
    set global variable	${Reg2Prod1_schemeScopeProductTypeId}	${ssp_Id}
    log to console	"scheme_scope_productType_ID": ${Reg2Prod1_schemeScopeProductTypeId}

################################
################################
### SetUp Environment Section ##
################################
################################
Link RegressionScheme-Scope-Product1
    create scope    CreationOfRegScope.json
    Link Scheme Scope    Link_RegressionScheme_Scope.json   ${certificate_hierarchy_Id}
    Link Scheme Scope ProductType    Link_RegessionScheme_Scope_Product1.json   ${regression_product_1_hierarchy_id}
#    Create Standard Label   CreationOfStandardLabel.json     ${Validation_standard_Id}
    link scheme scope standard   Link_RegessionScheme_Scope_ValidationStandard.json  ${Validation_standard_Id}

Link Regression2Scheme-Scope-Product1
    create scope    CreationOfRegScope.json
    Link Scheme Scope    Link_Regression2Scheme_Scope.json   ${certificate2_hierarchy_Id}
    Link Scheme Scope ProductType    Link_RegessionScheme_Scope_Product1.json   ${regression_product_1_hierarchy_id}
    link scheme scope standard   Link_RegessionScheme_Scope_ValidationStandard.json  ${Validation_standard_Id}

Link Regression2Scheme-Scope2-Product2
    create scope2    CreationOfReg2Scope2.json
    Link Scheme2 Scope2    Link_Regression2Scheme_Scope2.json   ${certificate2_hierarchy_Id}
    Link Scheme2 Scope2 ProductType2    Link_Regession2Scheme_Scope2_Product2.json   ${regression_product_2_hierarchy_id}
    link scheme2 scope2 standard   Link_Regession2Scheme_Scope2_ValidationStandard.json  ${Validation_standard_Id}

Link RegressionScheme-Scope2-Product1
    create scope2    CreationOfRegScope2.json
    Link Scheme Scope2    Link_RegressionScheme_Scope2.json   ${certificate_hierarchy_Id}
    Link Scheme Scope2 ProductType1    Link_RegessionScheme_Scope2_Product1.json   ${regression_product_1_hierarchy_id}
    link scheme scope2 standard   Link_RegessionScheme_Scope2_ValidationStandard.json  ${Validation_standard_Id}

Link Regression2Scheme-Scope2-Product1
    create scope2    CreationOfReg2Scope2.json
    Link Scheme2 Scope2    Link_Regression2Scheme_Scope2.json   ${certificate2_hierarchy_Id}
    Link Scheme2 Scope2 ProductType1    Link_Regession2Scheme_Scope2_Product1.json   ${regression_product_1_hierarchy_id}
    link scheme2 scope2 standard   Link_Regession2Scheme_Scope2_ValidationStandard.json  ${Validation_standard_Id}

Link RegSchemeScopeProd1 & Reg2SchemeScope2Prod2
    Link RegressionScheme-Scope-Product1
    Link Regression2Scheme-Scope2-Product2

Unlink RegSchemeScopeProd1 & Reg2SchemeScope2Prod2
    Unlink Scheme Scope    Unlink_ScopeScheme.json
    Unlink Scheme Scope    Unlink_Scope2Scheme2.json

Link RegSchemeScopeProd1 & RegSchemeScope2Prod1
    Link RegressionScheme-Scope-Product1
    Link RegressionScheme-Scope2-Product1

Unlink RegSchemeScopeProd1 & RegSchemeScope2Prod1
    Unlink Scheme Scope    Unlink_ScopeScheme.json
    Unlink Scheme Scope    Unlink_Scope2Scheme.json

Link RegSchemeScopeProd1 & Reg2SchemeScope2Prod1
    Link RegressionScheme-Scope-Product1
    Link Regression2Scheme-Scope2-Product1