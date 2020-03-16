
import os.path
import os
from os.path import abspath
import sqlite3 as sql
from PIL import Image
from PIL import ExifTags
from PIL import ImageFile
import cherrypy
import requests
import json
import hashlib
import sepia as sep

# The absolute path to this file's base directory:
baseDir = os.path.dirname(os.path.abspath(__file__))
#Connect to database
ImageFile.LOAD_TRUNCATED_IMAGES = True

db = sql.connect("Datab.db", check_same_thread=False )

# Dict with the this app's configuration:
cherrypy.config.update({'server.socket_port': 10004,})
config = {
  "/":     { "tools.staticdir.on": True,
             "tools.staticdir.root": baseDir,
             'tools.staticdir.dir': baseDir,
             "tools.staticdir.index": 'index.html'},
  "/js":   { "tools.staticdir.on": True,
             "tools.staticdir.dir": "js" },
  "/css":  { "tools.staticdir.on": True,
             "tools.staticdir.dir": "css" },
  "/site": { "tools.staticdir.on": True,
             "tools.staticdir.dir": "site" },
  "/img": { "tools.staticdir.on": True,
             "tools.staticdir.dir": "img" },
}


class Root:

    @cherrypy.expose
    @cherrypy.tools.json_out()
    def sepFunc(self, path) :
        return sep.main(path)

    @cherrypy.expose
    @cherrypy.tools.json_out()
    def greyFunc(self, path) :
        return sep.effect_gray(path)

    @cherrypy.expose
    @cherrypy.tools.json_out()
    def pesquisa(self, input, option) :
        return detectedObjectsToPath(getDetectedObjectsByColor(input, option))

    @cherrypy.expose
    def get(self, id) :
        if getById(id) == "Id não existe" :
            return "Id não existe"
        else :
            return "<img src= " + getById(id) + ">"

    @cherrypy.expose
    def list(self, type, name=None, color=None):
        if type == "names":
            return "<pre>" + getAllNames() + "</pre>"
        elif type == "detected":
            if name == None :
                return "<pre>" + getDetectedObjects() + "</pre>"
            else :
                if color == None :
                    return "<pre>" + getDetectedObjectsByName(name) + "</pre>"
                else :
                    return "<pre>" + getDetectedObjectsByColor(name, color) + "</pre>"

        return "Erro"

    @cherrypy.expose
    def put(self):
       return """
        <html><body>
            <h2>Upload a file</h2>
            <form action="upload" method="post" enctype="multipart/form-data">
            <input type="file" name="ufile" /><br />
            <input type="submit" />
            </form>
        </body></html>
        """

    @cherrypy.expose
    @cherrypy.tools.json_out()
    def detecObjects(self):
       return detectedObjectsToPath(getDetectedObjects())

    @cherrypy.expose
    @cherrypy.tools.json_out()
    def getNames(self):
       return getAllNames()

    @cherrypy.expose
    @cherrypy.tools.json_out()
    def detecObjectsName(self, name):
       return detectedObjectsToPath(getDetectedObjectsByName(name))

    @cherrypy.expose
    def upload(self, ufile):
        upload_file = os.path.normpath(os.path.join("img/", ufile.filename))
        if(len(ufile.filename) != 0) :
            file = open(upload_file, 'wb')
            while True:
                data = ufile.file.read(8192)
                if not data:
                    break
                file.write(data)
            msg = allImageProcessing("img/" + ufile.filename, os.path.splitext(ufile.filename)[0])
        else :
            msg = "Não foi encontrado o ficheiro selecionado"
        return msg + "<script> setTimeout(function(){ window.location.href = 'upload2.html'; }, 3000); </script>";

#Database Interaction Functions

def addToDatabase(nome, objId, imgId, rgb, isObject, acc, objPath ):
    db.execute('INSERT INTO Base (`Nome`, `ObjId`, `ImgId`, `Rgb`, `IsObject`, `Acc`, `ObjPath`) VALUES (?, ?, ?, ?, ?, ?, ?)' , (nome, objId ,imgId , rgb, isObject, acc, objPath))
    db.commit()

