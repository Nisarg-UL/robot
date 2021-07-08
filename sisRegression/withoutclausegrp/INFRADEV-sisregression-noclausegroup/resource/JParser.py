import json
import collections


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
			result.append(verdict_dict['clauseId'] + ' : ' + verdict_dict['verdict'])
		else:
			result.append(verdict_dict['clauseText'] + ' : ' + verdict_dict['verdict'])
		result.sort()
		return result[0]

	while counter < count:
		verdict_dict = data_dict[counter]
		if not verdict_dict['clauseText']:
			result.append(verdict_dict['clauseId'] + ' : ' + verdict_dict['verdict'])
		else:
			result.append(verdict_dict['clauseText'] + ' : ' + verdict_dict['verdict'])
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
	data = blob['data']['collectionAttributes']
	return data


def metadata_col_att(blob):
	data = blob['data']['attributes'][6]
	return data


def shared_att(blob):
	data = blob['data']['sharedAttributes'][0]
	return data


def metadata_shared_att(blob):
	data = blob['data']['attributes'][11]
	return data


def col_id(blob):
	data = blob['data']['collectionId']
	return data


def tp1_att6(blob):
	data = blob['data']['attributes'][79]['value']
	return data


def shared_att2(blob):
	data = blob['data']['attributes'][-1]['value']
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
