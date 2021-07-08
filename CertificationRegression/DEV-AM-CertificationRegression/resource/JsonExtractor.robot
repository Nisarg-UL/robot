*** Settings ***
Library  JParser.py
Library  FileExtractor.py
Resource  Variables.robot

*** Keywords ***
################################
####### General Section ########
################################
Compare lists
    [Arguments]	${string1}    ${string2}
    ${list1}  convert_str_to_list   ${string1}
    ${list2}  convert_str_to_list   ${string2}
    ${compare_lists}    compare_list_of_items   ${list1}    ${list2}
    should be equal  ${compare_lists}   Lists are same

################################
######## Asset Section #########
################################
Extract asset search response
    [Arguments]	${Asset_summary_json}
    ${data}  get_data    ${Asset_summary_json}
    set global variable  ${Asset_summary_data}  ${data}
    ${total_count}   get_object_values    ${data}    ${totalCount_key}
    set global variable  ${Asset_total_count}    ${total_count}
    ${offset}   get_object_values    ${data}    ${offset_key}
    set global variable  ${Asset_offset}    ${offset}
    ${rows}   get_object_values    ${data}    ${rows_key}
    set global variable  ${Asset_rows}    ${rows}
    ${asset}   get_object_values    ${data}    ${asset_key}
    set global variable  ${Asset_list}    ${asset}
    ${refiners}   get_object_values    ${data}    ${refiners_key}
    set global variable  ${Asset_refiners}    ${refiners}
    ${findkeys}   get_object_values    ${data}    ${findkeys_key}
    set global variable  ${Asset_findkeys}    ${findkeys}
#    ${user}   get_object_values    ${data}    ${user_key}
#   set global variable  ${Asset_user}    ${user}

Extract values from asset list
    [Arguments]	${asset}
    ${model_nomenclature}    get_key_values_from_list_of_dictionaries   ${asset}    ${modelNomenclature_key}
    ${model_nomenclature}    convert_str_to_list    ${model_nomenclature}
    set global variable  ${Asset_model_nomenclature}    ${model_nomenclature}
    ${status}    get_key_values_from_list_of_dictionaries   ${asset}    ${status_key}
    ${status}    convert_str_to_list    ${status}
    set global variable  ${Asset_status}    ${status}
    ${isPLAsset}    get_key_values_from_list_of_dictionaries   ${asset}    ${isPLAsset_key}
    ${isPLAsset}    convert_str_to_list    ${isPLAsset}
    set global variable  ${isPLAsset}    ${isPLAsset}
    ${version}    get_key_values_from_list_of_dictionaries   ${asset}    ${assetVersion_key}
    ${version}    convert_str_to_list    ${version}
    set global variable  ${asset_version}    ${version}
    ${ul_assetId}    get_key_values_from_list_of_dictionaries   ${asset}    ${ulAssetId_key}
    ${ul_assetId}    convert_str_to_list    ${ul_assetId}
    set global variable  ${UL_assetId}    ${ul_assetId}
    ${assetId}    get_key_values_from_list_of_dictionaries   ${asset}    ${AssetId_key}
    ${assetId}    convert_str_to_list    ${assetId}
    set global variable  ${Asset_Id}    ${assetId}
    ${hierarchyId}    get_key_values_from_list_of_dictionaries   ${asset}    ${hierarchyId_key}
    ${hierarchyId}    convert_str_to_list    ${hierarchyId}
    set global variable  ${Asset_hierarchyId}    ${hierarchyId}
    ${collectionId}    get_key_values_from_list_of_dictionaries   ${asset}    ${collectionId_key}
    ${collectionId}    convert_str_to_list    ${collectionId}
    set global variable  ${Asset_collectionId}    ${collectionId}
    ${taxonomy_exceed}    get_key_values_from_list_of_dictionaries   ${asset}    ${taxonomyExceed_key}
