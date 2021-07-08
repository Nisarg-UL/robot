import json
import time
from robot.libraries.BuiltIn import BuiltIn
import FileExtractor
from random import randint
import datetime


def get_from_dict(datadict, map_list):
	return reduce(lambda d, k: d[k], map_list, datadict)


def set_in_dict(datadict, map_list, value):
	get_from_dict(datadict, map_list[:-1])[map_list[-1]] = value


def get_by_notation(obj, ref):
	val = obj
	for key in ref.split('.'):
		val = val[key]
	return val


def extract_and_replace_product_and_component_asset_id(blob):
	data = json.loads(blob)
	data_dict_unicode = FileExtractor.file_convert(data)
	data_dict = data_dict_unicode['data']
	global asset_Id_Motor
	asset_Id_Motor = BuiltIn().get_variable_value("${asset_Id_Motor}")
	global asset_Id_IS
	asset_Id_IS = BuiltIn().get_variable_value("${asset_Id_IS}")
	for name, data_list in data_dict.iteritems():
		for data_dict1 in data_list:
			for key, value in data_dict1.items():
				if value == "0dd65994-aede-11e5-a5c3-2c44fd10ed09":
					data_dict1[key] = asset_Id_Motor

	asset_list = data_dict['asset'][0]
	asset_dict = asset_list['hasComponents'][0]

	for key, value in asset_dict.items():
		if value == "38c899a6-aee2-11e5-a5c3-2c44fd10ed09":
			asset_dict[key] = asset_Id_IS

	return json.dumps({"data":data_dict})


def extract_and_replace_asset_id(blob):
	data = json.loads(blob)
	data_dict_unicode = FileExtractor.file_convert(data)
	data_dict = data_dict_unicode['data']
	global asset_Id_Motor
	asset_Id_Motor = BuiltIn().get_variable_value("${asset_Id_Motor}")
	for name, data_list in data_dict.iteritems():
		for data_dict1 in data_list:
			for key, value in data_dict1.items():
				if value == "0dd65994-aede-11e5-a5c3-2c44fd10ed09":
					data_dict1[key] = asset_Id_Motor

	return json.dumps({"data": data_dict})


# (Below function used in associatecontent.robot test)
def extract_and_replace_asset_link_seq_id(blob):
	data = json.loads(blob)
	data_dict_unicode = FileExtractor.file_convert(data)
	data_dict = data_dict_unicode['data']
	global Asset_Link_Seq_Id
	Asset_Link_Seq_Id = BuiltIn().get_variable_value("${Asset_Link_Sed_Id}")
	global asset_Id_IS
	asset_Id_IS = BuiltIn().get_variable_value("${asset_Id_IS}")
	global asset_Id_Motor
	asset_Id_Motor = BuiltIn().get_variable_value("${asset_Id_Motor}")
	global asset_Id_IS1
	asset_Id_IS1 = BuiltIn().get_variable_value("${asset_Id_IS1}")
	for name, data_list in data_dict.iteritems():
		for data_dict1 in data_list:
			for key, value in data_dict1.items():
				if value == "0dd65994-aede-11e5-a5c3-2c44fd10ed09":
					data_dict1[key] = asset_Id_Motor
	asset_list = data_dict['asset'][0]
	has_component_dict = asset_list['hasComponents'][0]
	for key, value in has_component_dict.items():
		if value == "38c899a6-aee2-11e5-a5c3-2c44fd10ed09":
			has_component_dict[key] = asset_Id_IS1
		if value == "880":
			has_component_dict[key] = ""
	is_alternate_of_dict = has_component_dict['isAlternateOf'][0]
	for key, value in is_alternate_of_dict.items():
		if value == "880":
			is_alternate_of_dict[key] = Asset_Link_Seq_Id
		if value == "38c899a6-aee2-11e5-a5c3-2c44fd10ed09":
			is_alternate_of_dict[key] = asset_Id_IS

	return json.dumps({"data":data_dict})


