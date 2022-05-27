import logging
import os
from pathlib import Path
from shutil import make_archive
from subprocess import run
from time import time


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


def build_dir(dir:Path, req_file:str='requirements-lambda.txt'):
    logging.debug(f"Building {dir.name}")
    start = time()
    if dir.joinpath(req_file).exists():
        logging.debug(f"Installing requirements from {req_file} to {dir.name}")
        command = f"python -m pip install -r {dir.name}/{req_file} --no-cache-dir --upgrade --no-user --target {dir.name}"
        exec(command)
    make_archive(dir.name, 'zip', dir.name)
    tdelta = time() - start
    logging.debug(f"Built {dir.name} in {tdelta:.1f} seconds")


def exec(cmd:str):
    return run(list(cmd.split(' ')), check=True)


if __name__ == '__main__':
    main()