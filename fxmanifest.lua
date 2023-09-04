fx_version 'cerulean'
games { 'gta5' }

author 'fiverr/zak_19'

description 'ATM Scam phone'

version '1.0.0'

shared_scripts 'config.lua'

client_scripts {
    'server/client.lua'
}


server_scripts {
    'server/server.lua'
}

dependency 'es_extended'

