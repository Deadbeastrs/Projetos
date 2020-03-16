import socket
import time
import random
import datetime
import sys
import json
import csv
import hashlib
from Crypto.PublicKey import RSA
from Crypto.Hash import SHA256
from Crypto.Signature import PKCS1_v1_5



MEGABYTE_SIZE = 8388608

#Lê o ficheiro servers.json e retorna-o como um objecto JSON 
def loadServers():
    with open('servers.json') as f:
        data = json.load(f)
        return data

#Seleciona um servidor tendo em conta o argumento fornecido
def selectServer(arg):
    allServers = loadServers()


    if arg.isalpha():
        targetCountryServers = []
        i = 0

        #Caso o nome do pais inclua espaços como por exemplo: United States
        if(len(sys.argv) > 4):
            for i in range(4, len(sys.argv)):
                arg += " " + sys.argv[i]
            
        #Caso o argumento seja um nome de um país (alphanum)
        for server in allServers["servers"]:
                if server["country"].lower() == arg.lower():
                    targetCountryServers.append(server)
                    i += 1
        
        #Verificar se o array com os possíveis servidores está vazio
        if len(targetCountryServers) == 0:
            print("Erro: Não existe nenhum servidor localizado no país fornecido")
            sys.exit(0)
        else:
            k = random.randint(0,(i - 1)) #Número aleatório para servir como index
            return targetCountryServers[k]["host"].split(":")
    

    #Caso o argumento seja um ID (digit)
    elif arg.isnumeric():
        for server in allServers["servers"]:
                
                if server["id"] == int(arg):
                    return server["host"].split(":")
        
        #Caso não seja encontrado nenhum servidor com um id correspondente
        print("Erro: Não existe nenhum servidor com o id fornecido")
        sys.exit(0)

    else:
        print("Erro: Não foi encontrado nenhum servidor")
        sys.exit(0)

#Faz o teste de ping ao host fornecido
def ping(host, port):
    i = 0
    totalPing = 0
    print("> Tesde de latência iniciado < \n")

    while i < 10:
        #Cria o socket do tipo tcp
        client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        
        #O tempo máximo de espera por ligação ao servidor é 10 segundos
        client.settimeout(10)

        #Tenta a ligação ao servidor, caso falhe uma mensagem é mostrada e o valor de ping é -1
        try:
            client.connect((host,port))

        except socket.error:
            print("Erro: Impossível conectar ao servidor")
            return -1 
         
        #Tempo em milisegundos antes de enviar o comando
        timeBefore = time.time() * 1000

        #Envio do comando para o servidor através de TCP
        client.send(("PING " + str(timeBefore) + "\n").encode("utf-8"))
        
        #Resposta do servidor
        response = client.recv(1024)

        #Tempo em milisegundos depois de receber a resposta do servidor
        timeAfter = time.time() * 1000

        #Fecha a conexão ao servidor
        client.close()

        #Mostra resposta do servidor    
        #print(response)

        #Delta do tempo, dá a latência em milisegundos
        deltaTime = timeAfter - timeBefore

        totalPing += deltaTime
        print("Latência para " + str(host) + " é de " + str(round(deltaTime)) + "ms")
        i += 1
        time.sleep(2)

    print("\n")

    #Retorna o valor médio do ping
    return round(totalPing/10)

#Mostra resposta do servidor ao comando "HI \n"
def hello(host, port):
    #Cria o socket do tipo tcp
    client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    #Tempo máximo de espera por resposta do socket (10 segundos)
    client.settimeout(10)

    #Tenta a ligação ao servidor, caso falhe uma mensagem é mostrada
    try:
        client.connect((host,port))

    except socket.error:
        print("Erro: Impossível conectar ao servidor")

    #Envia o comando para o servidor    
    client.send(("HI\n").encode("utf-8"))

    #Recebe a resposta do servidor
    response = client.recv(4096).decode('utf-8')

    #Mostra a resposta
    print(response)

    #Fecha a conexão com o servidor
    client.close()

