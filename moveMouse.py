from pynput.mouse import Button, Controller
mouse = Controller()
click = False
while True:
  mouse.position = (float(input("X: ")), float(input("Y: ")))
  if click:
    mouse.press(Button.left)
  
