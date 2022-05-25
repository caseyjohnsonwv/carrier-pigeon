import logging
import os
from pathlib import Path
from time import time
from zipfile import ZipFile


logging.basicConfig(
    format='%(asctime)s - %(levelname)s - %(message)s',
    level=logging.INFO,
)


def main():
    start = time()
    c = 0
    for dir in Path(os.getcwd()).iterdir():
        if dir.is_dir():
            build_dir(dir)
            c += 1
    tdelta = time() - start
    logging.info(f"Built {c} Lambdas in {tdelta:.1f} seconds")


def build_dir(dir:Path):
    logging.debug(f"Building {dir.name}")
    start = time()
    with ZipFile(f"{dir.name}.zip", 'w') as z:
        for f in dir.iterdir():
            z.write(f, arcname=f.name)
    tdelta = time() - start
    logging.debug(f"Built {dir.name} in {tdelta:.1f} seconds")


if __name__ == '__main__':
    main()