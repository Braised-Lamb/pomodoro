from PIL import Image, ImageDraw
import colorsys
import math

def hsl_to_rgb(h, s, l):
    h /= 360.0
    s /= 100.0
    l /= 100.0
    r, g, b = colorsys.hls_to_rgb(h, l, s)
    return int(r * 255), int(g * 255), int(b * 255)

def draw_color_wheel(size, radius):
    img = Image.new('RGBA', (size, size), color=(0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    cx, cy = size // 2, size // 2

    for i in range(1440):
        start_angle = i * (2 * math.pi) / 1440.0
        end_angle = (i + 0.25) * (2 * math.pi) / 1440.0

        for j in range(10000):  # 增加插值点的数量
            angle = start_angle + (end_angle - start_angle) * j / 10000.0
            color = hsl_to_rgb(i/4, 100, 50)

            x = int(cx + radius * math.cos(angle) * j / 10000)
            y = int(cy + radius * math.sin(angle) * j / 10000)
            draw.point((x, y), fill=color)
    img.save("color_wheel.png", format="PNG", pnginfo=img.info)
    img.show()

if __name__ == "__main__":
    canvas_size = 300
    wheel_radius = 150
    draw_color_wheel(canvas_size, wheel_radius)