#    ${taxonomy_exceed}    convert_str_to_list    ${taxonomy_exceed}
    set global variable  ${Asset_taxonomy_exceed}    ${taxonomy_exceed}
    ${taxonomy_exceed_reason}    get_key_values_from_list_of_dictionaries   ${asset}    ${taxonomyExceedReason_key}
    ${taxonomy_exceed_reason}    convert_str_to_list    ${taxonomy_exceed_reason}
    set global variable  ${Asset_taxonomy_exceed_reason}    ${taxonomy_exceed_reason}
    ${source}    get_key_values_from_list_of_dictionaries   ${asset}    ${source_key}
    ${source}    convert_str_to_list    ${source}
    set global variable  ${Asset_source}    ${source}
    ${created_by}    get_key_values_from_list_of_dictionaries   ${asset}    ${createdBy_key}
    ${created_by}    convert_str_to_list    ${created_by}
    set global variable  ${Asset_created_by}    ${created_by}
    ${created_on}    get_key_values_from_list_of_dictionaries   ${asset}    ${createdOn_key}
    ${created_on}    convert_str_to_list    ${created_on}
    set global variable  ${Asset_created_on}    ${created_on}
    ${updated_by}    get_key_values_from_list_of_dictionaries   ${asset}    ${updatedBy_key}
    ${updated_by}    convert_str_to_list    ${updated_by}
    set global variable  ${Asset_updated_by}    ${updated_by}
    ${updated_on}    get_key_values_from_list_of_dictionaries   ${asset}    ${updatedOn_key}
    ${updated_on}    convert_str_to_list    ${updated_on}
    set global variable  ${Asset_updated_on}    ${updated_on}
    ${locked_by}    get_key_values_from_list_of_dictionaries   ${asset}    ${lockedBy_key}
    ${locked_by}    convert_str_to_list     ${locked_by}
    set global variable  ${Asset_locked_by}    ${locked_by}
    ${locked_on}    get_key_values_from_list_of_dictionaries   ${asset}    ${lockedOn_key}
    ${locked_on}    convert_str_to_list    ${locked_on}
    set global variable  ${Asset_locked_on}    ${locked_on}
    ${taxonomy}    get_key_values_from_list_of_dictionaries   ${asset}    ${taxonomy_key}
#    ${taxonomy}    convert_str_to_list    ${taxonomy}
    set global variable  ${Asset_taxonomy}    ${taxonomy}


Extract values from taxonomy list
    [Arguments]	${Asset_taxonomy}
    ${product_type}    run keyword and continue on failure  get_values_from_list_of_lists_of_dictionaries   ${Asset_taxonomy}    ${productType_key}
    ${product_type}    convert_str_to_list    ${product_type}
    set global variable  ${Asset_product_type}    ${product_type}
    ${model_name}    get_values_from_list_of_lists_of_dictionaries   ${Asset_taxonomy}    ${modelName_key}
    ${model_name}    convert_str_to_list    ${model_name}
    set global variable  ${Asset_model_name}    ${model_name}
    ${reference_number}    get_values_from_list_of_lists_of_dictionaries   ${Asset_taxonomy}    ${referenceNumber_key}
    ${reference_number}    convert_str_to_list    ${reference_number}
    set global variable  ${Asset_reference_number}    ${reference_number}
    ${owner_reference}    get_values_from_list_of_lists_of_dictionaries   ${Asset_taxonomy}    ${ownerReference_key}
    ${owner_reference}    convert_str_to_list    ${owner_reference}
    set global variable  ${Asset_owner_reference}    ${owner_reference}
    ${family_series}    get_values_from_list_of_lists_of_dictionaries   ${Asset_taxonomy}    ${family_Series_key}
    ${family_series}    convert_str_to_list    ${family_series}
    set global variable  ${Asset_family_series}    ${family_series}
    ${creation_date}    get_values_from_list_of_lists_of_dictionaries   ${Asset_taxonomy}    ${creation_Date_key}
    set global variable  ${Asset_creation_date}    ${creation_date}

#Extract values from refiners dictionary
#    [Arguments]	${Asset_refiners}
#    ${product_type}   get_object_values    ${Asset_refiners}    ${productType_key}
#    set global variable  ${RF_product_type_list}    ${product_type}
#    ${reference_number}   get_object_values    ${Asset_refiners}    ${referenceNumber_key}
#    set global variable  ${RF_reference_number_list}    ${reference_number}
#    ${owner_reference}   get_object_values    ${Asset_refiners}    ${ownerReference_key}
#    set global variable  ${RF_owner_reference_list}    ${owner_reference}
#    ${family_series}   get_object_values    ${Asset_refiners}    ${family_Series_key}
#    set global variable  ${RF_family_series_list}    ${family_series}

