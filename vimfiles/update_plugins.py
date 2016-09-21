
import zipfile
import shutil
import tempfile
import requests

from os import path
import os

#--- Globals ----------------------------------------------
PLUGINS = """
vim-airline https://github.com/bling/vim-airline
""".strip()

# PLUGINS = """
# vim-buftabline https://github.com/ap/vim-buftabline
# csv.vim https://github.com/chrisbra/csv.vim:update
# lightline.vim https://github.com/itchyny/lightline.vim
# SimpylFold https://github.com/tmhedberg/SimpylFold
# nerdtree https://github.com/scrooloose/nerdtree
# syntastic https://github.com/scrooloose/syntastic
# vim-surround https://github.com/tpope/vim-surround
# vim-airline https://github.com/bling/vim-airline
# vim-colors-solarized https://github.com/altercation/vim-colors-solarized
# nerdcommenter https://github.com/scrooloose/nerdcommenter
# tagbar https://github.com/majutsushi/tagbar
# vim-easymotion https://github.com/easymotion/vim-easymotion
# tabular https://github.com/godlygeek/tabular
# vim-snippets https://github.com/honza/vim-snippets
# vim-repeat https://github.com/tpope/vim-repeat
# ctrlp.vim https://github.com/ctrlpvim/ctrlp.vim
# ultisnips https://github.com/sirver/ultisnips
# neocomplete.vim https://github.com/Shougo/neocomplete.vim
# vim-indent-guides https://github.com/nathanaelkane/vim-indent-guides
# vim-unimpaired https://github.com/tpope/vim-unimpaired
# jedi-vim https://github.com/davidhalter/jedi-vim
# gundo.vim https://github.com/sjl/gundo.vim
# taglist.vim https://github.com/vim-scripts/taglist.vim
# rainbow_parentheses.vim https://github.com/kien/rainbow_parentheses.vim
# vim-expand-region https://github.com/terryma/vim-expand-region
# vim-indent-object https://github.com/michaeljsmith/vim-indent-object
# vim-gutentags https://github.com/ludovicchabant/vim-gutentags
# vdebug https://github.com/joonty/vdebug
# """.strip()

GITHUB_ZIP = '%s/archive/master.zip'

SOURCE_DIR = path.join(path.dirname(__file__), 'bundle/')


def download_extract_replace(plugin_name, zip_path, temp_dir, source_dir):
    temp_zip_path = path.join(temp_dir, plugin_name)

    # Download and extract file in temp dir
    req = requests.get(zip_path)
    open(temp_zip_path, 'wb').write(req.content)

    zip_f = zipfile.ZipFile(temp_zip_path)
    zip_f.extractall(temp_dir)

    plugin_temp_path = path.join(temp_dir, '%s-master' % plugin_name)

    # Remove the current plugin and replace it with the extracted
    plugin_dest_path = path.join(source_dir, plugin_name)
    print "installing: " + plugin_dest_path
    try:
        shutil.rmtree(plugin_dest_path)
    except OSError:
        pass
    print "temp path=" + plugin_temp_path
    
    shutil.copytree(plugin_temp_path, plugin_dest_path)

    print('Updated {0}'.format(plugin_name))


def update(plugin):
    name, github_url = plugin.split(' ')
    zip_path = GITHUB_ZIP % github_url
    print "downloading: " + zip_path
    download_extract_replace(name, zip_path,
                             temp_directory, SOURCE_DIR)


if __name__ == '__main__':
    temp_directory = tempfile.mkdtemp()
    [update(x) for x in PLUGINS.splitlines()]
    shutil.rmtree(temp_directory)
