from pynput import mouse
import time
mouseCtrl = mouse.Controller()
while True:
  print(mouseCtrl.position)
  time.sleep(1)