#Extract values from refiners dictionary
#    [Arguments]	${Asset_refiners}   ${key}
#    ${refiner_list}   get_object_values    ${Asset_refiners}    ${key}
#    ${refiner_value}    json dumps  ${refiner_value}
#    [return]  ${refiner_value}

Extract productType values from refiners dictionary
    [Arguments]	${Asset_refiners}
    ${productType_list}   get_object_values    ${Asset_refiners}    ${productType_key}
    ${productType_list}    json dumps  ${productType_list}
    set global variable  ${RF_productType_list}    ${productType_list}
    [return]  ${RF_productType_list}

Extract referenceNumber values from refiners dictionary
    [Arguments]	${Asset_refiners}
    ${referenceNumber_list}   get_object_values    ${Asset_refiners}    ${referenceNumber_key}
    ${referenceNumber_list}    json dumps  ${referenceNumber_list}
    set global variable  ${RF_referenceNumber_list}    ${referenceNumber_list}
    [return]  ${RF_referenceNumber_list}

Extract ownerReference values from refiners dictionary
    [Arguments]	${Asset_refiners}
    ${ownerReference_list}   get_object_values    ${Asset_refiners}    ${ownerReference_key}
    ${ownerReference_list}    json dumps  ${ownerReference_list}
    set global variable  ${RF_ownerReference_list}    ${ownerReference_list}
    [return]  ${RF_ownerReference_list}

Extract family_Series values from refiners dictionary
    [Arguments]	${Asset_refiners}
    ${family_Series_list}   get_object_values    ${Asset_refiners}    ${family_Series_key}
    ${family_Series_list}    json dumps  ${family_Series_list}
    set global variable  ${RF_family_Series_list}    ${family_Series_list}
    [return]  ${RF_family_Series_list}
#Extract values from findKeys dictionary
#    [Arguments]	${Asset_findkeys}
#    ${product_type_list}  get_object_values    ${Asset_findkeys}    ${productTypeList_key}
#    ${product_type}  get_key_values_from_list_of_dictionaries    ${product_type_list}    ${productType_key}
#    set global variable  ${FK_product_type_list}    ${product_type}
#    ${reference_number_list}   get_object_values    ${Asset_findkeys}    ${referenceNumberList_key}
#    ${reference_number}   get_key_values_from_list_of_dictionaries    ${reference_number_list}    ${referenceNumber_key}
#    set global variable  ${FK_reference_number_list}    ${reference_number}
#    ${owner_reference_list}    get_object_values    ${Asset_findkeys}    ${ownerReferenceList_key}
#    ${owner_reference}     get_key_values_from_list_of_dictionaries    ${owner_reference_list}    ${ownerReference_key}
#    set global variable  ${FK_owner_reference_list}    ${owner_reference}
#    ${family_series_list}     get_object_values    ${Asset_findkeys}    ${family_SeriesList_key}
#    ${family_series}     get_key_values_from_list_of_dictionaries    ${family_series_list}    ${family_Series_key}
#    set global variable  ${FK_family_series_list}    ${family_series}
#    ${searchParameters_dict}   get_object_values    ${Asset_findkeys}    ${searchParameters_key}
#    set global variable  ${FK_searchParameters_dict}    ${searchParameters_dict}

#Extract values from findKeys dictionary
#    [Arguments]	${Asset_findkeys}   ${List_key}   ${key}
#    ${findKeys_list}  get_object_values    ${Asset_findkeys}    ${List_key}
#    ${findKeys_value}  get_key_values_from_list_of_dictionaries    ${findKeys_list}    ${key}
#    [return]  ${findKeys_value}

Extract productTypeList values from findKeys dictionary
    [Arguments]	${Asset_findkeys}
    ${productType_list}  get_object_values    ${Asset_findkeys}    ${productTypeList_key}
    ${productType_values}  get_key_values_from_list_of_dictionaries    ${productType_list}    ${productType_key}
    set global variable  ${FK_productType_values}    ${productType_values}
    [return]  ${FK_productType_values}

Extract ownerReferenceList values from findKeys dictionary
    [Arguments]	${Asset_findkeys}
    ${ownerReference_list}  get_object_values    ${Asset_findkeys}    ${ownerReferenceList_key}
    ${ownerReference_values}  get_key_values_from_list_of_dictionaries    ${ownerReference_list}    ${ownerReference_key}
    set global variable  ${FK_ownerReference_values}    ${ownerReference_values}
    [return]  ${FK_ownerReference_values}

