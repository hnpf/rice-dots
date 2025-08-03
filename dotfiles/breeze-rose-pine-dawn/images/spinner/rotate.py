from PIL import Image

open("spinner360.png", "wb+").write(open("spinner0.png", "rb").read())

for deg in range(0, 90, 10):
    img = Image.open("spinner" + str(deg) + ".png")
    img.rotate(-90).save("spinner" + str(deg + 90) + ".png")
    img.rotate(180).save("spinner" + str(deg + 180) + ".png")
    img.rotate(90).save("spinner" + str(deg + 270) + ".png")
