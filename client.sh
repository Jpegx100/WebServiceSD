#!/bin/bash

# To execute this file we have to tap on terminal "chmod 755 client.sh" and so "./client.sh <command>"

# Root url for the project
ROOT_URL="http://localhost:5000/users/"

if [ "$1" == "" ]; then
	echo "use parametro 'help' se precisar de ajuda"
elif [ "$1" == "help" ]; then
	echo "list			retorna a lista dos usuarios cadastrados"
	echo "add			adiciona um usuario e deve ser seguido de nome e senha do usuario cadastra o mesmo"
	echo "delete			deleta um usuario e deve ser seguido do id do usuario a ser deletado"
	echo "pass 			modifica a senha de um usuario e deve ser seguido do id, antiga senha e nova senha do usuario"
	echo "verify			verifica se a senha e o usuario casam corretamente e deve ser seguido por um usuario e senha"

elif [ "$1" == "add" ]; then
	if [ "$2" != "" ] && [ "$3" != "" ]; then
		# Json must be in formate {"nome":"value", "senha":"value"}
		curl -H "Content-Type: application/json" -X POST -d '{"nome":"'$2'", "senha":"'$3'"}' $ROOT_URL
	else
		echo "nome e senha devem ser passados"
	fi

elif [ "$1" == "pass" ]; then
	if [ "$2" != "" ] && [ "$3" != "" ] && [ "$4" != "" ]; then
		# Json passed must be in format {"senha":"value", "nova_senha":"value"} and the url must be finished whit the user id
		curl -H "Content-Type: application/json" -X PUT -d '{"senha":"'$3'", "nova_senha":"'$4'"}' $ROOT_URL$2/
	else
		echo "identificador, senha atual e nova senha devem ser passados"
	fi

elif [ "$1" == "verify" ]; then
	if [ "$2" != "" ] && [ "$3" != "" ]; then
		# Json must be in formate {"nome":"value", "senha":"value"}
		curl -H "Content-Type: application/json" -X POST -d '{"nome":"'$2'", "senha":"'$3'"}' $ROOT_URL'verify/'
	else
		echo "usuario e senha devem ser passados"
	fi

elif [ "$1" == "list" ]; then
	curl $ROOT_URL
	echo ""

elif [ "$1" == "delete" ]; then
	if [ "$2" != "" ]; then
		# Url must be like http://root/{user_id}
		curl -X DELETE $ROOT_URL$2/
	else
		echo "identificador do usuario a ser deletado deve serpassado"
	fi
fi
