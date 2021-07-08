import string
import re
from random import randint


def taxonomy_id_extract(data):
	result_string = " ".join(str(x) for x in data)
	result = re.findall(r"'(.*?)'", result_string, re.DOTALL)
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