Extract referenceNumberList values from findKeys dictionary
    [Arguments]	${Asset_findkeys}
    ${referenceNumber_list}  get_object_values    ${Asset_findkeys}    ${referenceNumberList_key}
    ${referenceNumber_values}  get_key_values_from_list_of_dictionaries    ${referenceNumber_list}    ${referenceNumber_key}
    set global variable  ${FK_referenceNumber_values}    ${referenceNumber_values}
    [return]  ${FK_referenceNumber_values}

Extract family_SeriesList values from findKeys dictionary
    [Arguments]	${Asset_findkeys}
    ${family_Series_list}  get_object_values    ${Asset_findkeys}    ${family_SeriesList_key}
    ${family_Series_values}  get_key_values_from_list_of_dictionaries    ${family_Series_list}    ${family_Series_key}
    set global variable  ${FK_family_Series_values}    ${family_Series_values}
    [return]  ${FK_family_Series_values}

Extract statusList values from findKeys dictionary
    [Arguments]	${Asset_findkeys}
    ${satus_list}  get_object_values    ${Asset_findkeys}    ${statusList_key}
    ${status_values}  get_key_values_from_list_of_dictionaries    ${satus_list}    ${status_key}
    set global variable  ${FK_status_values}    ${status_values}
    [return]  ${FK_status_values}

Extract ownerReference_PartySiteIDList values from findKeys dictionary
    [Arguments]	${Asset_findkeys}
    ${ownerReference_PartySiteID_list}  get_object_values    ${Asset_findkeys}    ${ownerReference_PartySiteIDList_key}
    ${ownerReference_PartySiteID_values}  get_key_values_from_list_of_dictionaries    ${ownerReference_PartySiteID_list}    ${ownerReference_key}
    set global variable  ${FK_ownerReference_PartySiteID_values}    ${ownerReference_PartySiteID_values}
    [return]  ${FK_ownerReference_PartySiteID_values}

Extract searchParameters from findKeys dictionary
    [Arguments]	${Asset_findkeys}
    ${searchParameters_dict}   get_object_values    ${Asset_findkeys}    ${searchParameters_key}
    set global variable  ${FK_searchParameters_dict}    ${searchParameters_dict}
    [return]  ${FK_searchParameters_dict}

Extract productType values from searchParameters dictionary
    [Arguments]	${FK_searchParameters_dict}
    ${productType_list}    get_all_values_from_dictionary_of_dictionaries   ${FK_searchParameters_dict}    ${productType_key}
    set global variable  ${SP_productType_values}  ${productType_list}
    [return]  ${SP_productType_values}

Extract modelName values from searchParameters dictionary
    [Arguments]	${FK_searchParameters_dict}
    ${modelName_list}    get_all_values_from_dictionary_of_dictionaries   ${FK_searchParameters_dict}    ${modelName_key}
    set global variable  ${SP_modelName_values}  ${modelName_list}
    [return]  ${SP_modelName_values}

Extract referenceNumber values from searchParameters dictionary
    [Arguments]	${FK_searchParameters_dict}
    ${referenceNumber_list}    get_all_values_from_dictionary_of_dictionaries   ${FK_searchParameters_dict}    ${referenceNumber_key}
    set global variable  ${SP_referenceNumber_values}  ${referenceNumber_list}
    [return]  ${SP_referenceNumber_values}

Extract ownerReference values from searchParameters dictionary
    [Arguments]	${FK_searchParameters_dict}
    ${ownerReference_list}    get_all_values_from_dictionary_of_dictionaries   ${FK_searchParameters_dict}    ${ownerReference_key}
    set global variable  ${SP_ownerReference_values}  ${ownerReference_list}
    [return]  ${SP_ownerReference_values}

Extract family_Series values from searchParameters dictionary
    [Arguments]	${FK_searchParameters_dict}
    ${family_Series_list}    get_all_values_from_dictionary_of_dictionaries   ${FK_searchParameters_dict}    ${family_Series_key}
    set global variable  ${SP_family_Series_values}  ${family_Series_list}
    [return]  ${SP_family_Series_values}

Extract collectionName values from searchParameters dictionary
    [Arguments]	${FK_searchParameters_dict}
    ${collectionName_list}    get_all_values_from_dictionary_of_dictionaries   ${FK_searchParameters_dict}    ${collectionName_key}
    set global variable  ${SP_collectionName_values}  ${collectionName_list}
    [return]  ${SP_collectionName_values}

