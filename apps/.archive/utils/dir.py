import os


def get_location_dir_from(path):
    abs_path = os.path.realpath(path)
    return os.path.dirname(abs_path)
