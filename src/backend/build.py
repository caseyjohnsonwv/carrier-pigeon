import logging
import os
from pathlib import Path
import shutil
from subprocess import run
from time import time


logging.basicConfig(
    format='%(asctime)s - %(levelname)s - %(message)s',
    level=logging.DEBUG,
)
logger = logging.getLogger()


def main():
    logger.info("Initiating build sequence")
    start = time()
    c = 0
    for dir in Path(os.getcwd()).iterdir():
        if dir.is_dir():
            build_dir(dir)
            c += 1
    tdelta = time() - start
    logger.info(f"Built {c} Lambdas in {tdelta:.1f} seconds")


def build_dir(dir:Path, req_file:str='requirements-lambda.txt'):
    logger.info(f"Building {dir.name}")
    start = time()
    # create temp dir
    temp_dir = Path(os.getcwd()).joinpath(f"{dir.name}_build")
    shutil.rmtree(temp_dir, ignore_errors=True)
    os.mkdir(temp_dir)
    # install linux requirements
    if dir.joinpath(req_file).exists():
        logger.debug(f"Installing requirements from {dir.name}/{req_file} to {temp_dir}")
        command = f"python -m pip install -r {dir.name}/{req_file} --no-cache-dir --upgrade --no-user --platform linux_x86_64 --only-binary=:all: --target {temp_dir}"
        exec(command)
    # copy source code to temp dir, omitting .gitignore'd files
    files = ' '.join([f"{dir.name}/{f.name}" for f in dir.iterdir()])
    command = f"git check-ignore {files}"
    res = exec(command)
    excludes = set(p.split('/')[-1] for p in res.stdout.decode('utf-8').split('\n') if len(p) > 0)
    logger.debug(f"Excluding {len(excludes)} .gitignore'd files")
    if len(excludes) > 0:
         logger.debug(', '.join(excludes))
    for f in dir.iterdir():
        if f.name not in excludes:
            src = f"{dir.name}/{f.name}"
            dest = f"{temp_dir.name}/{f.name}"
            shutil.copyfile(src, dest)
    # zip and delete temp dir
    shutil.make_archive(dir.name, 'zip', temp_dir.name)
    shutil.rmtree(temp_dir)
    tdelta = time() - start
    logger.info(f"Built {dir.name} in {tdelta:.1f} seconds")


def exec(cmd:str):
    return run(list(cmd.split(' ')), capture_output=True)


if __name__ == '__main__':
    main()