Extract projectNumber values from searchParameters dictionary
    [Arguments]	${FK_searchParameters_dict}
    ${projectNumber_list}    get_all_values_from_dictionary_of_dictionaries   ${FK_searchParameters_dict}    ${projectNumber_key}
    set global variable  ${SP_projectNumber_values}  ${projectNumber_list}
    [return]  ${SP_projectNumber_values}

Extract quoteNumber values from searchParameters dictionary
    [Arguments]	${FK_searchParameters_dict}
    ${quoteNumber_list}    get_all_values_from_dictionary_of_dictionaries   ${FK_searchParameters_dict}    ${quoteNumber_key}
    set global variable  ${SP_quoteNumber_values}  ${quoteNumber_list}
    [return]  ${SP_quoteNumber_values}

Extract orderNumber values from searchParameters dictionary
    [Arguments]	${FK_searchParameters_dict}
    ${orderNumber_list}    get_all_values_from_dictionary_of_dictionaries   ${FK_searchParameters_dict}    ${orderNumber_key}
    set global variable  ${SP_orderNumber_values}  ${orderNumber_list}
    [return]  ${SP_orderNumber_values}

Extract ccn values from searchParameters dictionary
    [Arguments]	${FK_searchParameters_dict}
    ${ccn_list}    get_all_values_from_dictionary_of_dictionaries   ${FK_searchParameters_dict}    ${ccn_key}
    set global variable  ${SP_ccn_values}  ${ccn_list}
    [return]  ${SP_ccn_values}

Extract searchText from findKeys dictionary
    [Arguments]	${Asset_findkeys}
    ${searchText}   get_object_values    ${Asset_findkeys}    ${searchText_key}
    set global variable  ${FK_searchText}    ${searchText}
    [return]  ${FK_searchText}

Extract modelNomenclature from findKeys dictionary
    [Arguments]	${Asset_findkeys}
    ${modelNomenclature}   get_object_values    ${Asset_findkeys}    ${modelNomenclature_key}
    set global variable  ${FK_modelNomenclature}    ${modelNomenclature}
    [return]  ${FK_modelNomenclature}

Extract isPLAsset from findKeys dictionary
    [Arguments]	${Asset_findkeys}
    ${isPLAsset}   get_object_values    ${Asset_findkeys}    ${isPLAsset_key}
    set global variable  ${FK_isPLAsset}    ${isPLAsset}
    [return]  ${FK_isPLAsset}

Extract fromDate and toDate from findKeys dictionary
    [Arguments]	${Asset_findkeys}
    ${fromDate}   get_object_values    ${Asset_findkeys}    ${fromDate_key}
    set global variable  ${FK_fromDate}    ${fromDate}
    ${toDate}   get_object_values    ${Asset_findkeys}    ${toDate_key}
    set global variable  ${FK_toDate}    ${toDate}
    set global variable  ${FK_from&toDate}  [${FK_fromDate}, ${FK_toDate}]
    [return]  ${FK_from&toDate}

Extract fromCreatedDate and toCreatedDate from findKeys dictionary
    [Arguments]	${Asset_findkeys}
    ${fromCreatedDate}   get_object_values    ${Asset_findkeys}    ${fromCreatedDate_key}
    set global variable  ${FK_fromCreatedDate}    ${fromCreatedDate}
    ${toCreatedDate}   get_object_values    ${Asset_findkeys}    ${toCreatedDate_key}
    set global variable  ${FK_toCreatedDate}    ${toCreatedDate}
    set global variable  ${FK_from&toCreatedDate}  [${FK_fromCreatedDate}, ${FK_toCreatedDate}]
    [return]  ${FK_from&toCreatedDate}

Extract fromModifiedDate and toModifiedDate from findKeys dictionary
    [Arguments]	${Asset_findkeys}
    ${fromModifiedDate}   get_object_values    ${Asset_findkeys}    ${fromModifiedDate_key}
    set global variable  ${FK_fromModifiedDate}    ${fromModifiedDate}
    ${toModifiedDate}   get_object_values    ${Asset_findkeys}    ${toModifiedDate_key}
    set global variable  ${FK_toModifiedDate}    ${toModifiedDate}
    set global variable  ${FK_from&toModifiedDate}  [${FK_fromModifiedDate}, ${FK_toModifiedDate}]
    [return]  ${FK_from&toModifiedDate}

