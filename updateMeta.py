import os;
import traceback

try:
	meta = os.open('meta.xml', os.O_WRONLY | os.O_CREAT | os.O_TRUNC);
	header = b'<meta>\n\t<info author="NanoBob" type="script" name="NanoORM" version="1.0" />\n\t<oop>false</oop>\n';
	footer = b'\n\n</meta>';
	folder = '';
	_client = folder + '/client';
	_server = folder + '/server';
	_shared = folder + '/shared';
	_files = folder + '/files';
	os.write(meta, header);

	for (root, dirs, files) in os.walk(_files):
		for file in files:
			path =  os.path.join(root, file).replace('\\', '/');
			path = path[2:];
			os.write(meta, ('\n\t<file src="' + path + '"/>').encode('utf-8'));	
			
	for (root, dirs, files) in os.walk(_shared):
		for file in files:
			path =  os.path.join(root, file).replace('\\', '/');
			path = path[2:];
			os.write(meta, ('\n\t<script src="' + path + '" type="shared"/>').encode('utf-8'));	
	os.write(meta, b'\n');
	for (root, dirs, files) in os.walk(_server):
		for file in files:
			path =  os.path.join(root, file).replace('\\', '/');
			path = path[2:];
			os.write(meta, ('\n\t<script src="' + path + '" type="server"/>').encode('utf-8'));	
	os.write(meta, b'\n');
	for (root, dirs, files) in os.walk(_client):
		for file in files:
			path =  os.path.join(root, file).replace('\\', '/');
			path = path[2:];
			os.write(meta, ('\n\t<script src="' + path + '" type="client"/>').encode('utf-8'));				
	os.write(meta, b'\n');
	
	exports = open('exports.txt')
	exportstring = exports.read()
	for function in exportstring.split():
		os.write(meta, ('\n\t<export function="' + function +'" http="true" />').encode('utf-8'));
	exports.close()
	os.write(meta, b'\n');	
	os.write(meta, footer);
	os.close(meta);
except:
	traceback.print_exc();
	input("Error executing Python Script, press Enter");