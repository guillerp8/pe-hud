fx_version 'cerulean'

game { 'gta5' }

lua54 'yes'

version '1.0.0'

description 'Standalone hud created by Project Entity'

client_scripts {
	'config/config_cl.lua',
	'client/hud_cl.lua'
}

ui_page 'html/ui.html'

files {
	'html/ui.html',
	'html/css/*.css',
	'html/fonts/*.ttf',
	'html/js/*.js',
	'html/img/*.png',
}
