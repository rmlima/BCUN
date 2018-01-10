def ok(botao,check,data=None):
	check.set_active(True)
import pygtk
pygtk.require('2.0')
import gtk
import string
import time
def janelaredesenhar(data=None):
	window = gtk.Window(gtk.WINDOW_TOPLEVEL)
	window.set_size_request(520, 290)
	window.set_title('Choose Target Nodes')
	window.set_border_width(10)
	botaook=gtk.Button('OK')
	botaodes=gtk.Button('Uncheck')
	botao0= gtk.CheckButton('0')
	botao1= gtk.CheckButton('1')
	botao2= gtk.CheckButton('2')
	botao3= gtk.CheckButton('3')
	botao4= gtk.CheckButton('4')
	botao5= gtk.CheckButton('5')
	botao6= gtk.CheckButton('6')
	botao7= gtk.CheckButton('7')
	botao8= gtk.CheckButton('8')
	botao9= gtk.CheckButton('9')
	checkok= gtk.CheckButton('')
	checkdes= gtk.CheckButton('')
	fixo = gtk.Fixed()
	caixav = gtk.VBox()
	caixav.pack_start(fixo, expand=False, fill=True)
	botaook.connect('clicked',ok,checkok)
	botaodes.connect('clicked',ok,checkdes)
	botao4.set_sensitive(False)
	botao9.set_active(True)
	fixo.put(botao0,20,20)
	fixo.put(botao1,20,40)
	fixo.put(botao2,20,60)
	fixo.put(botao3,20,80)
	fixo.put(botao4,20,100)
	fixo.put(botao5,20,120)
	fixo.put(botao6,20,140)
	fixo.put(botao7,20,160)
	fixo.put(botao8,20,180)
	fixo.put(botao9,20,200)
	fixo.put(botaook,20,230)
	fixo.put(botaodes,70,230)
	window.add(caixav)
	window.show_all()
	while checkok.get_active()==False:
		checkok.set_active(False)
		while gtk.events_pending():
			gtk.main_iteration(False)
		time.sleep(0.1)
		vector=[]
		if checkdes.get_active()==True:
			checkdes.set_active(False)
			botao0.set_active(False)
			botao1.set_active(False)
			botao2.set_active(False)
			botao3.set_active(False)
			botao4.set_active(False)
			botao5.set_active(False)
			botao6.set_active(False)
			botao7.set_active(False)
			botao8.set_active(False)
			botao9.set_active(False)
		if checkok.get_active()==True:
			if botao0.get_active()==True:
				vector.append(0)
			if botao1.get_active()==True:
				vector.append(1)
			if botao2.get_active()==True:
				vector.append(2)
			if botao3.get_active()==True:
				vector.append(3)
			if botao4.get_active()==True:
				vector.append(4)
			if botao5.get_active()==True:
				vector.append(5)
			if botao6.get_active()==True:
				vector.append(6)
			if botao7.get_active()==True:
				vector.append(7)
			if botao8.get_active()==True:
				vector.append(8)
			if botao9.get_active()==True:
				vector.append(9)
			print 'Acabou'
	checkok.set_active(False)
	print vector
	window.destroy()
	return vector
