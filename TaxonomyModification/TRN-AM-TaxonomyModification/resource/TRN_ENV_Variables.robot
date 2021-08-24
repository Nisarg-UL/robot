*** Variables ***
${API_ENDPOINT}	https://trn.informationplatform.ul.com/InformationPlatformServices/api/v${Api_ver}	#For TRN

@{database}	pymysql	infopltfrm_transDBv05	ul_transUser	PLnk2AQw6j	usnbkinpt022t 	3316	#DB for TRN

${db}         @{database}[1]
${user}       @{database}[2]
${pass_wd}    @{database}[3]
${host}       @{database}[4]
${port}       @{database}[5]

${Api_ver}  5.22

${certificate_hierarchy_Id}      2f218343-3156-4554-83e7-4c2f09ab13fe          #for TRN
${certificate2_hierarchy_Id}     cd9a5b31-7e58-4ba3-a336-6d4afa6a637a          #for TRN
#${certificate3_hierarchy_Id}                                                  #for TRN
${certificate_metadataId}        2a0ce653-7cbc-4b40-ad52-a44105bdac2f          #for TRN
${certificate2_metadataId}       bcf0694e-f8bd-4553-b926-6b7e6fdcd3c5          #for TRN
#${certificate3_metadataId}                                                    #for TRN
${standard_hierarchy_Id}          1f7dc0d1-1f6d-439f-8e16-45b80aa6fdf9         #for TRN - with clause group
${standard_hierarchy_Id}          e19a2796-45b9-46c5-90ec-b9297437c1f4         #for TRN - no clause group
${Reg_prod1_metadataId}           217afac8-ade9-47ae-8989-f77073568c18         #for TRN
${Reg_prod2_metadataId}           fed28662-dbcf-4501-bd10-2e807bff0524         #for TRN
${Reg_prod3_metadataId}           c4579efc-8d20-4a75-afbb-f6afe793b132         #for TRN
${noEvalReqd_hierarchy_Id}        ge28b891-a43e-4f59-9f15-2554f93359fe         #for TRN
${regression_product_1_hierarchy_id}    84d4d93f-7beb-4640-ab09-3098eb4b8640   #for TRN
${regression_product_2_hierarchy_id}    463ec906-d69a-4ead-a87e-fe5e61b3ffc5   #for TRN
${regression_product_3_hierarchy_id}    4756b64a-27ab-4985-bb77-ac0d669b66d1   #for TRN
${certificate_hierarchy_IdV2.1}     c39482fc-8a95-43e9-9383-808500ed8860       #for TRN
${certificate_metadataIdV2.1}       bbc26c14-cc7f-4bc2-94cd-a8b97529c6f1       #for TRN
${certificate_hierarchy_IdV2.2}     3684a3c0-f6a6-40bf-8d1b-dd022f60ebfc       #for TRN
${certificate_metadataIdV2.2}       62c8d9a2-54fb-403e-ba9c-a7283e9cc8f4       #for TRN
${Validation_standard_Id}	        47b1552a-a6ca-11e9-aacf-005056ac6ebd       #for TRN
${Validation_standardLabel_Id}	    7b2342c9-a6cb-11e9-aacf-005056ac6ebd       #for TRN
${Validation_standardLabel2_Id}	    b640365e-a6cb-11e9-aacf-005056ac6ebd       #for TRN
