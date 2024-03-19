import cv2

image = cv2.imread("test.bmp", cv2.IMREAD_GRAYSCALE)

# Read Images
# cv2.imshow("Image", image)

print(image.shape)
# cv2.waitKey(0)
# cv2.destroyAllWindows()

full_txt = ""

for e, i in enumerate(image):
    do = "rom_data[{}] <= 1920'b".format(e)
    for j in i:
        if j == 255:
            do += "1"
        else:
            do += "0"
    full_txt += do + ";\n"

with open('rom.txt', 'w+') as f:
    f.write(full_txt)
