import copier


FROM_CONTENT = "D:/Steam/steamapps/common/dota 2 beta/content/dota_addons/battle_of_titans/"
TO_CONTENT = "D:/Development/battle_of_titans/content/"


def update_content():
    copier.Copier(FROM_CONTENT, TO_CONTENT).run()
    print("==> Content folder was updated.")


if __name__ == '__main__':
    update_content()
