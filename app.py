from flask import Flask, request, url_for, Response
from db import users

app = Flask(__name__)

@app.route("/help/", methods=['GET'])
def commands():
	commands = [
					{'url':'/help/', 'detail':'Metodo GET: retorna a lista de urls suportadas.'},
					{'url':'/users/', 'detail':'Metodo POST: adiciona um usuario. Metodo GET: retorna a lista de usuarios.'},
					{'url':'/users/<id>/', 'detail':'Metodo DELETE: remove o usuário. Metodo PUT: modifica o usuario.'},
					{'url':'/users/verify/', 'detail':'Metodo POST: verifica se a senha e usuario estão corretos.'}
				]
	return Response(response=str(commands), status=200, mimetype="application/json")

@app.route("/users/", methods=['POST', 'GET'])
def users_list():
	if request.method == 'POST':
		form_data = request.json
		user = users.insert(form_data)
		return Response(response="Usuario inserido", status=200, mimetype="application/json")
	elif request.method == 'GET':
		users_list = [dict(u) for u in users.all()]
		users_list = [{'id':u['id'], 'nome':u['nome']} for u in users_list]
		return Response(response=str(users_list), status=200, mimetype="application/json")

@app.route("/users/<int:id>/", methods=['DELETE', 'PUT'])
def user(id):
	if request.method == 'DELETE':
		users.delete(id=id)
		return Response(response="Usuario removido", status=200, mimetype="application/json")
	elif request.method == 'PUT':
		user_db = users.find_one(id=id)
		if user_db['senha'] == request.json['senha']:
			new_user = {'id':user_db['id'], 'nome':user_db['nome'], 'senha':request.json['nova_senha']}
			users.update(new_user, ['id'])
			return Response(response="Senha alterada", status=200, mimetype="application/json")
		else:
			return Response(response="Senha incorreta", status=401, mimetype="application/json")


@app.route("/users/verify/", methods=['POST'])
def user_login():
	login = request.json
	result = users.find_one(nome=login['nome'], senha=login['senha'])
	if result:
		return Response(response="Usuario e senha corretos", status=200, mimetype="application/json")
	return Response(response="Usuario ou senha incorretos", status=401, mimetype="application/json")

app.run(use_reloader=True)