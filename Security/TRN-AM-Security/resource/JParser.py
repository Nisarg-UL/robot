import json
import collections
import sys
import urllib2

reload(sys)
sys.setdefaultencoding('utf8')


# Convert url response to proper string format by converting boolean to string
def str_to_dict(blob):
	data = json.load(blob)  # returns dictionary with parameter unicode encoded
	s = get_from_dict(data, ["data", "noEvalReqd"])
	t = str(s)
	set_in_dict(data, ["data", "noEvalReqd"], t)
	return data


def convert(data):
	if isinstance(data, basestring):
		return str(data)
	elif isinstance(data, collections.Mapping):
		return dict(map(convert, data.iteritems()))
	elif isinstance(data, collections.Iterable):
		return type(data)(map(convert, data))
	else:
		return data


def get_from_dict(datadict, map_list):
	return reduce(lambda d, k: d[k], map_list, datadict)


def set_in_dict(datadict, map_list, value):
	get_from_dict(datadict, map_list[:-1])[map_list[-1]] = value


def get_by_notation(obj, ref):
	val = obj
	for key in ref.split('.'):
		val = val[key]
	return val


def code(blob):
	v = get_by_notation(blob, 'code')
	return v


def status(blob):
	v = get_by_notation(blob, 'status')
	return v


def api(blob):
	v = get_by_notation(blob, 'apiversion')
	return v


def message(blob):
	v = get_by_notation(blob, 'message')
	return v


def has_components(blob):
	v = get_by_notation(blob, 'data.hasComponents')
	return v


def asset_link_seq_id(blob):
	component = has_components(blob)
	v = get_by_notation(component[0], 'assetAssetLinkSeqId')
	return v


def component_id(blob):
	component = has_components(blob)
	v = get_by_notation(component[0], 'assetId')
	return v


def has_evaluation(blob):
	v = get_by_notation(blob, 'data.hasEvaluation')
	return v


def asset_id(blob):
	v = get_by_notation(blob, 'data.assetId')
	return v


def no_eval_reqd(blob):
	v = get_by_notation(blob, 'data.noEvalReqd')
	return v


def updated_on(blob):
	v = get_by_notation(blob, 'data.updatedOn')
	return v


def updated_by(blob):
	v = get_by_notation(blob, 'data.updatedBy')
	return v


def attributes(blob):
	name = get_by_notation(blob, 'data.attributes')
	return name


def taxonomy(blob):
	name = get_by_notation(blob, 'data.taxonomy')
	return name


def hierarchy(blob):
	name = get_by_notation(blob, 'data.hierarchy')
	return name


def json_dumps(blob):
	data = json.dumps(blob)
	return data


def json_load_data(blob):
	data = json.load(blob)
	return data


def json_loads_data(blob):
	data = json.loads(blob)
	return data


def phase(blob):
	data_dict = blob['data']
	attrib_dict = data_dict['attributes']
	phase_dict = filter(lambda param: param['dataParamName'] == 'phases', attrib_dict)
	return sorted(phase_dict[0].items())


def phase_value(blob):
	data_dict = blob[4]
	return data_dict


def insulation_system_class(blob):
	data_dict = blob['data']
	attrib_dict = data_dict['attributes']
	insulation_system_class_dict = filter(lambda param: param['dataParamName'] == 'insulationSystemClass', attrib_dict)
	return sorted(insulation_system_class_dict[0].items())


def insulation_system_class_value(blob):
	data_dict = blob[4]
	return data_dict


def table_number_of_system(blob):
	data_dict = blob['data']
	attrib_dict = data_dict['attributes']
	phase_dict = filter(lambda param: param['dataParamName'] == 'tableNumberofsystem', attrib_dict)
	return sorted(phase_dict[0].items())


def table_number_of_system_value(blob):
	data_dict = blob[4]
	return data_dict


def assessment_id(blob):
	data_dict = blob['data']['items'][0]
	s = get_from_dict(data_dict, ["hasEvaluatedClauses"])
	t = str(s)
	set_in_dict(data_dict, ["hasEvaluatedClauses"], t)
	data = get_by_notation(blob, 'data')
	items = get_by_notation(data, 'items')
	v = get_by_notation(items[0], 'assessmentId')
	return v


def assessment_param_id(blob):
	data_dict = blob['data']['items'][0]
	n = get_from_dict(data_dict, ["hasAssetChangesImpactingEval"])
	o = str(n)
	set_in_dict(data_dict, ["hasAssetChangesImpactingEval"], o)
	p = get_from_dict(data_dict, ["hasEvaluatedClauses"])
	q = str(p)
	set_in_dict(data_dict, ["hasEvaluatedClauses"], q)
	r = get_from_dict(data_dict, ["isEvalComplete"])
	s = str(r)
	set_in_dict(data_dict, ["isEvalComplete"], s)
	data = get_by_notation(blob, 'data')
	items = get_by_notation(data, 'items')
	v = get_by_notation(items[0], 'requirements')
	requirement_item = v['items'][0]
	t = get_from_dict(requirement_item, ['hasEvaluatedClauses'])
	u = str(t)
	set_in_dict(requirement_item, ['hasEvaluatedClauses'], u)
	w = get_from_dict(requirement_item, ["hasAssetChangesImpactingEval"])
	x = str(w)
	set_in_dict(requirement_item, ["hasAssetChangesImpactingEval"], x)
	subgroup_item = get_by_notation(requirement_item, 'subGroup')['items'][0]
	y = get_from_dict(subgroup_item, ["hasEvaluatedClauses"])
	z = str(y)
	set_in_dict(data_dict, ["hasEvaluatedClauses"], z)
	a = get_from_dict(data_dict, ["hasAssetChangesImpactingEval"])
	b = str(a)
	set_in_dict(data_dict, ["hasAssetChangesImpactingEval"], b)
	assessment_paramid = get_by_notation(subgroup_item, 'items')[0]['assessmentParamId']
	return assessment_paramid