def getAllNames():
    result = db.execute("Select Nome From Base WHERE IsObject = 'true' ")
    rows = [rows[0] for rows in result.fetchall()]
    data = {} #cria a variavel para passar para o json
    rows = list(dict.fromkeys(rows)) # Remove os duplicados
    data['Nomes'] = rows
    return json.dumps(data, indent=4, sort_keys=True)

def getDetectedObjects():
    names = db.execute("Select Nome From Base WHERE IsObject = 'true'")
    allNamesRows = [rows[0] for rows in names.fetchall()]
    singleNamerows = list(dict.fromkeys(allNamesRows)) #Remover Duplicados
    data = {}
    for singleNames in singleNamerows: # para cada nome distinto na base de dados
        data[singleNames] = [] # cria lista para os dicinarios de casa objeto
        ids = db.execute("Select ObjId From Base WHERE Nome = ?", (singleNames,)) #Query de Base de dados dos ids dos objetos para cada nome
        for id in ids:#Para casa indice da lista que contem os ids
            imgHash = db.execute("Select ImgId From Base WHERE ObjId = ?", (id)) #Query do ImgId
            acc = db.execute("Select Acc From Base WHERE ObjId = ?", (id)) #Query da Accuracy
            objHash = db.execute("Select ObjId From Base WHERE ObjId = ?", (id)) #Query do ObjId
            idDic = {} #Dicionario de Ids
            idDic["image"] = [rows[0] for rows in objHash.fetchall()][0] #Passa a informacao do imgHash de lista de tuple para string e coloca no dicionario idDic, em image
            idDic["confidence"] = [rows[0] for rows in acc.fetchall()][0]#Passa a informacao do accuracy de lista de tuple para string e coloca no dicionario idDic, em confidence
            idDic["original"] = [row[0] for row in imgHash.fetchall()][0] #(Mesmo que os outros)
            data[singleNames].append(idDic)#Adicionar a lista data

    #return "<pre id='json'>" + json.dumps(data, indent=4, sort_keys=True) + "</pre>" #tags pre para aparecer bonito do html
    return json.dumps(data, indent=4, sort_keys=True)#tags pre para aparecer bonito do html

def getDetectedObjectsByName(name): #mesma cena do getDetecterObjects mas com um if para confirmar o nome
    names = db.execute("Select Nome From Base WHERE IsObject = 'true'")
    allNamesRows = [rows[0] for rows in names.fetchall()]
    singleNamerows = list(dict.fromkeys(allNamesRows))
    data = {}
    for singleNames in singleNamerows:
        if singleNames == name : # Este if
            data[singleNames] = []
            ids = db.execute("Select ObjId From Base WHERE Nome = ?", (singleNames,))
            for id in ids:
                imgHash = db.execute("Select ImgId From Base WHERE ObjId = ?", (id))
                acc = db.execute("Select Acc From Base WHERE ObjId = ?", (id))
                objHash = db.execute("Select ObjId From Base WHERE ObjId = ?", (id))
                idDic = {}
                idDic["image"] = [rows[0] for rows in objHash.fetchall()][0]
                idDic["confidence"] = [rows[0] for rows in acc.fetchall()][0]
                idDic["original"] = [row[0] for row in imgHash.fetchall()][0] # Selecionar o primeiro elemento rows[0] da row de fetchall que passa de tuple para lista e selecionar indice[0]
                data[singleNames].append(idDic)

    return json.dumps(data, indent=4, sort_keys=True)

