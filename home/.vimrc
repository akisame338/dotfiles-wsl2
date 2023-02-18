" To avoid an unexpected error `E474: Invalid argument: listchars= ... `
" see: https://leokun0210.hatenablog.com/entry/2022/01/06/wsl2%E4%BD%BF%E7%94%A8%E6%99%82%E3%81%ABvim%E3%81%A7%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%82%AA%E3%83%BC%E3%83%97%E3%83%B3%E3%81%99%E3%82%8B%E3%81%A8%E7%99%BA%E7%94%9F%E3%81%99%E3%82%8BE474%3A_Inv
scriptencoding utf-8
set encoding=utf-8

" 行番号を表示する
set number
" カーソルラインを表示
set cursorline
" カーソルが何行目の何列目に置かれているかを表示する
set ruler
" ウインドウのタイトルバーにファイルのパス情報等を表示する
set title
" タブ入力を複数の空白入力に置き換える
set expandtab
" タブ文字の表示幅
set tabstop=4
" Vimが挿入するインデントの幅
set shiftwidth=4
" 行頭の余白内で Tab を打ち込むと、'shiftwidth' の数だけインデントする
set smarttab
" 改行時に前の行のインデントを継続する
set autoindent
" 改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set smartindent
" 不可視文字を表示する
set list
" タブ、空白、改行を可視化する
" see: http://blog.remora.cx/2011/08/display-invisible-characters-on-vim.html
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
" 対応する括弧やブレースを表示する
set showmatch
" 構文毎に文字色を変化させる
syntax on
" 小文字のみで検索したときに大文字小文字を無視する
set smartcase
" 検索結果をハイライト表示する
set hlsearch
" 暗い背景色に合わせた配色にする
set background=dark
" カラースキーマの指定
colorscheme desert