def verdict(blob):
	data_dict = blob['data']['items'][0]['requirements']['items'][0]['subGroup']['items'][0]['items'][0]['summary'][
		'items']
	count = len(data_dict)
	counter = 0
	result = []
	if count == 1:
		verdict_dict = data_dict[counter]
		if not verdict_dict['clauseText']:
			result.append(verdict_dict['clauseId'] + ' : ' + verdict_dict['verdict'] + ' : ' + 'Clause Group =' + ' ' +
						  verdict_dict['clauseGroupText'])
		else:
			result.append(
				verdict_dict['clauseText'] + ' : ' + verdict_dict['verdict'] + ' : ' + 'Clause Group =' + ' ' +
				verdict_dict['clauseGroupText'])
		result.sort()
		return result[0]
	while counter < count:
		verdict_dict = data_dict[counter]
		if not verdict_dict['clauseText']:
			result.append(verdict_dict['clauseId'] + ' : ' + verdict_dict['verdict'] + ' : ' + 'Clause Group =' + ' ' +
						  verdict_dict['clauseGroupText'])
		else:
			result.append(
				verdict_dict['clauseText'] + ' : ' + verdict_dict['verdict'] + ' : ' + 'Clause Group =' + ' ' +
				verdict_dict['clauseGroupText'])
		counter += 1
	result.sort()
	return result


def aeo_detail(blob):
	data_dict = \
		blob['data']['items'][0]['requirements']['items'][0]['subGroup']['items'][0]['items'][0]['summary']['items'][0]
	return data_dict['aeoDetails']


def note(blob):
	data_dict = \
		blob['data']['items'][0]['requirements']['items'][0]['subGroup']['items'][0]['items'][0]['summary']['items'][0]
	return data_dict['notes']


def cl_text(blob):
	data_dict = \
		blob['data']['items'][0]['requirements']['items'][0]['subGroup']['items'][0]['items'][0]['summary']['items'][0]
	return data_dict['clauseText']


def cl_id(blob):
	data_dict = \
		blob['data']['items'][0]['requirements']['items'][0]['subGroup']['items'][0]['items'][0]['summary']['items'][0]
	return data_dict['clauseId']


def table_no(blob):
	data_dict = \
		blob['data']['items'][0]['requirements']['items'][0]['subGroup']['items'][0]['items'][0]['summary']['items'][0]
	return data_dict['tableNumber']


def more_clause(blob):
	data_dict = json.loads(blob)
	data = data_dict['data']['hasMoreClauses']
	return data


def ulAsset_id(blob):
	data_dict = blob['data']['ulAssetId']
	return data_dict


def has_assets(blob):
	data_dict = blob['data']['hasTransaction'][0]['hasAssets'][0]
	return data_dict


def has_assets_2(blob):
	data_dict = blob['data']['hasTransaction'][1]['hasAssets'][0]
	return data_dict


def has_evaluations(blob):
	data_dict = blob['data']['hasTransaction'][0]['hasEvaluations'][0]
	return data_dict


def has_evaluations_2(blob):
	data_dict = blob['data']['hasTransaction'][1]['hasEvaluations'][0]
	return data_dict


def transaction_id_2(blob):
	data_dict = blob['data']['hasTransaction'][1]['transactionId']
	return data_dict


def cert_transaction_id(blob):
	data_dict = blob['data']['hasTransaction'][0]['transactionId']
	return data_dict


def certificate_id_2(blob):
	data_dict = blob['data']['hasTransaction'][1]['certificateId']
	return data_dict


def mark(blob):
	data_dict = blob['data']['mark']
	return json_dumps(data_dict)


def cert_status(blob):
	data_dict = blob['data']['certificateStatus']
	return json_dumps(data_dict)


def col_att(blob):
	col_attr = []
	col_attr_list = blob['data']['collectionAttributes']
	for attrib_dict in col_attr_list:
		for key, value in attrib_dict.items():
			if key == 'name':
				col_attr.append(value)
	return json_dumps(col_attr)


def metadata_col_att(blob):
	col_attr = []
	col_attr_list = blob['data']['attributes']
	for attrib_dict in col_attr_list:
		for key, value in attrib_dict.items():
			if value == '1':
				col_attr.append(attrib_dict['name'])
	return json_dumps(col_attr)


def shared_att(blob):
	sh_attr = []
	sh_attr_list = blob['data']['sharedAttributes']
	for attrib_dict in sh_attr_list:
		for key, value in attrib_dict.items():
			if key == 'name':
				sh_attr.append(value)
	return json_dumps(sh_attr)


def metadata_shared_att(blob):
	sh_attr = []
	sh_attr_list = blob['data']['attributes']
	for attrib_dict in sh_attr_list:
		for key, value in attrib_dict.items():
			if key == 'name':
				sh_attr.append(value)
	return json_dumps(sh_attr)


def col_id(blob):
	data = blob['data']['collectionId']
	return data