# (Below function used in linkinfourcomponenttoproduct.robot test)
def replace_product_and_four_component_asset_id(blob):
	data = json.loads(blob)
	data_dict_unicode = FileExtractor.file_convert(data)
	data_dict = data_dict_unicode['data']
	global asset_Id_IS
	asset_Id_IS = BuiltIn().get_variable_value("${asset_Id_IS}")
	global asset_Id_Motor
	asset_Id_Motor = BuiltIn().get_variable_value("${asset_Id_Motor}")
	global asset_Id_IS1
	asset_Id_IS1 = BuiltIn().get_variable_value("${asset_Id_IS1}")
	global asset_Id_Motor_Protector1
	asset_Id_Motor_Protector1 = BuiltIn().get_variable_value("${asset_Id_Motor_Protector1}")
	global asset_Id_Motor_Protector2
	asset_Id_Motor_Protector2 = BuiltIn().get_variable_value("${asset_Id_Motor_Protector2}")
	for name, data_list in data_dict.iteritems():
		for data_dict1 in data_list:
			for key, value in data_dict1.items():
				if value == "0dd65994-aede-11e5-a5c3-2c44fd10ed09":
					data_dict1[key] = asset_Id_Motor
	asset_list = data_dict['asset'][0]
	has_component_dict = asset_list['hasComponents'][0]
	for key, value in has_component_dict.items():
		if value == "38c899a6-aee2-11e5-a5c3-2c44fd10ed09":
			has_component_dict[key] = asset_Id_IS
	has_component_dict = asset_list['hasComponents'][1]
	for key, value in has_component_dict.items():
		if value == "38c899a6-aee2-11e5-a5c3-2c44fd10ed09":
			has_component_dict[key] = asset_Id_Motor_Protector1
	has_component_dict = asset_list['hasComponents'][2]
	for key, value in has_component_dict.items():
		if value == "38c899a6-aee2-11e5-a5c3-2c44fd10ed09":
			has_component_dict[key] = asset_Id_IS1
	has_component_dict = asset_list['hasComponents'][3]
	for key, value in has_component_dict.items():
		if value == "38c899a6-aee2-11e5-a5c3-2c44fd10ed09":
			has_component_dict[key] = asset_Id_Motor_Protector2

	return json.dumps({"data":data_dict})


def extract_and_replace_random_owner_ref(blob):
	data = json.loads(blob)
	data_dict_unicode = FileExtractor.file_convert(data)
	data_dict = data_dict_unicode['data']
	global party_Id
	party_Id = randint(1000000, 9999999)
	asset_list = data_dict['asset'][0]
	taxo_dict = asset_list['taxonomy'][1]
	for key, value in taxo_dict.items():
		if value == "Replace Owner":
			taxo_dict[key] = party_Id
	attrib_dict = asset_list['attributes'][1]
	for key, value in attrib_dict.items():
		if value == "Replace Owner":
			attrib_dict[key] = party_Id
	return json.dumps({"data": data_dict})


def extract_and_replace_random_project_no(blob):
	data = json.loads(blob)
	data_dict = data['data']
	global project_no
	project_no = randint(100000000, 99999999999)
	asset_list = data_dict['asset'][0]
	collect_dict = asset_list['collectionAttributes'][1]
	for key, value in collect_dict.items():
		if value == "Replace Project":
			collect_dict[key] = project_no
	attrib_dict = asset_list['attributes'][7]
	for key, value in attrib_dict.items():
		if value == "Replace Project":
			attrib_dict[key] = project_no
	return json.dumps({"data": data_dict})


