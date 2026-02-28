from PIL import Image
import os

def progressive_bottom_grayscale(
    input_path: str,
    output_dir: str,
    step_percent: int = 10
):
    """
    Converts a PNG (with possible transparency) to grayscale progressively
    from the bottom upward. Outputs intermediate images at each step.

    :param input_path: Path to input PNG
    :param output_dir: Directory where output images will be saved
    :param step_percent: Percentage step (default 10)
    """

    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    img = Image.open(input_path).convert("RGBA")
    width, height = img.size
    pixels = img.load()

    # Copy original image so we can progressively modify it
    working_img = img.copy()
    working_pixels = working_img.load()

    # Perceptual luminance conversion (better than simple average)
    def to_grayscale(r, g, b):
        return int(0.299 * r + 0.587 * g + 0.114 * b)

    for percent in range(step_percent, 101, step_percent):
        # Determine how many rows from bottom should be grayscale
        rows_to_convert = int((percent / 100.0) * height)
        start_row = height - rows_to_convert

        for y in range(start_row, height):
            for x in range(width):
                r, g, b, a = pixels[x, y]

                # Preserve fully transparent pixels
                if a == 0:
                    continue

                gray = to_grayscale(r, g, b)
                working_pixels[x, y] = (gray, gray, gray, a)

        output_path = os.path.join(
            output_dir,
            f"grayscale_{percent:03d}.png"
        )
        working_img.save(output_path)
        print(f"Saved: {output_path}")

progressive_bottom_grayscale("inp.png", "stoneGuys")
