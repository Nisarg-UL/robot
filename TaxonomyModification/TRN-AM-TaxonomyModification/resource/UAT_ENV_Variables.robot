*** Variables ***
${API_ENDPOINT}	https://qa.informationplatform.ul.com/InformationPlatformServices/api/v${Api_ver}	#For UAT

@{database}	pymysql	infopltfrm_transDBv05	ul_transUser	q2Rbd6Wgpg	usnbkinpt020q.global.ul.com 	3316	#DB for UAT

${db}         @{database}[1]
${user}       @{database}[2]
${pass_wd}    @{database}[3]
${host}       @{database}[4]
${port}       @{database}[5]

${Api_ver}  5.22

${certificate_hierarchy_Id}      3165b616-9e92-4db7-b976-aab81e49b133          #for UAT
${certificate2_hierarchy_Id}     da6c7ba0-14e0-4348-a7e2-4dc8e563c40c          #for UAT
#${certificate3_hierarchy_Id}                                                  #for UAT
${certificate_metadataId}        58796d45-81fa-4c86-9360-1c52129954b6          #for UAT
${certificate2_metadataId}       c4eecc2f-2e8d-443e-baf7-dc02f2637ea5          #for UAT
#${certificate3_metadataId}                                                    #for UAT
${standard_hierarchy_Id}          8292d10a-f5bb-4461-abe3-1b51917149a7         #for UAT - with clause group
${standard_hierarchy_Id}          b6be9207-cd54-4ed5-9fee-7e3b4e5a1f30         #for UAT - no clause group
${Reg_prod1_metadataId}           8fedd68b-3d71-4b3f-b64e-ddf2e7716a13         #for UAT
${Reg_prod2_metadataId}           115e876a-50d7-405f-967f-d194fbf97700         #for UAT
${Reg_prod3_metadataId}           da456da5-daad-4eaa-be9e-b5090f1cae48         #for UAT
${noEvalReqd_hierarchy_Id}     8292d10a-f5bb-4461-abe3-1b51917149a7            #for UAT
${regression_product_1_hierarchy_id}    6f30fd07-66c9-45c2-8d65-27020ff12b97   #for UAT
${regression_product_2_hierarchy_id}   fd881767-6bab-4b3a-9c7f-c95b83c6e031    #for UAT
${regression_product_3_hierarchy_id}    4b61e8df-dbfc-4772-9db5-9790497d026f   #for UAT
${certificate_hierarchy_IdV2.1}     df661a42-d53a-482c-af97-141dd8997ca5       #for UAT
${certificate_metadataIdV2.1}       b79da7b0-bbcf-492e-a590-8a074c6d44c5       #for UAT
${certificate_hierarchy_IdV2.2}     29115518-32c0-42ba-92bd-45214cfe9cbb       #for UAT
${certificate_metadataIdV2.2}       d955e817-ae9f-44e1-94d0-4fb5526578e0       #for UAT
${Validation_standard_Id}	        04b421ea-9bc9-11e9-a3db-005056ac416e       #for UAT
${Validation_standardLabel_Id}	    ab0e091c-9bcb-11e9-a3db-005056ac416e       #for UAT
${Validation_standardLabel2_Id}	    e8c9eed3-9bcb-11e9-a3db-005056ac416e       #for UAT