def extract_and_replace_random_quote_no(blob):
	data = json.loads(blob)
	data_dict = data['data']
	global quote_no
	quote_no = randint(10000000000, 99999999999)
	asset_list = data_dict['asset'][0]
	collect_dict = asset_list['collectionAttributes'][2]
	for key, value in collect_dict.items():
		if value == "Replace Quote":
			collect_dict[key] = quote_no
	attrib_dict = asset_list['attributes'][8]
	for key, value in attrib_dict.items():
		if value == "Replace Quote":
			attrib_dict[key] = quote_no
	return json.dumps({"data": data_dict})


def extract_and_replace_random_order_no(blob):
	data = json.loads(blob)
	data_dict = data['data']
	global order_no
	order_no = randint(100000000, 999999999)
	asset_list = data_dict['asset'][0]
	collect_dict = asset_list['collectionAttributes'][3]
	for key, value in collect_dict.items():
		if value == "Replace Order":
			collect_dict[key] = order_no
	attrib_dict = asset_list['attributes'][9]
	for key, value in attrib_dict.items():
		if value == "Replace Order":
			attrib_dict[key] = order_no
	return json.dumps({"data": data_dict})


def extract_and_replace_date(blob):
	data = json.loads(blob)
	data_dict = data['data']
	global Today_Date
	Today_Date = time.strftime('%Y-%m-%d')
	asset_list = data_dict['asset'][0]
	taxo_dict = asset_list['taxonomy'][5]
	for key, value in taxo_dict.items():
		if value == "Replace Date":
			taxo_dict[key] = Today_Date
	attrib_dict = asset_list['attributes'][5]
	for key, value in attrib_dict.items():
		if value == "Replace Date":
			attrib_dict[key] = Today_Date
	return json.dumps({"data": data_dict})


def extract_and_replace_date_for_certificate_scheme(blob):
	data = json.loads(blob)
	data_dict = data['data']
	global Today_Date
	Today_Date = time.strftime('%Y-%m-%d')
	cert_list = data_dict['certificate'][0]
	attrib_list = cert_list['attributes']
	for attrib_dict in attrib_list:
		for key, value in attrib_dict.items():
			if value == "Replace Date":
				attrib_dict[key] = Today_Date
	return json.dumps({"data": data_dict})


def extract_and_replace_edited_owner_ref(blob):
	data = json.loads(blob)
	data_dict_unicode = FileExtractor.file_convert(data)
	data_dict = data_dict_unicode['data']
	global party_Id
	party_Id = BuiltIn().get_variable_value("${Asset_Owner_Ref}")
	asset_list = data_dict['asset'][0]
	taxo_dict = asset_list['taxonomy'][1]
	for key, value in taxo_dict.items():
		if value == "20004":
			taxo_dict[key] = party_Id
		attrib_dict = asset_list['attributes'][1]
		for key, value in attrib_dict.items():
			if value == "20004":
				attrib_dict[key] = party_Id
	return json.dumps({"data": data_dict})


def present_date():
	global present_date
	present_date = time.strftime('%Y-%m-%d')
	return present_date


def extract_and_replace_issue_date_for_edit_private_label(blob):
	data = json.loads(blob)
	data_dict = data['data']
	global Today_Date
	Today_Date = time.strftime('%Y-%m-%d')
	for key, value in data_dict.items():
		if value == "Replace Date":
			data_dict[key] = Today_Date
	return json.dumps({"data": data_dict})


def extract_and_replace_date_for_pl_add_asset(blob):
	data = json.loads(blob)
	data_dict = data['data']
	global Today_Date
	Today_Date = time.strftime('%Y-%m-%d')
	asset_list = data_dict['assets'][0]
	taxo_dict = asset_list['taxonomy'][5]
	for key, value in taxo_dict.items():
		if value == "Replace Date":
			taxo_dict[key] = Today_Date
	return json.dumps({"data": data_dict})