#Faz o teste de largura de banda ao host fornecido
def download(host, port):
    #Cria o socket to tipo tcp
    client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    #O tempo máximo de espera por ligação ao servidor é 10 segundos
    client.settimeout(10)

    #Tenta a ligação ao servidor, caso falhe uma mensagem é mostrada e o valor de largura de banda é 0
    try:
        client.connect((host,port))

    except socket.error:
        print("Erro: Impossível conectar ao servidor")
        return 0

    print("> Tesde de download iniciado < \n")      

    #Calcula um tamanho aleatório entre 10 e 100 para o ficheiro (em Mb)
    downloadSize = random.randint(10,100)
    
    #Cria um ficheiro de texto com o nome downloadedFile_[DATATIME ATUAL] (PARA EFEITOS DE TESTE APENAS PARA NAO TER INFLUENCIA NO RESULTADO)
    #f = open("downloadedFile_" + str(time.strftime("%Y%m%d-%H%M%S")) + ".txt", "wb")

    #Envia o comando de download para o servidor
    client.send(("DOWNLOAD " + str(downloadSize * (MEGABYTE_SIZE / 8)) + "\n").encode("utf-8"))
    
    #Timestamp em segundos 
    startDownloadTime = int(time.time())

    totalDownloaded = 0
    
    while 1:
        timeBefore = int(time.time())

        #Resposta do servidor
        response = client.recv(8192)

        #Incrementar ao valor que armazena o total baixado o valor que foi baixado
        totalDownloaded += len(response)
        
        #Se o valor que armazena o total baixado for maior ou igual ao tamanho do arquivo esperado, o download está completo
        if totalDownloaded >= downloadSize * (MEGABYTE_SIZE / 8):

            endDownloadTime = int(time.time())

            #Fecha a conexão com servidor
            client.close()

            #Fecha o arquivo (PARA EFEITOS DE TESTE APENAS PARA NAO TER INFLUENCIA NO RESULTADO)
            #f.close()

            break

        timeAfter = int(time.time())
        deltaTime = int((timeAfter - timeBefore))

        #Caso o servidor não envie resposta ou o tempo passado ultrapassar os 10 segundos, o teste está completo
        if not response or deltaTime >= 10:
            endDownloadTime = int(time.time())

            #Atualiza o valor de download para o que realmente foi baixado
            downloadSize = round(totalDownloaded / (MEGABYTE_SIZE / 8))

            #Fecha a conexão com o servidor
            client.close()

            #Fecha o ficheiro (PARA EFEITOS DE TESTE APENAS PARA NAO TER INFLUENCIA NO RESULTADO)
            #f.close()

            break

        #Escreve a resposta obtida no ficheiro (PARA EFEITOS DE TESTE APENAS PARA NAO TER INFLUENCIA NO RESULTADO)
        #f.write(response)

        #Liberta os dados da memória (PARA EFEITOS DE TESTE APENAS PARA NAO TER INFLUENCIA NO RESULTADO)
        #f.flush()

    #Calcula o tempo de download
    downloadTime = endDownloadTime - startDownloadTime

    print("Velocidade de download -> " + str(downloadSize) + "Mb descarregados em " + str(downloadTime) + "s (" + str(round(float(downloadSize/downloadTime),2)) + "Mb/s)\n")
    return round(float(downloadSize/downloadTime),2)

#Verificar validade dos argumentos
def checkArguments():
    if len(sys.argv) < 4:
        print("Ajuda: python3 client.py interval num [country or id]")
        sys.exit(0)

    if not sys.argv[1].isdigit():
        print("Erro: argumento 'interval' tem um formato incorreto")
        sys.exit(0)

    if not int(sys.argv[1]) > 0:
        print("Erro: argumento 'interval' tem de ser um numero positivo")
        sys.exit(0)

    if not sys.argv[2].isdigit() and int(sys.argv[2]) > 0:
        print("Erro: argumento 'num' tem um formato incorreto")
        sys.exit(0)
        
    if not int(sys.argv[2]) > 0:
        print("Erro: argumento 'num' tem de ser um numero positivo")
        sys.exit(0)

    if not (sys.argv[3].isnumeric() or sys.argv[3].isalpha()):
        print("Erro: argumento 'country or id' tem um formato incorreto")
        sys.exit(0)

#Devolve o ID do host fornecido
def matchHost(host):
    allServers = loadServers()
    for server in allServers["servers"]:

        if server["host"] == str(host):
            return server["id"]


def signReport():
    try:
        privkeyf = open('key.priv.pem', 'r').read()
    except IOError:
        print("O programa não consegue ler a chave privada! Por favor gere uma primeiro com python3 generatekeys.py")
        sys.exit(0)

    privkey = RSA.importKey(privkeyf)
    signer = PKCS1_v1_5.new(privkey)
    unsigned_file = open('report.csv', 'r')
    signed_file = open('report.sig', 'wb')
    line = unsigned_file.readline()

    for line in unsigned_file:
        h = SHA256.new(line.encode('utf-8'))
        signed_line = signer.sign(h)
        signed_file.write(signed_line)
        line = unsigned_file.readline()
    

    

def main():
    checkArguments()
    intervalTests = int (sys.argv[1])
    numTests = int(sys.argv[2])
    
    print("Info: Irão ser iniciados " + str(numTests) + " testes com um intervalo de tempo de " + str(intervalTests) + " segundos entre cada um\n")
    
    #Iniciar o ficheiro para escrita / fazer testes

    try:
        with open('report.csv', mode='w') as csv_file:
                fieldnames = ['counter', 'id', 'date', 'latency', 'bandwidth', 'check']

                #Escrever os cabeçalhos
                writer = csv.DictWriter(csv_file, fieldnames=fieldnames)
                writer.writeheader()

                while True:
                    serverData = selectServer(str(sys.argv[3]))
                    curPing = ping(serverData[0], int(serverData[1]))
                    curDownload = download(serverData[0], int(serverData[1]))

                    numTests -= 1

                    print("Resultados | Ping -> " + str(curPing) + "ms - Download -> " + str(curDownload) + "Mb/s")
                    print("Info: Teste realizado com sucesso, faltam  " + str(numTests) + " para terminar\n")
                    
                    #escrever as linhas
                    writer.writerow({'counter': str(numTests) , 'id': str(matchHost(serverData[0] + ':' + serverData[1])), 'date': str(datetime.datetime.now().isoformat()), 'latency': str(curPing), 'bandwidth': str(curDownload), 'check': str(numTests) + str(matchHost(serverData[0] + ':' + serverData[1])) + str(datetime.datetime.now().isoformat()) + str(curPing) + str(curDownload) })
                    
                    #break ao loop dos testes
                    if numTests == 0 :
                        break

                    time.sleep(intervalTests)
    except IOError:
        print("O programa não consegue escrever no ficheiro report.csv, por favor verifique as permissões de escrita")
        sys.exit(0)

    signReport()
main()