def tp1_att6(blob):
	att6 = None
	attrib_list = blob['data']['attributes']
	for attrib_dict in attrib_list:
		for key, value in attrib_dict.items():
			if value == "tP1Attribute6":
				att6 = attrib_dict['value']
	return att6


def shared_att2(blob):
	att2 = None
	attrib_list = blob['data']['attributes']
	for attrib_dict in attrib_list:
		for key, value in attrib_dict.items():
			if value == "sharedAttribute2":
				att2 = attrib_dict['value']
	return att2
	return data


def summary_col_id(blob):
	data = blob['data']['collection'][0]['collectionId']
	return data


def comp_id(blob):
	data = blob['data']['components'][0]['assetId']
	return data


def alternate_component_id(blob):
	data = blob['data']['components'][0]['isComponentOf'][0]['hasAlternates'][0]['assetId']
	return data


def err_msg(blob):
	data_dict = json.loads(blob)
	data = data_dict['message']
	return data


def col_asset_id_1(blob):
	data = blob['data']['assets'][0]['assetId']
	return data


def col_asset_id_2(blob):
	data = blob['data']['assets'][1]['assetId']
	return data


def validate_on_end_message(blob):
	data = blob['data']['status']
	return data


def api_message(blob):
	data_dict = json.loads(blob)
	data = data_dict['data']['status']
	return data


def pl_status(blob):
	data_dict = blob['data']['privateLabelStatus']
	return json_dumps(data_dict)


def pl_error_msg(blob):
	data_dict = json.loads(blob)
	data = data_dict['data']['asset'][0]['HasError'][0]['errorMsg']
	return json_dumps(data)


def pl_asset_id(blob):
	data = blob['data']['asset'][0]['plAssetId']
	return data


def private_label_asset_id(blob):
	data = blob['data']["plAssetId"]
	return data


def get_pl_asset_id(blob):
	data = blob['data']['hasAssets'][0]['plAssetId']
	return data


def pl_id(blob):
	data = blob['data']['privateLabelId']
	return data


def private_label_id(blob):
	data = blob['data']['privateLabels'][0]["privateLabelId"]
	return data


def lo_rep_party_id(blob):
	data_dict = json.loads(blob)
	data = data_dict['data']['parties'][3]['platformPartyId']
	return data


def summary_owner_reference(blob):
	data = blob['data']['certificate'][0]['ownerReference']
	return data


def cert_decisioning_status(blob):
	data_dict = blob['data']['hasQuestions'][0]['relationshipType']
	return json_dumps(data_dict)


def cert_recommendation_status(blob):
	data_dict = blob['data']['hasRecommendation'][0]['attributes'][0]['value']
	return json_dumps(data_dict)


def get_pl_assets_pl_asset_id_1(blob):
	data = blob['data']['privateLabelAssets'][0]['plAssetId']
	return data


def get_pl_assets_pl_asset_id_2(blob):
	data = blob['data']['privateLabelAssets'][1]['plAssetId']
	return data


def get_asset_id_1(blob):
	data = blob['data']['assets'][0]['assetId']
	return data


def get_asset_id_2(blob):
	data = blob['data']['assets'][1]['assetId']
	return data


def cert_owner_reference(blob):
	data_dict = blob['data']['ownerReference']
	return json_dumps(data_dict)


def get_col_order_no(blob):
	order_no = None
	attrib_list = blob['data']['attributes']
	for attrib_dict in attrib_list:
		for key, value in attrib_dict.items():
			if value == "orderNumber":
				order_no = attrib_dict['value']
	return order_no


def get_col_project_no(blob):
	project_no = None
	attrib_list = blob['data']['attributes']
	for attrib_dict in attrib_list:
		for key, value in attrib_dict.items():
			if value == "projectNumber":
				project_no = attrib_dict['value']
	return project_no


def get_col_quote_no(blob):
	quote_no = None
	attrib_list = blob['data']['attributes']
	for attrib_dict in attrib_list:
		for key, value in attrib_dict.items():
			if value == "quoteNumber":
				quote_no = attrib_dict['value']
	return quote_no


def context_description(blob, assetId, assesmentparamId):
	context_desc = None
	items_list = blob['data']['items']
	for items_dict in items_list:
		for key, value in items_dict.items():
			if value == assesmentparamId:
				context_list = items_dict['hasContext']
				for context_dict in context_list:
					for key, value in context_dict.items():
						if value == assetId:
							context_desc = context_dict['contextDescription']
	return context_desc


def has_asset_linkages(blob, assetId, assesmentparamId):
	asset_linkage = None
	items_list = blob['data']['items']
	for items_dict in items_list:
		for key, value in items_dict.items():
			if value == assesmentparamId:
				context_list = items_dict['hasContext']
				for context_dict in context_list:
					for key, value in context_dict.items():
						if value == assetId:
							asset_linkage = context_dict['hasAssetLinkages']
	return asset_linkage


def has_evaluated_clauses(blob, assesmentparamId):
	elav_clause = None
	items_list = blob['data']['items']
	for items_dict in items_list:
		for key, value in items_dict.items():
			if value == assesmentparamId:
				elav_clause = items_dict['hasEvaluatedClauses']
	return elav_clause


def verdict_rendered(blob, assesmentparamId):
	ver_red = None
	items_list = blob['data']['items']
	for items_dict in items_list:
		for key, value in items_dict.items():
			if value == assesmentparamId:
				ver_red = items_dict['verdictRendered']
	return ver_red


