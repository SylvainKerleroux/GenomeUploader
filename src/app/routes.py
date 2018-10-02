from flask import render_template, request, redirect
from werkzeug import secure_filename
from app import app
import os 

@app.route('/')
def upload_file():
	return render_template('upload_form.html')

@app.route('/uploaded', methods = ['POST'])
def uploader_file():
	if request.method == 'POST':
		f = request.files['file']
		f.save(secure_filename(f.filename))
		return redirect('/results')

@app.route('/results')
def return_result():
	dir_path = os.path.dirname(os.path.realpath(__name__))
	file_path = os.path.join(dir_path, 'test_files/output-example.txt')
	if os.path.isfile(file_path):
		f = open(file_path, 'r')
		table = []
		for lines in f.readlines():
			table.append([splits for splits in lines.split('\t') if splits is not ""])
		return render_template('result_table.html', table_header=table[0], table_results=table[1:])
