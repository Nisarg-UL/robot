from robot.libraries.BuiltIn import BuiltIn
import pymysql
import time


def update_end_date():
	connection = pymysql.connect(host='usnbka403d.global.ul.com', port=3306, user='ul_ipUser', passwd='ul_ipUser', db='infopltfrm_transDBv03')
	cursor = connection.cursor()
	try:
			global taxo_id
			taxo_id = BuiltIn().get_variable_value("${Taxonomy_id}")
			print taxo_id
			if taxo_id == '':
				print ("Taxonomy_id is empty and please check InnoDB Lock for transaction")
			else:
				data = str("UPDATE taxonomy set effective_end_date = now() where taxonomy_id = '" + taxo_id + "'")
				cursor.execute(data)
				time.sleep(3)
				connection.commit()

	except pymysql.Error as e:
		print(e)
		connection.rollback()

	finally:
		cursor.close()
		connection.close()

	return data


def expire_hierarchy_params():
	print 'here'
	connection = pymysql.connect(host='usnbka403d.global.ul.com', port=3306, user='ul_ipUser', passwd='ul_ipUser', db='infopltfrm_transDBv03')
	cursor = connection.cursor()
	try:
			global hierar_id
			hierar_id = BuiltIn().get_variable_value("${Hierarchy_Id}")
			print hierar_id
			if hierar_id == '':
				print ("Hierarchy_id is empty and please check InnoDB Lock for transaction")
			else:
				data = str("update hierarchy_params set effective_end_date = now() where hierarchy_id = '" + hierar_id + "'")
				cursor.execute(data)
				connection.commit()

	except pymysql.Error as e:
		print(e)
		connection.rollback()

	finally:
		cursor.close()
		connection.close()

	return data


def expire_hierarchy():
	connection = pymysql.connect(host='usnbka403d.global.ul.com', port=3306, user='ul_ipUser', passwd='ul_ipUser', db='infopltfrm_transDBv03')
	cursor = connection.cursor()
	try:
			global hierar_id
			hierar_id = BuiltIn().get_variable_value("${Hierarchy_Id}")
			print hierar_id
			if hierar_id == '':
				print ("Hierarchy_id is empty and please check InnoDB Lock for transaction")
			else:
				data = str("update hierarchy set effective_end_date = now() where hierarchy_id = '" + hierar_id + "'")
				cursor.execute(data)
				connection.commit()

	except pymysql.Error as e:
		print(e)
		connection.rollback()

	finally:
		cursor.close()
		connection.close()

	return data


def expire_metadata():
	connection = pymysql.connect(host='usnbka403d.global.ul.com', port=3306, user='ul_ipUser', passwd='ul_ipUser', db='infopltfrm_transDBv03')
	cursor = connection.cursor()
	try:
			global meta_id
			meta_id = BuiltIn().get_variable_value("${Metadata_Id}")
			print meta_id
			if meta_id == '':
				print ("Metadata_Id is empty and please check InnoDB Lock for transaction")
			else:
				data = str("update metadata set effective_end_date = now() where metadata_id = '" + meta_id + "'")
				cursor.execute(data)
				connection.commit()

	except pymysql.Error as e:
		print(e)
		connection.rollback()

	finally:
		cursor.close()
		connection.close()

	return data


def postdate_hierarchy_params():
	connection = pymysql.connect(host='usnbka403d.global.ul.com', port=3306, user='ul_ipUser', passwd='ul_ipUser', db='infopltfrm_transDBv03')
	cursor = connection.cursor()
	try:
			global hierar_id
			hierar_id = BuiltIn().get_variable_value("${Hierarchy_Id}")
			print hierar_id
			if hierar_id == '':
				print ("Hierarchy_id is empty and please check InnoDB Lock for transaction")
			else:
				data = str("update hierarchy_params set effective_end_date = '2999-12-31 11:59:59' where hierarchy_id = '" + hierar_id + "'")
				cursor.execute(data)
				connection.commit()

	except pymysql.Error as e:
		print(e)
		connection.rollback()

	finally:
		cursor.close()
		connection.close()

	return data


def postdate_hierarchy():
	connection = pymysql.connect(host='usnbka403d.global.ul.com', port=3306, user='ul_ipUser', passwd='ul_ipUser', db='infopltfrm_transDBv03')
	cursor = connection.cursor()
	try:
			global hierar_id
			hierar_id = BuiltIn().get_variable_value("${Hierarchy_Id}")
			print hierar_id
			if hierar_id == '':
				print ("Hierarchy_id is empty and please check InnoDB Lock for transaction")
			else:
				data = str("update hierarchy set effective_end_date = '2999-12-31 11:59:59' where hierarchy_id = '" + hierar_id + "'")
				cursor.execute(data)
				connection.commit()

	except pymysql.Error as e:
		print(e)
		connection.rollback()

	finally:
		cursor.close()
		connection.close()

	return data


def postdate_metadata():
	connection = pymysql.connect(host='usnbka403d.global.ul.com', port=3306, user='ul_ipUser', passwd='ul_ipUser', db='infopltfrm_transDBv03')
	cursor = connection.cursor()
	try:
			global meta_id
			meta_id = BuiltIn().get_variable_value("${Metadata_Id}")
			print meta_id
			if meta_id == '':
				print ("Metadata_Id is empty and please check InnoDB Lock for transaction")
			else:
				data = str("update metadata set effective_end_date = '2999-12-31 11:59:59' where metadata_id = '" + meta_id + "'")
				cursor.execute(data)
				connection.commit()

	except pymysql.Error as e:
		print(e)
		connection.rollback()

	finally:
		cursor.close()
		connection.close()

	return data
