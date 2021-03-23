from pynput.mouse import Button, Controller
mouse = Controller()
while True:
  mouse.position = (float(input("X: ")), float(input("Y: ")))
  
