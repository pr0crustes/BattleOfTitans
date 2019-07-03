import os
import glob


PP_KEY = "$"
PP_COPY = PP_KEY + "copy "
PP_DEF_PATH = PP_KEY + "path "
PP_FILES = PP_KEY + "files "
PP_RECURSIVE = PP_KEY + "recursive "
PP_ID = PP_KEY + "ID"

PP_FILE_EXT = ".prep"


GLOBAL_ID_COUNTER = 70000


def str_between(string, left="\"", right="\""):
    return string.split(left, 1)[1].split(right, 1)[0]


def replace_id(content):
    global GLOBAL_ID_COUNTER
    while PP_ID in content:
        content = content.replace(PP_ID, str(GLOBAL_ID_COUNTER), 1)
        GLOBAL_ID_COUNTER += 1
    return content


class Processor(object):
    
    def __init__(self, folder):
        self.folder = folder
        self.search_path = ""

    
    def file_content(self, file_name):
        content = open(file_name).read()

        if content.count("{") != content.count("}") or content.count("\"") % 2 != 0:
            print(f"File {file_name} is imbalanced.")
            exit(1)

        if not content.endswith("\n"):
            content += "\n"

        return content


    def folder_file_content(self, folder_path, file_ext, recursive=False):
        if not (folder_path.endswith("\\") or folder_path.endswith("/")):
            folder_path += "/"

        search_path = folder_path
        if recursive:
            search_path += "**/"

        files = glob.glob(f"{self.folder}{search_path}*{file_ext}", recursive=recursive)

        return self.content_of_files(files)


    def content_of_files(self, files):
        return "".join([self.file_content(file) for file in files])


    def parsed_line(self, line):
        striped = line.strip()

        if not striped.startswith(PP_KEY):
            return line

        if striped.startswith(PP_DEF_PATH):
            self.search_path = str_between(line) + "\\"
            return ""

        if striped.startswith(PP_RECURSIVE) or striped.startswith(PP_FILES):
            file_part, ext_part = striped.split(",")
            return self.folder_file_content(str_between(self.folder + file_part), str_between(ext_part), recursive=striped.startswith(PP_RECURSIVE))

        file_name = str_between(striped)
        return self.file_content(file_name)


    def processed_line(self, line):

        return replace_id(self.parsed_line(line))


    def preprocess_file(self, in_file, out_file):
        assert in_file != out_file, "Output file cannot be equal to the input file."

        with open(out_file, "w") as outFile:

            for line in open(in_file, "r"):

                outFile.write(self.processed_line(line))

        print(f"==> Done processing file - {in_file}")


def preprocess_no_ext(fileName, folder=""):
    if folder:
        folder += "/"
    Processor(folder).preprocess_file(f"{folder}{fileName}{PP_FILE_EXT}", f"{folder}{fileName}.txt")


def merge_kvs():
    folder_file_pairs = (
        ("game/scripts/npc", "npc_abilities_custom"),
        ("game/scripts/npc", "npc_heroes_custom"),
        ("game/scripts/npc", "npc_items_custom"),
        ("game/scripts/npc", "npc_units_custom"),
        ("game/resource", "addon_english")
    )


    for folder, file in folder_file_pairs:
        preprocess_no_ext(file, folder)



if __name__ == "__main__":

    merge_kvs()
