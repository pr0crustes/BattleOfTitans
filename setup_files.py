import copier


FROM_CONTENT = "D:/Development/battle_of_titans/content/"
TO_CONTENT = "D:/Steam/steamapps/common/dota 2 beta/content/dota_addons/battle_of_titans/"


FROM_GAME = "D:/Development/battle_of_titans/game/"
TO_GAME = "D:/Steam/steamapps/common/dota 2 beta/game/dota_addons/battle_of_titans/"


EXCLUDE_EXTENSIONS = [
    "swp",
    "bak",
    "bin",
    "py",
    "prep"
]


EXCLUDE_FOLDERS = [
    "game/scripts/npc/partials",
    "game/resource/partials"
]


def setup_files():
    copier.Copier(FROM_GAME, TO_GAME, exclude_folders=EXCLUDE_FOLDERS, exclude_extensions=EXCLUDE_EXTENSIONS).run()
    print("==> Copied Game folder.")
    copier.Copier(FROM_CONTENT, TO_CONTENT, exclude_folders=EXCLUDE_FOLDERS, exclude_extensions=EXCLUDE_EXTENSIONS).run()
    print("==> Copied Content folder.")


if __name__ == '__main__':
    setup_files()