################################
##### Certificate Section  #####
################################
Extract certificate search response
    [Arguments]	${certificate_search}
    ${data}  get_data    ${certificate_search}
    set global variable  ${certificate_search_data}  ${data}
    ${total_count}   get_object_values    ${data}    ${totalCount_key}
    set global variable  ${certificate_total_count}    ${total_count}
    ${offset}   get_object_values    ${data}    ${offset_key}
    set global variable  ${certificate_offset}    ${offset}
    ${rows}   get_object_values    ${data}    ${rows_key}
    set global variable  ${certificate_rows}    ${rows}
    ${certificate}   get_object_values    ${data}    ${certificate_key}
    set global variable  ${certificate_list}    ${certificate}
    ${refiners}   get_object_values    ${data}    ${refiners_key}
    set global variable  ${certificate_refiners}    ${refiners}
    ${findkeys}   get_object_values    ${data}    ${findkeys_key}
    set global variable  ${certificate_findkeys}    ${findkeys}
#    ${user}   get_object_values    ${data}    ${user_key}
#    set global variable  ${certificate_user}    ${user}

Extract values from certificate list
    [Arguments]	${certificate_list}
    ${certificateStatus}    get_key_values_from_list_of_dictionaries   ${certificate_list}    ${certificateStatus_key}
    set global variable  ${certificate_status}    ${certificateStatus}
    ${privateLabel}    get_key_values_from_list_of_dictionaries   ${certificate_list}    ${privateLabel_key}
    set global variable  ${is_privateLabel}    ${privateLabel}
    ${version}    get_key_values_from_list_of_dictionaries   ${certificate_list}    ${version_key}
    set global variable  ${certificate_version}    ${version}
    ${revisionNumber}    get_key_values_from_list_of_dictionaries   ${certificate_list}    ${revisionNumber_key}
    set global variable  ${revision_number}    ${revisionNumber}
    ${certify}    get_key_values_from_list_of_dictionaries   ${certificate_list}    ${certify_key}
    set global variable  ${certify}    ${certify}
    ${uniqueCertificateId}    get_key_values_from_list_of_dictionaries   ${certificate_list}    ${uniqueCertificateId_key}
    set global variable  ${unique_certificateId}    ${uniqueCertificateId}
    ${certificateId}    get_key_values_from_list_of_dictionaries   ${certificate_list}    ${certificateId_key}
    set global variable  ${CS_certificate_Id}    ${certificateId}
    ${hierarchyId}    get_key_values_from_list_of_dictionaries   ${certificate_list}    ${hierarchyId_key}
    set global variable  ${CS_certificate_hierarchyId}    ${hierarchyId}
    ${partySiteContainerId}    get_key_values_from_list_of_dictionaries   ${certificate_list}    ${partySiteContainerId_key}
    set global variable  ${CS_partySiteContainerId}    ${partySiteContainerId}
    ${certificateType}    get_key_values_from_list_of_dictionaries   ${certificate_list}    ${certificateType_key}
    set global variable  ${CS_certificate_type}    ${certificateType}
    ${certificateName}    get_key_values_from_list_of_dictionaries   ${certificate_list}    ${certificateName_key}
    set global variable  ${CS_certificate_name}    ${certificateName}
    ${ownerReference}    get_key_values_from_list_of_dictionaries   ${certificate_list}    ${cert_ownerReference_key}
    set global variable  ${CS_Cerificate_owner_reference}    ${ownerReference}
    ${issuingBody}    get_key_values_from_list_of_dictionaries   ${certificate_list}    ${issuingBody_key}
    set global variable  ${CS_issuing_body}    ${issuingBody}
    ${mark}    get_key_values_from_list_of_dictionaries   ${certificate_list}    ${mark_key}
    set global variable  ${CS_mark}    ${mark}
    ${ccn}    get_key_values_from_list_of_dictionaries   ${certificate_list}    ${CCN_s_key}
    set global variable  ${CS_cert_ccn}    ${ccn}
    ${created_by}    get_key_values_from_list_of_dictionaries   ${certificate_list}    ${createdBy_key}
    set global variable  ${cert_created_by}    ${created_by}
    ${created_on}    get_key_values_from_list_of_dictionaries   ${certificate_list}    ${createdOn_key}
    set global variable  ${cert_created_on}    ${created_on}
    ${updated_by}    get_key_values_from_list_of_dictionaries   ${certificate_list}    ${updatedBy_key}
    set global variable  ${cert_updated_by}    ${updated_by}
    ${updated_on}    get_key_values_from_list_of_dictionaries   ${certificate_list}    ${updatedOn_key}
    set global variable  ${cert_updated_on}    ${updated_on}
    ${locked_by}    get_key_values_from_list_of_dictionaries   ${certificate_list}    ${lockedBy_key}
    set global variable  ${cert_locked_by}    ${locked_by}
    ${locked_on}    get_key_values_from_list_of_dictionaries   ${certificate_list}    ${lockedOn_key}
    set global variable  ${cert_locked_on}    ${locked_on}
    ${issueDate}    get_key_values_from_list_of_dictionaries   ${certificate_list}    ${issueDate_key}
    set global variable  ${CS_issueDate}    ${issueDate}
    ${revisionDate}    get_key_values_from_list_of_dictionaries   ${certificate_list}    ${revisionDate_key}
    set global variable  ${CS_revisionDate}    ${revisionDate}
    ${withdrawalDate}    get_key_values_from_list_of_dictionaries   ${certificate_list}    ${withdrawalDate_key}
    set global variable  ${CS_withdrawalDate}    ${withdrawalDate}
    ${expiryDate}    get_key_values_from_list_of_dictionaries   ${certificate_list}    ${expiryDate_key}
    set global variable  ${CS_expiryDate}    ${expiryDate}
    ${parties}    get_key_values_from_list_of_dictionaries   ${certificate_list}    ${parties_key}
    set global variable  ${parties}    ${parties}

