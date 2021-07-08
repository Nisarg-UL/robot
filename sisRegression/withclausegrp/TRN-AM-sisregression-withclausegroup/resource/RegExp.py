import string
import re
from random import randint
import json


def extract_value(data):
	result_string = " ".join(str(x) for x in data)
	print result_string
	result = re.findall(r"'(.*?)'", result_string, re.DOTALL)
	print result
	return ', '.join(result)


def asset_state(blob):
	blob_string = str(blob)
	blob_list = re.findall(r"'(.*?)'", blob_string)
	if blob_list == ['scratchpad', 'associated', 'immutable']:
	#asset is in immutable state
		state = 'immutable'
	elif blob_list == ['associated', 'immutable', 'scratchpad']:
	#asset is in immutable state
		state = 'immutable'
	elif blob_list == ['associated', 'scratchpad', 'immutable']:
	#asset is in immutable state
		state = 'immutable'
	elif blob_list == ['scratchpad', 'immutable', 'associated']:
	#asset is in immutable state
		state = 'immutable'
	elif blob_list == ['immutable', 'associated', 'scratchpad' ]:
	#asset is in immutable state
		state = 'immutable'
	elif blob_list == ['immutable', 'scratchpad', 'associated']:
	#asset is in immutable state
		state = 'immutable'
	elif blob_list == ['scratchpad', 'associated']:
	#asset is in aassociated state
		state = 'associated'
	elif blob_list == ['associated', 'scratchpad']:
	#asset is in aassociated state
		state = 'associated'
	elif blob_list == ['scratchpad']:
	#assset is in scratchpad state
		state = 'scratchpad'
	elif blob_list == ['associated']:
	#assset is in scratchpad state
		state = 'associated'
	elif blob_list == ['immutable']:
	#assset is in scratchpad state
		state = 'immutable'
	else:
		state = 'state could not be determined'
	return state


def ass_mnt_cls_id_regex(blob):
	blob_string = str(blob)
	blob_list = re.findall(r"(?<=')[^']+(?=')", blob_string)
	return 	blob_list[0]


def extract_decimal(data):
	result_string = " ".join(str(x) for x in data)
	print result_string
	result = re.findall('\d+\.[0-9]', result_string, re.DOTALL)
	print result
	return ', '.join(result)


def extract_shared_attributes(data):
	blob_string = str(data)
	blob_list = re.findall('Shared Attribute \d+', blob_string)
	return json.dumps(blob_list)