# def extract_and_replace_issue_date_for_private_label_scheme(blob):
# 	data = json.loads(blob)
# 	global Today_Date
# 	Today_Date = time.strftime('%Y-%m-%d')
# 	pl_dict = data['privateLabel'][0]
# 	for key, value in pl_dict.items():
# 		if value == "Replace Date":
# 			pl_dict[key] = Today_Date
# 	attrib_dict = pl_dict['hasCertify'][0]['attributes'][0]
# 	for key, value in attrib_dict.items():
# 		if value == "Replace Date":
# 			attrib_dict[key] = Today_Date
# 	return json.dumps({"privateLabel":[pl_dict]})
# 	# return attrib_dict


def extract_and_replace_issue_date_and_withdrawal_date_and_expiry_date_for_private_label_scheme(blob):
	data = json.loads(blob)
	global Today_Date
	global Past_Date
	global Future_Date
	Today_Date = time.strftime('%Y-%m-%d')
	Past_Date = '2000-01-01'
	Future_Date = '2999-12-31'
	pl_dict = data['privateLabel'][0]
	for key, value in pl_dict.items():
		if value == "Replace Date":
			pl_dict[key] = Today_Date
	for key, value in pl_dict.items():
		if value == "Replace Past Date":
			pl_dict[key] = Past_Date
	for key, value in pl_dict.items():
		if value == "Replace Future Date":
			pl_dict[key] = Future_Date
	attrib_dict = pl_dict['hasCertify'][0]['attributes'][0]
	for key, value in attrib_dict.items():
		if value == "Replace Date":
			attrib_dict[key] = Today_Date
	for key, value in attrib_dict.items():
		if value == "Replace Past Date":
			attrib_dict[key] = Past_Date
	for key, value in attrib_dict.items():
		if value == "Replace Future Date":
			attrib_dict[key] = Future_Date
	attrib_dict1 = pl_dict['hasCertify'][0]['attributes'][1]
	for key, value in attrib_dict1.items():
		if value == "Replace Date":
			attrib_dict1[key] = Today_Date
	for key, value in attrib_dict1.items():
		if value == "Replace Past Date":
			attrib_dict1[key] = Past_Date
	for key, value in attrib_dict1.items():
		if value == "Replace Future Date":
			attrib_dict1[key] = Future_Date
	attrib_dict2 = pl_dict['hasCertify'][0]['attributes'][2]
	for key, value in attrib_dict2.items():
		if value == "Replace Date":
			attrib_dict2[key] = Today_Date
	for key, value in attrib_dict2.items():
		if value == "Replace Past Date":
			attrib_dict2[key] = Past_Date
	for key, value in attrib_dict2.items():
		if value == "Replace Future Date":
			attrib_dict2[key] = Future_Date
	attrib_dict3 = pl_dict['hasCertify'][0]['attributes'][3]
	for key, value in attrib_dict3.items():
		if value == "Replace Date":
			attrib_dict3[key] = Today_Date
	for key, value in attrib_dict3.items():
		if value == "Replace Past Date":
			attrib_dict3[key] = Past_Date
	for key, value in attrib_dict3.items():
		if value == "Replace Future Date":
			attrib_dict3[key] = Future_Date
	return json.dumps({"privateLabel":[pl_dict]})
	# return attrib_dict