Extract values from parties list
    [Arguments]	${parties}
    ${parties_py}   json loads data     ${parties}
    ${partySiteNumber}   get_key_values_from_list_of_lists_of_dictionaries     ${parties_py}     ${partySiteNumber_key}
    set global variable  ${partySiteNumber_list}  ${partySiteNumber}
    ${relationshipType}   get_key_values_from_list_of_lists_of_dictionaries     ${parties_py}     ${relationshipType_key}
    set global variable  ${relationshipType_list}  ${relationshipType}
    ${ipPartyIdentifier}   get_key_values_from_list_of_lists_of_dictionaries     ${parties_py}     ${ipPartyIdentifier_key}
    set global variable  ${ipPartyIdentifier_list}  ${ipPartyIdentifier}
    ${accountNumber}   get_key_values_from_list_of_lists_of_dictionaries     ${parties_py}     ${accountNumber_key}
    set global variable  ${accountNumber_list}  ${accountNumber}

Extract certificateType values from searchParameters dictionary
    [Arguments]	${FK_searchParameters_dict}
    ${certificateType_list}    get_all_values_from_dictionary_of_dictionaries   ${FK_searchParameters_dict}    ${certificateType_key}
    set global variable  ${SP_certificateType_values}  ${certificateType_list}
    [return]  ${SP_certificateType_values}

Extract certificateName values from searchParameters dictionary
    [Arguments]	${FK_searchParameters_dict}
    ${certificateName_list}    get_all_values_from_dictionary_of_dictionaries   ${FK_searchParameters_dict}    ${certificateName_key}
    set global variable  ${SP_certificateName_values}  ${certificateName_list}
    [return]  ${SP_certificateName_values}

Extract issuingBody values from searchParameters dictionary
    [Arguments]	${FK_searchParameters_dict}
    ${issuingBody_list}    get_all_values_from_dictionary_of_dictionaries   ${FK_searchParameters_dict}    ${issuingBody_key}
    set global variable  ${SP_issuingBody_values}  ${issuingBody_list}
    [return]  ${SP_issuingBody_values}

Extract mark values from searchParameters dictionary
    [Arguments]	${FK_searchParameters_dict}
    ${mark_list}    get_all_values_from_dictionary_of_dictionaries   ${FK_searchParameters_dict}    ${mark_key}
    set global variable  ${SP_mark_values}  ${mark_list}
    [return]  ${SP_mark_values}

Extract Certificate ownerReference values from searchParameters dictionary
    [Arguments]	${FK_searchParameters_dict}
    ${cert_ownerReference_list}    get_all_values_from_dictionary_of_dictionaries   ${FK_searchParameters_dict}    ${cert_ownerReference_key}
    set global variable  ${SP_cert_ownerReference_values}  ${cert_ownerReference_list}
    [return]  ${SP_cert_ownerReference_values}

