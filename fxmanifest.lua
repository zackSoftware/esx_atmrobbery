fx_version 'cerulean'
games { 'gta5' }

author 'fiverr/zak_19'

description 'ATM Scam phone'

version '1.0.0'

shared_scripts {
    'locales/en.lua'
    'config.lua'
}

client_scripts {
    '@es_extended/locale.lua',
    'server/client.lua'
}


server_scripts {
    '@mysql-async/lib/MySQL.lua'
    '@es_extended/locale.lua',
    'server/server.lua'
}


dependency 'es_extended'
dependency 'zd-minigame'
dependency 'mythic_notify'


lua54 'yes'

