from PIL import Image
import sys
import os.path
import os
from os.path import abspath

#def main(fname):
#	im = Image.open(fname)
#
#	for i in [1, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]:
#		im.save(fname+"-test-%i.jpg" % i, quality=i)
#main(sys.argv[1])

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.append(BASE_DIR)

def main(fname):
	im = Image.open(fname)
	width, height = im.size
	new_im = Image.new(im.mode, im.size)
	for x in range(width):
		for y in range(height):
			p = im.getpixel( (x,y) )
			r = 0.189*p[0] + 0.769*p[1] + 0.393*p[2]
			g = 0.168*p[0] + 0.686*p[1] + 0.349*p[2]
			b = 0.131*p[0] + 0.534*p[1] + 0.272*p[2]
			new_im.putpixel((x,y), (int(r), int(g), int(b)) )
	print(fname)
	new_im.save("sepia"+fname, "png")
	return "sepia"+fname

def effect_gray(fname):
	im = Image.open(fname)
	width, height = im.size
	new_im = Image.new("L", im.size)

	for x in range(width):
		for y in range(height):
			p = im.getpixel( (x,y) )
			l = int(p[0]*0.2 + p[1]*0.537 + p[2]*0.144)
			new_im.putpixel( (x,y), (l) )
	print("gray"+fname)
	new_im.save("gray"+fname, "png")
	return "gray"+fname

#effect_gray(sys.argv[1])

def effect_intensity(ims, f):
	im = Image.open(ims)
	new_im = im.convert("YCbCr")
	width, height = im.size
	for x in range(width):
		for y in range(height):
			p= im.getpixel( (x,y) )
			py = p[0]
			pb = min(255,int((p[1] - 128) * f) + 128)
			pr = min(255,int((p[2] - 128) * f) + 128)

	new_im.save(ims)

#effect_intensity(sys.argv[1],10)
