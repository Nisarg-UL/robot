*** Variables ***
${\n}
${asset_Id_Product1}
${asset_Id_Product2}
${asset_Id_Product3}
${asset_Id_Product12}
${asset_Id_Product13}
${asset_Id_Product14}
${asset_Id_Product15}
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
${Certificate_Name}
${Certificate_Id_Modify}

################################
################################
####### General Section ########
################################
################################
# Values
${user_1}    Manoj_Automation
${user_2}    Nisarg_Automation
${emp_no_1}    81349
${emp_no_2}    50696
${value_as_Y}   Y
${value_as_N}   N
${value_as_false}   false
${value_as_true}   true
${status_Draft}  Draft
${status_Active}    Active
${status_InActive}    InActive
${status_Under_Revision}    Under Revision
${status_Obsolete}    Obsolete
${status_Withdrawn}    Withdrawn
${value_as_1.0}   1.0
${value_as_0}   0
${value_as_1}   1
${value_as_2}   2
${value_as_4}   4
${value_as_5}   5
${value_as_6}   6
${value_as_9}   9
${value_as_10}  10
${value_as_15}  15
${value_as_400}  400
${value_as_Test}  Test
${past_date_1}    2000-01-01
${past_date_2}    2010-01-01
${future_date_1}    2999-12-31
${future_date_2}    3999-12-31
${future_date_3}    4999-12-31
${time_00}    00:00:00.000
${time_min_TZ}    T00:00:00.000Z
${time_max_TZ}    T23:59:59.999Z

${Automation}    Automation
${project_1}  Project1


# Keys
${user_key}  user
${taxonomy_key}  taxonomy
${hierarchy_key}    hierarchy
${hierarchyId_key}    hierarchyId
${attributes_key}    attributes
${message_key}    message
${user_id}  Manoj_Automation
${status_key}    status
${creation_Date_key}    creationDate
${createdBy_key}    createdBy
${createdOn_key}    creationOn
${updatedBy_key}    updatedBy
${updatedOn_key}    updatedOn
${lockedBy_key}    lockedBy
${lockedOn_key}    lockedOn
${source_key}  source
${version_key}    version

########## Paginated Search ##########
# Values
${exact_search_value}   eq
${like_search_value}    like

${greater_than}   gt
${greater_than_or_equal}    gte
${less_than}   lt
${less_than_or_equal}    lte

# Keys
${searchText_key}   searchText
${offset_key}   offset
${rows_key}   rows
${refiners_key}   refiners
${findkeys_key}   findKeys
${totalCount_key}   totalCount
${lockedOn_key}    lockedBy
${searchParameters_key}    searchParameters
${fromDate_key}  fromDate
${toDate_key}  toDate
${fromCreatedDate_key}  fromCreatedDate
${toCreatedDate_key}  toCreatedDate
${fromModifiedDate_key}  fromModifiedDate
${toModifiedDate_key}  toModifiedDate
${issueDate_key}    issueDate
${revisionDate_key}    revisionDate
${withdrawalDate_key}    withdrawalDate
${expiryDate_key}    expiryDate



################################
################################
######## Asset Section #########
################################
################################

# Values
${product_type_1}   Regression Test Product 1
${product_type_2}   Regression Test Product 2
${product_type_3}   Regression Test Product 3
${product_type}   Regression Test Product
${reference_number}  DEMOFILE
${reference_number_1}  DEMOFILE01
${reference_number_2}  DEMOFILE02
${family_series_1}    Reg-Test
${family_series_2}    Reg-Test2
${model_name_1}  Regression_Test_Model_1
${model_name_12}  Regression_Test_Model_12
${model_name_13}  Regression_Test_Model_13
${model_name_14}  Regression_Test_Model_14
${model_name_15}  Regression_Test_Model_15
${model_name_1_2}    Regression_Test_Model_1_2
${model_name_2}  Regression_Test_Model_2
${model_name_3}  Regression_Test_Model_3
${model_name_4}  Regression_Test_Model_4
${model_name_5}  Regression_Test_Model_5
${model_name_6}  Regression_Test_Model_6
${model_name_7}  Regression_Test_Model_7
${model_name_8}  Regression_Test_Model_8
${model_name_9}  Regression_Test_Model_9
${model_name_search1}  Regression_Test_Model_Search1
${modelNomenclature}    Regression_Test_Model_Nomenclature
${modelNomenclature_1}    Regression_Test_Model_Nomenclature_1
${modelNomenclature_search}    Regression_Test_Model_Nomenclature_Search
${ccn_1}    Reg_CCN_1
${ccn_2}    QMFZ
${collection}   Collection
${collection_1}    Collection1
${collection_2}    Collection2
${collection_3}    Collection3

${product_type_1_s}   regression test product 1
${reference_number_1_s}  demofile01
${family_series_1_s}    reg-test

${asset_state_scratchpad}  scratchpad
${asset_state_associated}  associated
${asset_state_immutable}  immutable