def asset_changes_impacting_eval(blob, sub_requirement_name):
	imp_eval = None
	items_list = blob['data']['items']
	for items_dict in items_list:
		for key, value in items_dict.items():
			if value == sub_requirement_name:
				imp_eval = items_dict['hasAssetChangesImpactingEval']
	return imp_eval


def is_eval_complete(blob, sub_requirement_name):
	eval_comp = None
	items_list = blob['data']['items']
	for items_dict in items_list:
		for key, value in items_dict.items():
			if value == sub_requirement_name:
				eval_comp = items_dict['isEvalComplete']
	return eval_comp


def tp1_att8(blob):
	att8 = None
	attrib_list = blob['data']['attributes']
	for attrib_dict in attrib_list:
		for key, value in attrib_dict.items():
			if value == "tP1Attribute8":
				att8 = attrib_dict['value']
	return att8


def asset_asset_link_seq_id(blob, assetId):
	seqid = None
	components_list = blob['data']['hasComponents']
	for components_dict in components_list:
		for key, value in components_dict.items():
			if value == assetId:
				seqid = components_dict['assetAssetLinkSeqId']
	return seqid


def assessment_param_id1(blob):
	data_dict = blob['data']['items'][0]
	n = get_from_dict(data_dict, ["hasAssetChangesImpactingEval"])
	o = str(n)
	set_in_dict(data_dict, ["hasAssetChangesImpactingEval"], o)
	p = get_from_dict(data_dict, ["hasEvaluatedClauses"])
	q = str(p)
	set_in_dict(data_dict, ["hasEvaluatedClauses"], q)
	r = get_from_dict(data_dict, ["isEvalComplete"])
	s = str(r)
	set_in_dict(data_dict, ["isEvalComplete"], s)
	data = get_by_notation(blob, 'data')
	items = get_by_notation(data, 'items')
	v = get_by_notation(items[0], 'requirements')
	requirement_item = v['items'][0]
	t = get_from_dict(requirement_item, ['hasEvaluatedClauses'])
	u = str(t)
	set_in_dict(requirement_item, ['hasEvaluatedClauses'], u)
	w = get_from_dict(requirement_item, ["hasAssetChangesImpactingEval"])
	x = str(w)
	set_in_dict(requirement_item, ["hasAssetChangesImpactingEval"], x)
	subgroup_item = get_by_notation(requirement_item, 'subGroup')['items'][0]
	y = get_from_dict(subgroup_item, ["hasEvaluatedClauses"])
	z = str(y)
	set_in_dict(data_dict, ["hasEvaluatedClauses"], z)
	a = get_from_dict(data_dict, ["hasAssetChangesImpactingEval"])
	b = str(a)
	set_in_dict(data_dict, ["hasAssetChangesImpactingEval"], b)
	assessment_paramid = get_by_notation(subgroup_item, 'items')[1]['assessmentParamId']
	return assessment_paramid


def assessment_param_id2(blob):
	data_dict = blob['data']['items'][0]
	n = get_from_dict(data_dict, ["hasAssetChangesImpactingEval"])
	o = str(n)
	set_in_dict(data_dict, ["hasAssetChangesImpactingEval"], o)
	p = get_from_dict(data_dict, ["hasEvaluatedClauses"])
	q = str(p)
	set_in_dict(data_dict, ["hasEvaluatedClauses"], q)
	r = get_from_dict(data_dict, ["isEvalComplete"])
	s = str(r)
	set_in_dict(data_dict, ["isEvalComplete"], s)
	data = get_by_notation(blob, 'data')
	items = get_by_notation(data, 'items')
	v = get_by_notation(items[0], 'requirements')
	requirement_item = v['items'][0]
	t = get_from_dict(requirement_item, ['hasEvaluatedClauses'])
	u = str(t)
	set_in_dict(requirement_item, ['hasEvaluatedClauses'], u)
	w = get_from_dict(requirement_item, ["hasAssetChangesImpactingEval"])
	x = str(w)
	set_in_dict(requirement_item, ["hasAssetChangesImpactingEval"], x)
	subgroup_item = get_by_notation(requirement_item, 'subGroup')['items'][0]
	y = get_from_dict(subgroup_item, ["hasEvaluatedClauses"])
	z = str(y)
	set_in_dict(data_dict, ["hasEvaluatedClauses"], z)
	a = get_from_dict(data_dict, ["hasAssetChangesImpactingEval"])
	b = str(a)
	set_in_dict(data_dict, ["hasAssetChangesImpactingEval"], b)
	assessment_paramid = get_by_notation(subgroup_item, 'items')[2]['assessmentParamId']
	return assessment_paramid


def tp1_att11(blob):
	att6 = None
	attrib_list = blob['data']['attributes']
	for attrib_dict in attrib_list:
		for key, value in attrib_dict.items():
			if value == "tP1Attribute11":
				att11 = attrib_dict['value']
	return att11


def lock_unlock_message(blob):
	data_dict = json.loads(blob)
	data = data_dict['data']['Message']
	return data


def get_certificate_id(blob):
	data_dict = blob['data']['hasTransaction'][0]['certificateId']
	return data_dict


def certificate_id(blob, assetId):
	cert_id = None
	transaction_list = blob['data']['hasTransaction']
	for transaction_dict in transaction_list:
		for key, value in transaction_dict.items():
			if key == "hasEvaluations":
				asset_list = transaction_dict['hasAssets']
				for asset_dict in asset_list:
					for key, value in asset_dict.items():
						if key == "assetId":
							if value == assetId:
								cert_id = transaction_dict['certificateId']
	return cert_id


