*** Variables ***
${API_ENDPOINT}	https://dev.informationplatform.ul.com/InformationPlatformServices/api/v${Api_ver}	#For DEV

@{database}  pymysql    infopltfrm_transDBv07  ul_transUser    29LPMW6Ljv  usnbkinpt018d.global.ul.com    3316	#DB for DEV

${db}         @{database}[1]
${user}       @{database}[2]
${pass_wd}    @{database}[3]
${host}       @{database}[4]
${port}       @{database}[5]

${Api_ver}  5.22

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