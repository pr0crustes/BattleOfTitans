from kv_merger import merge_kvs
from setup_files import setup_files


def compile_and_setup():
    merge_kvs()
    setup_files()


if __name__ == '__main__':
    compile_and_setup()
