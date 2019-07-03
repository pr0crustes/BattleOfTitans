import os
import shutil
import filecmp



class Copier:

    def __init__(self, origin, destiny, exclude_extensions=[], exclude_folders=[]):
        self.origin = origin
        self.destiny = destiny

        self.exclude_extensions = exclude_extensions
        self.exclude_folders = exclude_folders

        self.origin_files = set(self.get_all_files(self.origin, self.origin))
        self.destiny_files = set(self.get_all_files(self.destiny, self.destiny))


    def get_all_files(self, folder, replace=None):
        found_files = []

        for exclude in self.exclude_folders:
            if exclude.replace("\\", "/") in folder.replace("\\", "/"):
                return found_files

        for file in os.listdir(folder):
            path = os.path.join(folder, file)

            if os.path.isdir(path):
                found_files.extend(self.get_all_files(path, replace))
            else:
                replaced = path.replace(replace, "") if replace else path
                found_files.append(replaced)

        return [f for f in found_files if not f.split(".")[-1] in self.exclude_extensions]


    def delete_file(self, folder, file):
        os.remove(os.path.join(folder, file))


    def run(self):
        self.delete_non_existent()
        self.copy_missing()
        self.copy_modified()


    def delete_non_existent(self):
        non_existent = self.destiny_files - self.origin_files

        for file in non_existent:
            # print(f"Will be deleted: {file}")
            self.destiny_files.remove(file)
            self.delete_file(self.destiny, file)


    def copy_missing(self):
        missing = self.origin_files - self.destiny_files

        for file in missing:

            orig = os.path.join(self.origin, file)
            dest = os.path.join(self.destiny, file)

            folders, _, _ = dest.replace("\\", "/").rpartition("/")

            os.makedirs(folders, exist_ok=True)

            shutil.copyfile(orig, dest)


    def copy_modified(self):

        for file in self.origin_files:
            orig = os.path.join(self.origin, file)
            dest = os.path.join(self.destiny, file)

            if os.path.isfile(orig) and os.path.isfile(dest):
                if not filecmp.cmp(orig, dest, shallow=False):
                    shutil.copyfile(orig, dest)