def transaction_id(blob, assetId):
	trans_id = None
	transaction_list = blob['data']['hasTransaction']
	for transaction_dict in transaction_list:
		for key, value in transaction_dict.items():
			if key == "hasEvaluations":
				asset_list = transaction_dict['hasAssets']
				for asset_dict in asset_list:
					for key, value in asset_dict.items():
						if key == "assetId":
							if value == assetId:
								trans_id = transaction_dict['transactionId']
	return trans_id


def has_asset_linkages(blob, assetId, assesmentparamId):
	asset_linkage = None
	items_list = blob['data']['items']
	for items_dict in items_list:
		for key, value in items_dict.items():
			if value == assesmentparamId:
				context_list = items_dict['hasContext']
				for context_dict in context_list:
					for key, value in context_dict.items():
						if value == assetId:
							asset_linkage = context_dict['hasAssetLinkages']
	return asset_linkage


def revision_number(blob):
	data = blob['data']['hasProjectHistory'][0]['revisionNumber']
	return data


def has_project_history(blob):
	data_dict = blob['data']['hasProjectHistory']
	return data_dict


def private_label_impact(blob):
	data = blob['data']['privateLabels'][0]["privateLabelImpacted"]
	return data


def impacted_expiry_date(blob):
	data = blob['data']['PrivateLables'][0]['impactedDates']['expiryDate']
	return data


def impacted_withdrawal_date(blob):
	data = blob['data']['PrivateLables'][0]['impactedDates']['withdrawalDate']
	return data


def standard_transaction_id(blob):
	data_dict = json.loads(blob)
	data = data_dict['data']['items'][0]['transactionId']
	return data


def eval_comments(blob):
	data = blob['data']['comments']
	return data


def get_gd_notes_ap1(blob):
	data_dict = json.loads(blob)
	data = data_dict["data"]["clauses"]["params"][0]["responses"][0]["guidanceNote"]
	return data


def get_gd_notes_ap1_2(blob):
	data_dict = json.loads(blob)
	data = data_dict["data"]["clauses"]["params"][0]["responses"][1]["guidanceNote"]
	return data


def get_gd_notes_ap2(blob):
	data_dict = json.loads(blob)
	data = data_dict["data"]["clauses"]["questions"][0]["guidanceNote"]
	return data


def get_gd_notes_rp1(blob):
	data_dict = json.loads(blob)
	data = data_dict["data"]["clauses"]["params"][1]["responses"][0]["guidanceNote"]
	return data


def get_gd_notes_rp1_2(blob):
	data_dict = json.loads(blob)
	data = data_dict["data"]["clauses"]["params"][1]["responses"][1]["guidanceNote"]
	return data


def reviewer_summary_details(blob):
	data_dict = json.loads(blob)
	clause_id_data = data_dict["data"]["items"][0]["clauseId"]
	group_data = data_dict["data"]["items"][0]["requirementGroup"]
	override_ver_data = data_dict["data"]["items"][0]["overriddenVerdict"]
	subgroup_data = data_dict["data"]["items"][0]["requirementSubGroup"]
	context_data = data_dict["data"]["items"][0]["context"]
	ver_data = data_dict["data"]["items"][0]["verdict"]
	assessment_id_data = data_dict["data"]["items"][0]["assetAssmntClauseId"]
	remark_data = data_dict["data"]["items"][0]["remarks"]
	assessment_param_id_data = data_dict["data"]["items"][0]["assetAssmntParamId"]
	return json.dumps(clause_id_data), json.dumps(group_data), json.dumps(override_ver_data), json.dumps(
		subgroup_data), json.dumps(context_data), json.dumps(ver_data), json.dumps(assessment_id_data), json.dumps(
		remark_data), json.dumps(assessment_param_id_data)


def reviewer_summary_details_for_multiple_sub_grp(blob):
	data_dict = json.loads(blob)
	clause_id_data = data_dict["data"]["items"][0]["clauseId"]
	group_data = data_dict["data"]["items"][0]["requirementGroup"]
	override_ver_data = data_dict["data"]["items"][0]["overriddenVerdict"]
	subgroup_data = data_dict["data"]["items"][0]["requirementSubGroup"]
	context_data = data_dict["data"]["items"][0]["context"]
	ver_data = data_dict["data"]["items"][0]["verdict"]
	assessment_id_data = data_dict["data"]["items"][0]["assetAssmntClauseId"]
	remark_data = data_dict["data"]["items"][0]["remarks"]
	assessment_param_id_data = data_dict["data"]["items"][0]["assetAssmntParamId"]
	clause_id2_data = data_dict["data"]["items"][1]["clauseId"]
	group02_data = data_dict["data"]["items"][1]["requirementGroup"]
	override_ver2_data = data_dict["data"]["items"][1]["overriddenVerdict"]
	subgroup02_data = data_dict["data"]["items"][1]["requirementSubGroup"]
	context2_data = data_dict["data"]["items"][1]["context"]
	ver2_data = data_dict["data"]["items"][1]["verdict"]
	assessment_id2_data = data_dict["data"]["items"][1]["assetAssmntClauseId"]
	remark2_data = data_dict["data"]["items"][1]["remarks"]
	assessment_param_id2_data = data_dict["data"]["items"][1]["assetAssmntParamId"]
	return json.dumps(clause_id_data), json.dumps(group_data), json.dumps(override_ver_data), json.dumps(
		subgroup_data), json.dumps(context_data), json.dumps(ver_data), json.dumps(assessment_id_data), json.dumps(
		remark_data), json.dumps(assessment_param_id_data), json.dumps(clause_id2_data), json.dumps(
		group02_data), json.dumps(override_ver2_data), json.dumps(subgroup02_data), json.dumps(context2_data), json.dumps(
		ver2_data), json.dumps(assessment_id2_data), json.dumps(remark2_data), json.dumps(assessment_param_id2_data)


