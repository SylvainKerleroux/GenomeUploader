from flask import render_template, request, redirect, url_for
from werkzeug import secure_filename
from app import app
import os 
import subprocess
import uuid

dirname=os.path.dirname
dir_path = dirname(__file__)
R_script_path = os.path.join(dir_path, 'Rscript.R')
database_path = os.path.join(dir_path, 'database')

@app.route('/')
def upload_file():
	return render_template('upload_form.html')

@app.route("/save_file", methods=["GET", "POST"])
def save_file():
	if request.method == "POST":
		f = request.files['file']
		file_id = str(uuid.uuid4())
		f.save(database_path + "/input/{}".format(file_id))
		return redirect(url_for("analyze", file_id=file_id))

@app.route("/analyze/<file_id>")
def analyze(file_id):
	cmd = ['Rscript ' + R_script_path + " " + file_id]
	retcode = subprocess.call(cmd, shell=True)
	print(retcode)
	if (retcode == 0):
		with open(database_path + "/output/{}".format(file_id), "r") as f:
			table = []
			for lines in f.readlines():
				table.append([splits for splits in lines.split('\t') if splits is not ""])
			return render_template('result_table.html', table_header=table[0], table_results=table[1:])
	else:
		return "Something went wrong"