def getDetectedObjectsByColor(name, color): #mesma cena do getDetecterObjects mas com um if para confirmar o nome
    names = db.execute("Select Nome From Base WHERE IsObject = 'true'")
    allNamesRows = [rows[0] for rows in names.fetchall()]
    singleNamerows = list(dict.fromkeys(allNamesRows))
    data = {}
    for singleNames in singleNamerows:
        if singleNames == name : # Este if
            data[singleNames] = []
            ids = db.execute("Select ObjId From Base WHERE Nome = ? And Rgb = ?", (singleNames,color,))
            for id in ids:
                imgHash = db.execute("Select ImgId From Base WHERE ObjId = ?", (id))
                acc = db.execute("Select Acc From Base WHERE ObjId = ?", (id))
                objHash = db.execute("Select ObjId From Base WHERE ObjId = ?", (id))
                idDic = {}
                idDic["image"] = [rows[0] for rows in objHash.fetchall()][0]
                idDic["confidence"] = [rows[0] for rows in acc.fetchall()][0]
                idDic["original"] = [row[0] for row in imgHash.fetchall()][0] # Selecionar o primeiro elemento rows[0] da row de fetchall que passa de tuple para lista e selecionar indice[0]
                data[singleNames].append(idDic)

    return json.dumps(data, indent=4, sort_keys=True)

def getById(id): #Vai buscar o objPath como id fornecido
    try:
        img = db.execute("Select objPath From Base WHERE ObjId = ?", (id,))
        result = [row[0] for row in img.fetchall()][0]
        #return "<img src='" + result + "'>"
        return json.dumps(result, indent=4, sort_keys=True)
    except:
        result= "Id não existe"
        return result
     #retornamos a imagem, tiramos a lista e o tuple para o caminho direto do ficheiro

def detectedObjectsToPath(json1) :
    dec = json.loads(json1)
    #print(dec)
    for obj in dec :
        for obj1 in dec[obj]:
            obj1["path"] = getById(obj1["image"])
    return json.dumps(dec, indent=4, sort_keys=True)
    #dec["image"]

#Image Processing Funcitons

def allImageProcessing(originalImgPath, imgName):
    info = getImageInfo(originalImgPath)
    if(info == "null" or info == "[]" ) :
        return "Não foi encontrado qualquer objeto"
    try:
        addToDatabase(imgName, imgHasher(originalImgPath), imgHasher(originalImgPath), getRgb(originalImgPath), "false", "null", originalImgPath )
    except:
        return "Imagem já existe no Sistema"
    c = 0
    for obj in info:
        c = c + 1
        name = obj["class"]
        box = obj["box"]
        acc = obj["confidence"]
        pathToObject = "img/" + "Obj_" + str(c) + "_" + name + "_" + imgName
        objName = "Obj_" + str(c) + "_" + name + "_" + imgName
        fixedBox = (int(box["x"]),int(box["y"]),int(box["x1"]),int(box["y1"]))
        imageCutter(fixedBox, originalImgPath,pathToObject, "PNG")
        addToDatabase(name, imgHasher(pathToObject), imgHasher(originalImgPath), getRgb(pathToObject), "true", str(round(acc * 100)), pathToObject )
    return "A imagem foi adicionada com sucesso"

def getImageInfo(path):
    session = requests.Session()
    URL="http://image-dnn-sgh-jpbarraca.ws.atnog.av.it.pt/process"
    with open(path, 'rb') as f:
        file = {'img': f.read()}
        r = session.post(url=URL, files=file, data=dict(thr=0.01))
        if r.status_code == 200:
            imgValues = r.json()
        else:
            imgValues = "null"

    return imgValues

def imageCutter(coords, imgPath, objName, extension):
    image = Image.open(imgPath)
    cropped = image.crop(coords)
    cropped.save(objName, extension)

def imgHasher(imgPath):
    md5_hash = hashlib.md5()
    with open(imgPath,"rb") as f:
        # Read and update hash in chunks of 4K
        for byte_block in iter(lambda: f.read(4096),b""):
            md5_hash.update(byte_block)
        return md5_hash.hexdigest()

def getRgb(imgPath):
    im = Image.open(imgPath)
    width, height = im.size
    r = 0;
    g = 0;
    b = 0;
    for x in range(width):
        for y in range(height):
            p = im.getpixel( (x,y) )
            r = r + p[0]
            g = g + p[1]
            b = b + p[2]
    if(r > g and r > b):
        return "red"
    if(g > r and g > b):
        return "green"
    if(b > r and b > g):
        return "blue"



cherrypy.quickstart(Root(), "/", config)
db.close()