def assessment_param_id_2onwards(blob, grp, sub_grp):
	data_dict = blob['data']['items'][0]['requirements']['items']
	for group_dict in data_dict:
		for key, value in group_dict.items():
			if value == grp:
				sub_grp_items_dict = group_dict['subGroup']['items']
				for sub_grp_dict in sub_grp_items_dict:
					for key, value in sub_grp_dict.items():
						if value == sub_grp:
							assessment_param_id = sub_grp_dict['items'][0]['assessmentParamId']
	return assessment_param_id


# def cert_assets(blob):
# 	data_dict = blob['data']['hasTransaction'][0]['hasAssets']
# 	return data_dict


def cert_decisions(blob):
	data_dict = blob['data']['hasCertify']
	return data_dict


def cert_parties(blob):
	data_dict = blob['data']['parties']
	return data_dict


def test_integer(blob):
	att = None
	attrib_list = blob['data']['attributes']
	for attrib_dict in attrib_list:
		for key, value in attrib_dict.items():
			if value == "testInteger":
				att = attrib_dict['value']
	return att


def validation_error_msgs(blob, assetId):
	data_dict = json.loads(blob)
	msg = None
	errors_list = data_dict['data']['hasError']
	for errors_dict in errors_list:
		for key, value in errors_dict.items():
			if value == assetId:
				msg = errors_dict['message']
	return msg


def cert_assets(blob, certId):
	hasAssets = None
	hasTransaction_list = blob['data']['hasTransaction']
	for hasTransaction_dict in hasTransaction_list:
		for key, value in hasTransaction_dict.items():
			if value == certId:
				hasAssets = hasTransaction_dict['hasAssets']
	return hasAssets


def cert_evaluations(blob, certId):
	hasEvaluations = None
	hasTransaction_list = blob['data']['hasTransaction']
	for hasTransaction_dict in hasTransaction_list:
		for key, value in hasTransaction_dict.items():
			if value == certId:
				hasEvaluations = hasTransaction_dict['hasEvaluations']
	return hasEvaluations


def access_role(blob):
	data = blob["data"]["role"]
	return data


def role_attributes(blob):
	data = blob["data"]["attributes"]
	return data


def attribute_role_access(blob):
	attribute_role = []
	attributes_list = blob['data']['attributes']
	for attributes_dict in attributes_list:
		for key, value in attributes_dict.items():
			if key == 'attributeName':
				role_list = attributes_dict['roleList']
				for role_dict in role_list:
					for key, value in role_dict.items():
						if key == 'roleName':
							attribute_role.append(value)
	return json_dumps(attribute_role)


def hasError_msg(blob):
	data_dict = json.loads(blob)
	data = data_dict['data']['hasError']['message']
	return data


def cert_attributes(blob):
	data_dict = json.loads(blob)
	data = data_dict["data"]["attributes"]
	return data


def attribute_name(blob, att_name):
	attribute_name = []
	for attributes_dict in blob:
		for key, value in attributes_dict.items():
			if value == att_name:
				attribute_name.append(value)
	return attribute_name


def get_attribute_names(blob, att_name):
	attribute_names = []
	for attributes_dict in blob:
		for key, value in attributes_dict.items():
			if key == att_name:
				attribute_names.append(value)
	return json_dumps(attribute_names)


def certificate_status(blob):
	data_dict = json.loads(blob)
	data = data_dict['data']['certificateStatus']
	return json_dumps(data)


def privateLabel_status(blob):
	data_dict = json.loads(blob)
	data = data_dict['data']['privateLabelStatus']
	return json_dumps(data)


def get_components(blob):
	data = blob["data"]["hasComponents"]
	return data


def component_asset_id(blob):
	asset_id = None
	components_list = blob['data']['hasComponents']
	for components_dict in components_list:
		for key, value in components_dict.items():
			if key == 'assetId':
				asset_id = components_dict['assetId']
	return asset_id


def get_asset_linkage_names(blob, assetId, att_name):
	asset_linkage_names = []
	asset_linkage_list = None
	for components_dict in blob:
		for key, value in components_dict.items():
			if value == assetId:
				asset_linkage_list = components_dict['hasAssetLinkage']
				for asset_linkage_dict in asset_linkage_list:
					for key, value in asset_linkage_dict.items():
						if key == att_name:
							asset_linkage_names.append(value)
	return asset_linkage_names


def get_psn(blob):
	data = blob["data"]["psn"]
	return data


def psn_certificate_id(blob):
	cert_id = None
	cert_list = blob['data']['psn']
	for cert_dict in cert_list:
		for key, value in cert_dict.items():
			if key == 'certificateId':
				cert_id = cert_dict['certificateId']
	return cert_id


def cert_ref_attributes(blob):
	data_dict = json.loads(blob)
	data = data_dict["data"]["ref_attributes"]
	return data


