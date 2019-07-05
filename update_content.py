import copier


FROM_CONTENT = "D:/Steam/steamapps/common/dota 2 beta/content/dota_addons/battle_of_titans/"
TO_CONTENT = "D:/Development/battle_of_titans/content/"

FROM_COMPILED = "D:/Steam/steamapps/common/dota 2 beta/content/dota_addons/battle_of_titans/"
TO_COMPILED = "D:/Development/battle_of_titans/content/"


def update_content():
    copier.Copier("D:/Steam/steamapps/common/dota 2 beta/content/dota_addons/battle_of_titans/", "D:/Development/battle_of_titans/content/").run()
    print("==> Content folder was updated.")

    copier.Copier("D:/Steam/steamapps/common/dota 2 beta/game/dota_addons/battle_of_titans/maps/", "D:/Development/battle_of_titans/game/maps/").run()
    copier.Copier("D:/Steam/steamapps/common/dota 2 beta/game/dota_addons/battle_of_titans/materials/", "D:/Development/battle_of_titans/game/materials/").run()
    copier.Copier("D:/Steam/steamapps/common/dota 2 beta/game/dota_addons/battle_of_titans/panorama/", "D:/Development/battle_of_titans/game/panorama/").run()
    copier.Copier("D:/Steam/steamapps/common/dota 2 beta/game/dota_addons/battle_of_titans/particles/", "D:/Development/battle_of_titans/game/particles/").run()

    print("==> Compiled files were updated.")


if __name__ == '__main__':
    update_content()
