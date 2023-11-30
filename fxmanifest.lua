fx_version 'cerulean'

game 'gta5'
description 'Advokat'
version '1.10.2'
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

server_scripts {
	'server/*',
    '@oxmysql/lib/MySQL.lua'
}

client_scripts {
    'client/*'
}