def cert_ref_attributes_errors(blob):
	data = blob["data"]["hasErrors"]
	return data


def cert_ref_attributes_errors_msg(blob, refValue):
	msg = None
	for errors_dict in blob:
		for key, value in errors_dict.items():
			if value == refValue:
				msg = errors_dict['message']
	return msg


def cert_ref_attributes_status(blob):
	data = blob["data"]["status"]
	return data


def scope_id(blob):
	data = blob['data']['scopeId']
	return data


def scope_code(blob):
	data = blob['data']['scopeCode']
	return data


def scope_title(blob):
	data = blob['data']['scopeTitle']
	return data


def scheme_scope_id(blob, schemeId):
	id = None
	scope_scheme_list = blob['data']['scopeScheme']
	for scope_scheme_dict in scope_scheme_list:
		for key, value in scope_scheme_dict.items():
			if value == schemeId:
				id = scope_scheme_dict['schemeScopeId']
	return id


def scheme_scope(blob):
	data = blob['data']['scopeScheme']
	return data


def scheme_scope_productType_id(blob, schemeId):
	id = None
	scope_scheme_list = blob['data']['schemeScopeProductType']
	for scope_scheme_dict in scope_scheme_list:
		for key, value in scope_scheme_dict.items():
			if value == schemeId:
				id = scope_scheme_dict['schemeScopeProductTypeId']
	return id


def scheme_scope_productType(blob):
	data = blob['data']['schemeScopeProductType']
	return data


def standard_label_id(blob, standardId):
	id = None
	items_list = blob['data']['items']
	for items_dict in items_list:
		for key, value in items_dict.items():
			if value == standardId:
				id = items_dict['standardLabelId']
	return id


def scheme_scope_standard_id(blob, schemeId):
	id = None
	scope_scheme_list = blob['data']['schemeScopeStandard']
	for scope_scheme_dict in scope_scheme_list:
		for key, value in scope_scheme_dict.items():
			if value == schemeId:
				id = scope_scheme_dict['schemeScopeStandardId']
	return id


def scheme_scope_standard(blob):
	data = blob['data']['schemeScopeStandard']
	return data


def standard_number(blob, standardId):
	num = None
	standard_list = blob['data']['standards']
	for standard_dict in standard_list:
		for key, value in standard_dict.items():
			if value == standardId:
				num = standard_dict['standardNumber']
	return num


def standard_code(blob, standardId):
	code = None
	standard_list = blob['data']['standards']
	for standard_dict in standard_list:
		for key, value in standard_dict.items():
			if value == standardId:
				code = standard_dict['standardCode']
	return code


def standard_name(blob, standardId):
	name = None
	standard_list = blob['data']['standards']
	for standard_dict in standard_list:
		for key, value in standard_dict.items():
			if value == standardId:
				name = standard_dict['standardName']
	return name


def standard_title(blob, standardId):
	title = None
	standard_list = blob['data']['standards']
	for standard_dict in standard_list:
		for key, value in standard_dict.items():
			if value == standardId:
				title = standard_dict['standardTitle']
	return title


def standard_edition(blob, standardId):
	edition = None
	standard_list = blob['data']['standards']
	for standard_dict in standard_list:
		for key, value in standard_dict.items():
			if value == standardId:
				edition = standard_dict['standardEdition']
	return edition


def standard_id(blob, standardName):
	id = None
	standard_list = blob['data']['standards']
	for standard_dict in standard_list:
		for key, value in standard_dict.items():
			if value == standardName:
				id = standard_dict['standardId']
	return id


def associated_attributes(blob):
	data = blob['data']['associatedAttributes']
	return json_dumps(data)


def get_associated_attributes(blob):
	attribute_names = []
	attributes_list = blob['data']['associatedAttributes']
	for attributes_dict in attributes_list:
		for key, value in attributes_dict.items():
			if key == 'name':
				attribute_names.append(value)
	return json_dumps(attribute_names)


def get_parties(blob, relation_type):
	parties = []
	for parties_dict in blob:
		for key, value in parties_dict.items():
			if key == relation_type:
				parties.append(value)
	return parties


def has_questions(blob):
	data_dict = blob['data']['hasQuestions']
	return data_dict


def get_questions(blob):
	questions = []
	questions_list = blob[0]['attributes']
	for questions_dict in questions_list:
		for key, value in questions_dict.items():
			if key == 'name':
				questions.append(value)
	return questions


def has_recommendation(blob):
	data_dict = blob['data']['hasRecommendation']
	return data_dict


def has_certify(blob):
	data_dict = blob['data']['hasCertify']
	return data_dict


def compare_list_of_items(list1, list2):
	if len(list1) == len(list2):
		for item in list1:
			if item in list2:
				continue
			else:
				return 'Lists are different: %s' % item
		for item in list2:
			if item in list1:
				continue
			else:
				return 'Lists are different: %s' % item
		return 'Lists are same'
	else:
		return 'Lengths are different: %d != %d' % (len(list1), len(list2))


def summary_asset_id(blob):
	asset_id = []
	asset_list = blob['data']['asset']
	for asset_dict in asset_list:
		for key, value in asset_dict.items():
			if key == 'assetId':
				id = asset_dict['assetId']
				asset_id.append(id)
	return asset_id


def error_msg(blob):
	data = blob['message']
	return data


def error_code(blob):
	data = blob['code']
	return data


