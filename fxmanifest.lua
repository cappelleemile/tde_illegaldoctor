fx_version 'cerulean'
game 'gta5'

author 'TDE Mods'
description 'Illegale Straatdokter Script voor QB-Core'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'config.lua'
}
server_script 'server.lua'
client_script 'client.lua'

lua54 'yes'