def extract_and_replace_issue_date_and_withdrawal_date_and_expiry_date_for_certificate(blob):
	data = json.loads(blob)
	data_dict = data['data']
	global Today_Date
	global Past_Date
	global Future_Date
	Today_Date = time.strftime('%Y-%m-%d')
	Past_Date = '2000-01-01'
	Future_Date = '2999-12-31'
	certificate_dict = data_dict['certificate'][0]
	for key, value in certificate_dict.items():
		if value == "Replace Date":
			certificate_dict[key] = Today_Date
	for key, value in certificate_dict.items():
		if value == "Replace Past Date":
			certificate_dict[key] = Past_Date
	for key, value in certificate_dict.items():
		if value == "Replace Future Date":
			certificate_dict[key] = Future_Date
	cert_list = data_dict['certificate'][0]['hasCertify'][0]
	attrib_dict = cert_list['attributes'][0]
	for key, value in attrib_dict.items():
		if value == "Replace Date":
			attrib_dict[key] = Today_Date
	for key, value in attrib_dict.items():
		if value == "Replace Past Date":
			attrib_dict[key] = Past_Date
	for key, value in attrib_dict.items():
		if value == "Replace Future Date":
			attrib_dict[key] = Future_Date
	attrib_dict1 = cert_list['attributes'][1]
	for key, value in attrib_dict1.items():
		if value == "Replace Date":
			attrib_dict1[key] = Today_Date
	for key, value in attrib_dict1.items():
		if value == "Replace Past Date":
			attrib_dict1[key] = Past_Date
	for key, value in attrib_dict1.items():
		if value == "Replace Future Date":
			attrib_dict1[key] = Future_Date
	attrib_dict2 = cert_list['attributes'][2]
	for key, value in attrib_dict2.items():
		if value == "Replace Date":
			attrib_dict2[key] = Today_Date
	for key, value in attrib_dict2.items():
		if value == "Replace Past Date":
			attrib_dict2[key] = Past_Date
	for key, value in attrib_dict2.items():
		if value == "Replace Future Date":
			attrib_dict2[key] = Future_Date
	attrib_dict3 = cert_list['attributes'][3]
	for key, value in attrib_dict3.items():
		if value == "Replace Date":
			attrib_dict3[key] = Today_Date
	for key, value in attrib_dict3.items():
		if value == "Replace Past Date":
			attrib_dict3[key] = Past_Date
	for key, value in attrib_dict3.items():
		if value == "Replace Future Date":
			attrib_dict3[key] = Future_Date
	return json.dumps({"data": data_dict})


def extract_and_replace_random_owner_ref_for_certificate(blob):
	data = json.loads(blob)
	data_dict_unicode = FileExtractor.file_convert(data)
	data_dict = data_dict_unicode['data']
	global party_Id
	party_Id = randint(100000, 999999)
	cert_list = data_dict['certificate'][0]
	for key, value in cert_list.items():
		if value == "Replace Owner":
			cert_list[key] = party_Id
	attrib_dict = cert_list['attributes'][4]
	for key, value in attrib_dict.items():
		if value == "Replace Owner":
			attrib_dict[key] = party_Id
	return json.dumps({"data": data_dict})


def extract_and_replace_random_owner_ref_for_private_label(blob):
	data = json.loads(blob)
	data_dict_unicode = FileExtractor.file_convert(data)
	data_dict = data_dict_unicode['data']
	global party_Id
	party_Id = randint(100000, 999999)
	cert_list = data_dict['baseCertificate']
	for key, value in cert_list.items():
		if value == "Replace Owner":
			cert_list[key] = party_Id
	attrib_dict = data_dict['attributes'][4]
	for key, value in attrib_dict.items():
		if value == "Replace Owner":
			attrib_dict[key] = party_Id
	return json.dumps({"data": data_dict})


def today_date():
	Today_Date = datetime.date.today()
	# Today_Date = time.strftime('%Y-%m-%d')
	return Today_Date


def yesterday_date():
	Today_Date = datetime.date.today()
	Yesterday_Date = Today_Date - datetime.timedelta(days = 1)
	return Yesterday_Date


def tomorrow_date():
	Today_Date = datetime.date.today()
	Tomorrow_Date = Today_Date + datetime.timedelta(days = 1)
	return Tomorrow_Date


def current_time():
	time = datetime.datetime.now()
	Current_Time = time.strftime('%Y-%m-%d-%H:%M:%S')
#	Current_Time = time.strftime('%Y-%m-%d-%H:%M')
	return Current_Time


# def current_time():
# 	time = datetime.datetime.now()
# 	Current_Time = time.strftime('%Y-%m-%dT%H:%M:%S.%f')[:-3]
# 	return Current_Time+'Z'


def random_number():
	global random_number
	random_number = randint(100000, 999999)
	return random_number