# Keys
${AssetId_key}    assetId
${ulAssetId_key}    ulAssetId
${collectionId_key}    collectionId
${asset_key}   asset
${assetVersion_key}    assetVersion
${productType_key}    productType
${modelName_key}    modelName
${referenceNumber_key}    referenceNumber
${ownerReference_key}    ownerReference_PartySiteID
${family_Series_key}    family_Series
${modelNomenclature_key}     modelNomenclature
${modelNomenclature_name}    Model Nomenclature
${CCN_key}    CCN
${CCN_s_key}    ccn
${collectionName_key}    collectionName
${projectNumber_key}    projectNumber
${quoteNumber_key}    quoteNumber
${orderNumber_key}    orderNumber
${isPLAsset_key}    isPLAsset
${taxonomyExceedReason_key}    taxonomyExceedReason
${taxonomyExceed_key}    taxonomyExceedsFiftyChars

####### Paginated Asset Search #######
${productTypeList_key}    productTypeList
${modelName_key}    modelName
${referenceNumberList_key}    referenceNumberList
${ownerReferenceList_key}    ownerReferenceList
${family_SeriesList_key}    family_SeriesList

# Values



################################
################################
### Multi-Model / Collection ###
################################
################################


################################
################################
##### Certificate Section  #####
################################
################################
# Values
${certificate_name_1}   Regression-US001-1
${certificate_name_2}   Regression-US001-2
${certificate_type_1}   Regression Scheme
${certificate_type_1_url}   Regression+Scheme
${certificate_type_2}   Regression2 Scheme
${certificate_type_2_url}   Regression2+Scheme
${issuing_body_1}   USA
${issuing_body_2}   CAN
${mark_1}   Listed
${certification_scheme_owner_1}   UL LLC
${certify}   Certify
${value_as_Regression}   Regression
${value_as_Scheme}   Scheme
${value_as_ed}   ed

${party_brand_owner}   Brand Owner
${party_production_site}   Production Site
${party_applicant}   Applicant
${party_local_representative}   Local Representative
${party_owner_reference}   Owner Reference


${BO_account_number_1}   1542259
${PS_account_number_1}   249219
${AP_account_number_1}   9568758
${LR_account_number_1}   351328
${OR_account_number_1}   123456

${BO_partysite_number_1}   1606567
${PS_partysite_number_1}   551380
${AP_partysite_number_1}   3245678
${LR_partysite_number_1}   2356898
${OR_partysite_number_1}   7890123


#keys
${certificate_key}    Certificate
${cert_ownerReference_key}    ownerReference
${certificateType_key}    certificateType
${certificateName_key}   certificateName
${issuingBody_key}    issuingBody
${mark_key}    mark
${privateLabel_key}  privateLabel

${certificateStatus_key}    certificateStatus
${revisionNumber_key}   revisionNumber
${certify_key}   certify
${uniqueCertificateId_key}   uniqueCertificateId
${certificateId_key}   certificateId
${partySiteContainerId_key}   partySiteContainerId

${parties_key}  parties
${partySiteNumber_key}  partySiteNumber
${relationshipType_key}  relationshipType
${ipPartyIdentifier_key}  ipPartyIdentifier
${accountNumber_key}  accountNumber

####### Paginated Certificate Search #######
${issuingBodyList_key}    issuingBodyList
${certificateTypeList_key}   certificateTypeList
${markList_key}  markList
${statusList_key}    statusList
${ccnList_key}    ccnList
${issueDateList_key}    issueDateList
${partySiteNumberList_key}    partySiteNumberListList
${partiesRelationshipTypeList_key}    partiesRelationshipTypeList
${partiesRelationshipType_key}   partiesRelationshipType


################################
################################
####  Private Label Section ####
################################
################################
${pl_model_name_1}  PL_Regression_Test_Model_1
${pl_model_name_12}  PL_Regression_Test_Model_12
${pl_model_name_2}  PL_Regression_Test_Model_2
${pl_model_name_3}  PL_Regression_Test_Model_3
${pl_modelNomenclature_1}    PL_Regression_Test_Model_Nomenclature_1
${pl_modelNomenclature_edit}    PL_Regression_Test_Model_Nomenclature_Edit

${plId_key}    privateLabelId
${plAssetId_key}    plAssetId
${pl_impacted_key}    privateLabelImpacted

################################
################################
######  Security Section  ######
################################
################################


################################
################################
#  Reference Data Consumption  #
################################
################################



################################
################################
#### Reference Data Section ####
################################
################################
${Scope_Code_1}  Regression Scheme SC1
${Scope_Title_1}  Regression Scheme ST1


################################
################################
#### Error Messages Section ####
################################
################################
${Data_Object_Error}    data parameter missing in JSON object
${Asset_Search_Error}    There is an issue in the input request, please check if the fields are passed as expected in the request and at least one of the 'searchText', 'searchParameters' or 'filters' value is specified
${Certificate_Search_Error1}  There is an issue in the input request, please check if the fields are passed as expected in the request and at least one of the 'searchText', 'searchParameters' or 'filters' value is specified
${Cert_fromModifiedDate_Error}    Invalid date format - fromModifiedDate. Valid format yyyy-MM-ddThh:mm:ss.SSSZ