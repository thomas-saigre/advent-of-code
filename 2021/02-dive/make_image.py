from PIL import Image


def part_I():
    f = open('input.txt', 'r')

    image = Image.new('RGBA', (10000, 10000), (255, 255, 255, 0))

    depth = 0
    position = 0

    image.putpixel((position, depth), (0, 0, 0, 255))

    for line in f:
        old_position, old_depth = position, depth

        if line[0] == 'f':
            position += int(line[-2])
        elif line[0] == 'd':
            depth += int(line[-2])
        elif line[0] == 'u':
            depth -= int(line[-2])

        for x in range(min(old_position, position), max(old_position, position) + 1):
            for y in range(min(old_depth, depth), max(old_depth, depth) + 1):
                image.putpixel((x, y), (0, 0, 255, 128))

        image.putpixel((old_position, old_depth), (0, 0, 0, 255))
        image.putpixel((position, depth), (0, 0, 0, 255))

    image.putpixel((position, depth), (255, 0, 0, 255))

    bbox = image.getbbox()
    if bbox:
        image = image.crop(bbox)
    image.save('partI.png')

def part_II():
    f = open('input.txt', 'r')

    IMG_HEIGHT = 2024
    image = Image.new('RGBA', (2025, 800466), (255, 255, 255, 0))

    depth = 0
    position = 0
    aim = 0

    image.putpixel((position, depth), (0, 0, 0, 255))

    for line in f:

        if line[0] == 'f':
            x = int(line[-2])
            position += x
            depth += aim * x
        elif line[0] == 'd':
            aim += int(line[-2])
        elif line[0] == 'u':
            aim -= int(line[-2])

        print(position, depth)
        image.putpixel((position, depth), (0, 0, 0, 255))

    image.putpixel((position, depth), (255, 0, 0, 255))

    print(depth * position, position, depth)

    # bbox = image.getbbox()
    # if bbox:
    #     image = image.crop(bbox)
    image.save('partII.png')

part_I()
part_II()
