import json
import collections


def file_str_to_dict_with_no_boolean_value(blob):
    data_dict = json.loads(blob)  # returns dictionary with parameter unicode encoded
    data = file_convert(data_dict)
    return data


def file_str_to_dict(blob):
    data_dict = json.loads(blob)  # returns dictionary with parameter unicode encoded
    data = file_convert(data_dict)
    s = file_get_from_dict(data, ["data", "noEvalReqd"])
    t = str(s)
    file_set_in_dict(data, ["data", "noEvalReqd"], t)
    return data


def file_convert(data):
    if isinstance(data, basestring):
        return data.encode('utf-8')
        # return str(data)
    elif isinstance(data, collections.Mapping):
        return dict(map(file_convert, data.iteritems()))
    elif isinstance(data, collections.Iterable):
        return type(data)(map(file_convert, data))
    else:
        return data.encode('utf-8')


def file_get_from_dict(datadict, map_list):
    return reduce(lambda d, k: d[k], map_list, datadict)


def file_set_in_dict(datadict, map_list, value):
    file_get_from_dict(datadict, map_list[:-1])[map_list[-1]] = value


def get_file_by_notation(obj, ref):
    val = obj
    for key in ref.split('.'):
        val = val[key]
    return val


def file_code(blob):
    v = get_file_by_notation(blob, 'code')
    return str(v)


def file_status(blob):
    v = get_file_by_notation(blob, 'status')
    return str(v)


def file_api(blob):
    v = get_file_by_notation(blob, 'apiversion')
    return str(v)


def file_message(blob):
    v = get_file_by_notation(blob, 'message')
    return str(v)


def file_has_components(blob):
    v = get_file_by_notation(blob, 'data.hasComponents')
    return str(v)


def file_has_evaluation(blob):
    v = get_file_by_notation(blob, 'data.hasEvaluation')
    return str(v)


def file_asset_id(blob):
    test = json.loads(blob)
    v = get_file_by_notation(test, 'data.assetId')
    return str(v)


def file_no_eval_reqd(blob):
    v = get_file_by_notation(blob, 'data.noEvalReqd')
    return str(v)


def file_updated_on(blob):
    v = get_file_by_notation(blob, 'data.updatedOn')
    return str(v)


def file_updated_by(blob):
    v = get_file_by_notation(blob, 'data.updatedBy')
    return str(v)


def file_attributes(blob):
    name = get_file_by_notation(blob, 'data.attributes')
    return str(name)


def file_taxonomy(blob):
    name = get_file_by_notation(blob, 'data.taxonomy')
    return name


def file_hierarchy(blob):
    name = get_file_by_notation(blob, 'data.hierarchy')
    return str(name)


def read_file(obj):
    with open(obj) as data_file:
        data = json.load(data_file)
        return data


def file_phase(blob):
    data_dict = blob['data']
    asset_dict = data_dict['asset'][0]
    attrib_dict = asset_dict['attributes']
    phase_dict = filter(lambda param: param['dataParamName'] == 'phases', attrib_dict)
    return sorted(phase_dict[0].items())


def random_owner_fererence(blob):
    data_dict = blob['data']
    asset_dict = data_dict['asset'][0]
    attrib_dict = asset_dict['taxonomy']
    owner_ref = filter(lambda param: param['dataParamName'] == 'ownerReference_PartySiteID', attrib_dict)

    return sorted(phase_dict[0].items())