def get_questions_value(blob, key_name):
	questions = []
	questions_list = blob[0]['attributes']
	for questions_dict in questions_list:
		for key, value in questions_dict.items():
			if key == key_name:
				questions.append(value)
	return questions


def asset_id(blob):
	data = blob['data']['assetId']
	return data


def projectHistory_certify(blob):
	data = blob['data']['hasProjectHistory'][0]['hasCertify']
	return data


def projectHistory_certify_attributes(blob, key_name):
	attributes = []
	attributes_list = blob['data']['hasProjectHistory'][0]['hasCertify'][0]['attributes']
	for attributes_dict in attributes_list:
		for key, value in attributes_dict.items():
			if key == key_name:
				attributes.append(value)
	return attributes


def privatelabel_decisions(blob, plId):
	privatelabel_list = blob['data']['privateLabel']
	for privatelabel_dict in privatelabel_list:
		for key, value in privatelabel_dict.items():
			if value == plId:
				return privatelabel_dict
	return privatelabel_dict


def privatelabel_certify_attributes(blob, key_name):
	attributes = []
	attributes_list = blob['hasCertify'][0]['attributes']
	for attributes_dict in attributes_list:
		for key, value in attributes_dict.items():
			if key == key_name:
				attributes.append(value)
	return attributes


def privatelabel_questions(blob, key_name):
	attributes = []
	attributes_list = blob['data']['hasQuestions'][0]['attributes']
	for attributes_dict in attributes_list:
		for key, value in attributes_dict.items():
			if key == key_name:
				attributes.append(value)
	return attributes


def privatelabel_recommendations(blob, key_name):
	attributes = []
	attributes_list = blob['data']['hasRecommendation'][0]['attributes']
	for attributes_dict in attributes_list:
		for key, value in attributes_dict.items():
			if key == key_name:
				attributes.append(value)
	return attributes


def privatelabel_certify(blob, key_name):
	attributes = []
	attributes_list = blob['data']['hasCertify'][0]['attributes']
	for attributes_dict in attributes_list:
		for key, value in attributes_dict.items():
			if key == key_name:
				attributes.append(value)
	return attributes


def reviewer_summary(blob):
	summary = []
	data = json.loads(blob)
	data_dict = convert(data)
	items_list = data_dict["data"]["items"]
	for items_dict in items_list:
		d = dict((k, items_dict[k]) for k in ['clauseId', 'requirementGroup', 'requirementSubGroup'] if k in items_dict)
		v = d.values()
		summary.append(v)
	return summary


def pl_asset_edit_success(blob):
	edit_success = blob['data']['success']
	return edit_success


def pl_asset_edit_error(blob):
	edit_error = blob['data']['error']
	return edit_error


def pl_asset_edit_values(list, key_name):
	values = []
	for dict in list:
		for key, value in dict.items():
			if key == key_name:
				values.append(value)
	return json_dumps(values)


def pl_assets(blob):
	pl_assets = blob['data']['hasAssets']
	return pl_assets


def open_url(url):
	try:
		conn = urllib2.urlopen(url)
		return conn.read().decode()
	except urllib2.HTTPError as e:
		if e.code == 404:
			return 'HTTP Error 404: Not Found'
		if e.code == 405:
			return 'HTTP Error 405: Method Not Allowed'
		else:
			return e.read().decode()


def get_data(blob):
	data = blob['data']
	return data


def get_object_values(data, key_name):
	value = data[key_name]
	return value


def get_key_values_from_list(list_of_values, key_name):
	values = []
	for dict in list_of_values:
		for key, value in dict.items():
			if key == key_name:
				values.append(value)
	return json_dumps(values)


def get_key_values_from_list_of_dictionaries(list_of_dicts, key_name):
	values = []
	for dict in list_of_dicts:
		for key, value in dict.items():
			if key == key_name:
				values.append(value)
	return json_dumps(values)


def get_values_from_list_of_dictionaries(list_of_dict, dic_value):
	values = []
	for dict in list_of_dict:
		for key, value in dict.items():
			if value == dic_value:
				values.append(dict['value'])
	return json_dumps(values)


def get_values_from_list_of_lists_of_dictionaries(blob, dic_value):
	values = []
	data = json.loads(blob)
	list_of_lists = convert(data)
	for list in list_of_lists:
		for dict in list:
			for key, value in dict.items():
				if value == dic_value:
					values.append(dict['value'])
	return json_dumps(values)


def get_key_values_from_list_of_lists_of_dictionaries(list_of_list_of_dicts, key_name):
	values = []
	# data = json.loads(list_of_list_of_dicts)
	# list_of_lists = convert(data)
	for list_of_lists in list_of_list_of_dicts:
		for dict in list_of_lists:
			for key, value in dict.items():
				if key == key_name:
					values.append(value)
	return json_dumps(values)


def get_values_from_dictionary_of_dictionaries(dict_of_dicts, element):
	values = dict_of_dicts[element]['value']
	return json_dumps(values)


def get_all_values_from_dictionary_of_dictionaries(dict_of_dicts, key_name):
	values = []
	dict = dict_of_dicts[key_name]
	for key, value in dict.items():
		values.append(value)
	return json_dumps(values)


def reviewer_summary_questions (blob, key):
	data = json.loads(blob)
	questions = data['data'][key]
	return json_dumps(questions)


def get_dictionary_from_list_of_dictionaries(list_of_dict, dic_value):
	list = []
	for dict in list_of_dict:
		for key, value in dict.items():
			if value == dic_value:
				list.append(dict)
	return list