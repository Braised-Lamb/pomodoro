import cv2
from PIL import Image

im = cv2.imread("tomato.jpg", cv2.IMREAD_UNCHANGED)
im = cv2.cvtColor(im, cv2.COLOR_BGR2BGRA, cv2.COLOR_BGR2BGRA)
# 126, 255, 129
for i in range(im.shape[0]):
    for j in range(im.shape[1]):
        if ((im[i][j][0])<50 and (im[i][j][1])<50 and (im[i][j][2])<50):
            # print(im[i][j])
            im[i][j] = [255, 255, 255, 0]

# 将BGR图像转换为RGBA图像
image_rgba = cv2.cvtColor(im, cv2.COLOR_BGRA2RGBA)
# 创建Pillow图像对象
ico_image = Image.fromarray(image_rgba)
# 保存为ico格式的图标
ico_image.save('tomato_icon.png', format="PNG")