Extract Certificate ownerReferenceList values from findKeys dictionary
    [Arguments]	${certificate_findkeys}
    ${ownerReference_list}  get_object_values    ${certificate_findkeys}    ${ownerReferenceList_key}
    ${ownerReference_values}  get_key_values_from_list_of_dictionaries    ${ownerReference_list}    ${cert_ownerReference_key}
    set global variable  ${FK_ownerReference_values}    ${ownerReference_values}
    [return]  ${FK_ownerReference_values}

Extract Certificate issuingBodyList values from findKeys dictionary
    [Arguments]	${certificate_findkeys}
    ${issuingBody_list}  get_object_values    ${certificate_findkeys}    ${issuingBodyList_key}
    ${issuingBody_values}  get_key_values_from_list_of_dictionaries    ${issuingBody_list}    ${issuingBody_key}
    set global variable  ${FK_issuingBody_values}    ${issuingBody_values}
    [return]  ${FK_issuingBody_values}

Extract Certificate certificateTypeList values from findKeys dictionary
    [Arguments]	${certificate_findkeys}
    ${certificateType_list}  get_object_values    ${certificate_findkeys}    ${certificateTypeList_key}
    ${certificateType_values}  get_key_values_from_list_of_dictionaries    ${certificateType_list}    ${certificateType_key}
    set global variable  ${FK_certificateType_values}    ${certificateType_values}
    [return]  ${FK_certificateType_values}

Extract Certificate markList values from findKeys dictionary
    [Arguments]	${certificate_findkeys}
    ${mark_list}  get_object_values    ${certificate_findkeys}    ${markList_key}
    ${mark_values}  get_key_values_from_list_of_dictionaries    ${mark_list}    ${mark_key}
    set global variable  ${FK_mark_values}    ${mark_values}
    [return]  ${FK_mark_values}

Extract Certificate statusList values from findKeys dictionary
    [Arguments]	${certificate_findkeys}
    ${status_list}  get_object_values    ${certificate_findkeys}    ${statusList_key}
    ${status_values}  get_key_values_from_list_of_dictionaries    ${status_list}    ${status_key}
    set global variable  ${FK_status_values}    ${status_values}
    [return]  ${FK_status_values}

Extract Certificate ccnList values from findKeys dictionary
    [Arguments]	${certificate_findkeys}
    ${ccn_list}  get_object_values    ${certificate_findkeys}    ${ccnList_key}
    ${ccn_values}  get_key_values_from_list_of_dictionaries    ${ccn_list}    ${ccn_s_key}
    set global variable  ${FK_ccn_values}    ${ccn_values}
    [return]  ${FK_ccn_values}

Extract Certificate issueDateList values from findKeys dictionary
    [Arguments]	${certificate_findkeys}
    ${issueDate_list}  get_object_values    ${certificate_findkeys}    ${issueDateList_key}
    ${issueDate_values}  get_key_values_from_list_of_dictionaries    ${issueDate_list}    ${issueDate_key}
    set global variable  ${FK_issueDate_values}    ${issueDate_values}
    [return]  ${FK_issueDate_values}

Extract Certificate partySiteNumberList values from findKeys dictionary
    [Arguments]	${certificate_findkeys}
    ${partySiteNumber_list}  get_object_values    ${certificate_findkeys}    ${partySiteNumberList_key}
    ${partySiteNumber_values}  get_key_values_from_list_of_dictionaries    ${partySiteNumber_list}    ${partySiteNumber_key}
    set global variable  ${FK_partySiteNumber_values}    ${partySiteNumber_values}
    [return]  ${FK_partySiteNumber_values}

Extract Certificate partiesRelationshipTypeList values from findKeys dictionary
    [Arguments]	${certificate_findkeys}
    ${partiesRelationshipType_list}  get_object_values    ${certificate_findkeys}    ${partiesRelationshipTypeList_key}
    ${partiesRelationshipType_values}  get_key_values_from_list_of_dictionaries    ${partiesRelationshipType_list}    ${partiesRelationshipType_key}
    set global variable  ${FK_partiesRelationshipType_values}    ${partiesRelationshipType_values}
    [return]  ${FK_partiesRelationshipType_values}