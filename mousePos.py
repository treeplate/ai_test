from pynput import mouse, keyboard
mouseCtrl = mouse.Controller() 
keyCtrl = keyboard.Controller()
while True:
  print(mouseCtrl.position)
