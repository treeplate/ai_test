from pynput.mouse import Button, Controller
mouse = Controller()
click = False
while True:
  try:
    mouse.position = (float(input("X: ")), float(input("Y: ")))
  except EOFError:
    break
  if click:
    mouse.press(Button.left)
  
